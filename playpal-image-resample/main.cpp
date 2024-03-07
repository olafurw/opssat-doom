// waage todo:
// - add the other PLAYPAL palettes to the output file (the different shades)
// - try a version where the the biggest outlier colors replace colors in the PLAYPAL palette, the rest can use the closest color
// - try with different images

#include <array>
#include <vector>
#include <iostream>
#include <set>
#include <unordered_map>
#include <fstream>

#define STB_IMAGE_IMPLEMENTATION
#include "stb/stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb/stb_image_write.h"
#define STB_IMAGE_RESIZE_IMPLEMENTATION
#include "stb/stb_image_resize2.h"

#include "resize.h"
#include "resample.h"
#include "playpal.h"

void update_color_index(const std::set<std::array<unsigned char, 3>>& colors)
{
    std::unordered_map<int, std::vector<std::array<unsigned char, 3>>> closest_colors;

    for (const auto& color : colors)
    {
        const auto closest = closest_color(color[0], color[1], color[2]);
        closest_colors[closest.index].push_back(color);
        if (closest.distance > 100)
        {
            closest_colors[closest.index].push_back({
                closest.r, closest.g, closest.b
            });
        }
    }

    for (const auto& closest : closest_colors)
    {
        // If you only have the main color then there is no need to average
        // Colors index 0, 4 and 247 are special
        if (closest.second.size() < 2 || closest.first == 0 || closest.first == 4 || closest.first == 247)
        {
            continue;
        }
        
        update_color_with_average(closest.first, closest.second);
    }
}

int main(int argc, char* argv[])
{
    if (argc < 2)
    {
        std::cerr << "Usage: " << argv[0] << " <input_image>\n";
        return -1;
    }

    std::cout << "playpal-image-resample starting..." << std::endl;

    const std::string input_filename = argv[1];

    int width = 256;
    int height = 128;
    int channels = 3;

    std::cout << "resampling:" << std::endl;

    const auto resampled_data = resample(
        resize(input_filename, width, height), 
        width, height, channels
    );

    std::cout << "- updating colors." << std::endl;

    std::set<std::array<unsigned char, 3>> colors;
    for (int i = 0; i < width * height * channels; i += channels)
    {
        colors.insert({ 
            resampled_data[i + 0], 
            resampled_data[i + 1], 
            resampled_data[i + 2]
        });
    }

    std::cout << "writing 'sky1.bmp'" << std::endl;

    stbi_write_bmp("sky1.bmp", width, height, channels, &resampled_data[0]);

    std::cout << "running color adjustment passes." << std::endl;

    update_color_index(colors);
    update_color_index(colors);
    update_color_index(colors);
    update_color_index(colors);

    std::cout << "writing 'playpal.lmp'" << std::endl;

    std::ofstream new_playpal("playpal.lmp", std::ios::binary);
    for (int i = 0; i < 256; i++)
    {
        new_playpal.write((char*)&color_index[i][0], 1);
        new_playpal.write((char*)&color_index[i][1], 1);
        new_playpal.write((char*)&color_index[i][2], 1);
    }
    new_playpal.close();

    std::cout << "done." << std::endl;

    return 0;
}