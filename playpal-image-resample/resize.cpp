#include "resize.h"

#include "../image-resizer-bmp/src/stb_image.h"
#include "../image-resizer-bmp/src/stb_image_resize2.h"

std::vector<unsigned char> resize(const std::string& filename, int new_width, int new_height)
{
    int width = 0;
    int height = 0;
    int channels = 0;
    std::vector<unsigned char> resized_data(new_width * new_height * 3);

    unsigned char* original_data = stbi_load(filename.c_str(), &width, &height, &channels, 3);
    if (original_data == nullptr)
    {
        return resized_data;
    }

    if (!stbir_resize_uint8_linear(
            original_data, width, height, 0,
            &resized_data[0], new_width, new_height, 0,
            (stbir_pixel_layout)channels)
        )
    {
        stbi_image_free(original_data);
        resized_data.clear();
        return resized_data;
    }

    stbi_image_free(original_data);
    return resized_data;
}