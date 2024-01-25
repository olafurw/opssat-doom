#include <iostream>
#include <vector>
#include <array>
#include <cstdint>
#include <algorithm>

#define STB_IMAGE_IMPLEMENTATION
#include "../image-resizer-bmp/src/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "../image-resizer-bmp/src/stb_image_write.h"
#define STB_IMAGE_RESIZE_IMPLEMENTATION
#include "../image-resizer-bmp/src/stb_image_resize2.h"

#include "../dkm/include/dkm.hpp"
#include "../dkm/include/dkm_utils.hpp"

// Normalize RGB values
std::array<float, 3> normalize(const unsigned char* pixel) {
  return {
    pixel[0] / 255.0f,
    pixel[1] / 255.0f,
    pixel[2] / 255.0f
  };
}

// Denormalize RGB values
void denormalize(const std::array<float, 3>& normalized_pixel, unsigned char* pixel) {
  pixel[0] = static_cast<unsigned char>(std::min(255.0f, normalized_pixel[0] * 255.0f));
  pixel[1] = static_cast<unsigned char>(std::min(255.0f, normalized_pixel[1] * 255.0f));
  pixel[2] = static_cast<unsigned char>(std::min(255.0f, normalized_pixel[2] * 255.0f));

  std::cout << static_cast<int>(pixel[0]) << " " << static_cast<int>(pixel[1]) << " " << static_cast<int>(pixel[2]) << std::endl;
}

// Main function
int main(int argc, char* argv[]) {
  if (argc < 3) {
    std::cerr << "Usage: " << argv[0] << " <input_image> <output_image_png>\n";
    return -1;
  }

  // Image i/o
  const char* input_filename = argv[1];
  const char* output_filename = argv[2];

  // Load the image using stb_image
  int width, height, channels;
  unsigned char* original_data = stbi_load(input_filename, &width, &height, &channels, 0);
  if (original_data == nullptr) {
    // Handle error
    return -1;
  }

  // Resize parameters
  int resized_width = width;
  int resized_height = height;
  std::vector<unsigned char> resized_data(resized_width * resized_height * channels);

  // Resize the image
  if (!stbir_resize_uint8_linear(
        original_data, width, height, 0,
        &resized_data[0], resized_width, resized_height, 0,
        (stbir_pixel_layout)channels)) {
    // Handle resize error
    stbi_image_free(original_data);
    return -1;
  }

  // Free the original image data
  stbi_image_free(original_data);

  // Prepare data for clustering (normalize pixel values)
  std::vector<std::array<float, 3>> pixels;
  for (int i = 0; i < resized_width * resized_height * channels; i += channels) {
    pixels.push_back(normalize(&resized_data[i]));
  }

  // Perform k-means clustering with dkm
  auto result = dkm::kmeans_lloyd(pixels, 256);
  const auto& means = std::get<0>(result);

  // Write the centroid color values directly to the resized_data array
  for (int i = 0; i < resized_width * resized_height * channels; i += channels) {
    size_t nearest_center = dkm::predict(means, pixels[i / channels]);
    const auto& centroid = means[nearest_center];

    // Use the denormalize function to convert the normalized centroid values to unsigned char
    // and directly assign them to resized_data
    denormalize(centroid, &resized_data[i]);
  }

  // Write the modified image to a PNG file
  stbi_write_png(output_filename, resized_width, resized_height, channels, &resized_data[0], resized_width * channels);

  return 0;
}