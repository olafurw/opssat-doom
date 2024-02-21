#include "resample.h"

#include "dkm/dkm.hpp"
#include "dkm/dkm_utils.hpp"

#include <array>

std::array<float, 3> normalize(const unsigned char* pixel)
{
    return {
        pixel[0] / 255.0f,
        pixel[1] / 255.0f,
        pixel[2] / 255.0f
    };
}

void denormalize(const std::array<float, 3>& normalized_pixel, unsigned char* pixel)
{
    pixel[0] = static_cast<unsigned char>(std::min(255.0f, normalized_pixel[0] * 255.0f));
    pixel[1] = static_cast<unsigned char>(std::min(255.0f, normalized_pixel[1] * 255.0f));
    pixel[2] = static_cast<unsigned char>(std::min(255.0f, normalized_pixel[2] * 255.0f));
}

std::vector<unsigned char> resample(std::vector<unsigned char> data, int width, int height, int channels)
{
    // Prepare data for clustering (normalize pixel values)
    std::vector<std::array<float, 3>> pixels;
    for (int i = 0; i < width * height * channels; i += channels)
    {
        pixels.push_back(normalize(&data[i]));
    }

    // Perform k-means clustering with dkm
    dkm::clustering_parameters<float> params(256);
    auto result = dkm::kmeans_lloyd(pixels, params);
    const auto& means = std::get<0>(result);

    // Write the centroid color values directly to the resized_data array
    for (int i = 0; i < width * height * channels; i += channels)
    {
        size_t nearest_center = dkm::predict(means, pixels[i / channels]);
        const auto& centroid = means[nearest_center];

        // Use the denormalize function to convert the normalized centroid values to unsigned char
        // and directly assign them to resized_data
        denormalize(centroid, &data[i]);
    }

    return data;
}