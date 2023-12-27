//doomgeneric for cross-platform development library 'Simple DirectMedia Layer'

#include "doomkeys.h"
#include "m_argv.h"
#include "doomgeneric.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

#include <stdio.h>
#include <unistd.h>

#include <stdbool.h>

static int ticks = 0;
static int frames = 0;

void BGRtoRGB(unsigned char* bgrBuffer, unsigned char* rgbBuffer, int width, int height)
{
    int numPixels = width * height;
    for (int i = 0; i < numPixels; i += 3)
    {
        // Convert BGR to RGB pixel-wise
        unsigned char blue = bgrBuffer[i];
        unsigned char green = bgrBuffer[i + 1];
        unsigned char red = bgrBuffer[i + 2];

        // Assign values to the RGB buffer in the correct order
        rgbBuffer[i] = red;
        rgbBuffer[i + 1] = green;
        rgbBuffer[i + 2] = blue;
    }
}

void convertBGRtoRGB(unsigned char *bgrBuffer, unsigned char *rgbBuffer, int width, int height)
{
    int numPixels = width * height;
    for (int i = 0; i < numPixels; i += 3)
    {
        // Swap the positions of the red and blue components
        unsigned char temp = bgrBuffer[i];
        bgrBuffer[i] = bgrBuffer[i + 2];
        bgrBuffer[i + 2] = temp;

        // Copy the data into the RGB buffer
        rgbBuffer[i] = bgrBuffer[i];
        rgbBuffer[i + 1] = bgrBuffer[i + 1];
        rgbBuffer[i + 2] = bgrBuffer[i + 2];
    }
}

void DG_Init()
{
    printf("DG_Init\n");
    //texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGB888, SDL_TEXTUREACCESS_TARGET, DOOMGENERIC_RESX, DOOMGENERIC_RESY);
}

void DG_DrawFrame()
{
    //SDL_UpdateTexture(texture, NULL, DG_ScreenBuffer, DOOMGENERIC_RESX*sizeof(uint32_t));
    printf("DG_DrawFrame\n");

    //unsigned char* rgbBuffer = (unsigned char*)malloc(DOOMGENERIC_RESX * DOOMGENERIC_RESY * 4);
    //convertBGRtoRGB(DG_ScreenBuffer, rgbBuffer, DOOMGENERIC_RESX, DOOMGENERIC_RESY);
    
    char* filename = (char*)malloc(23 * sizeof(char));
    sprintf(filename, "output/output%06d.bmp", frames);
    stbi_write_bmp(filename, DOOMGENERIC_RESX, DOOMGENERIC_RESY, 4, DG_ScreenBuffer);
    free(filename);

    frames++;
}

void DG_SleepMs(uint32_t ms)
{
    //printf("DG_SleepMs\n");
}

uint32_t DG_GetTicksMs()
{
    ticks += 10000;
    return ticks;
}

int DG_GetKey(int* pressed, unsigned char* doomKey)
{
    return 0;
}

void DG_SetWindowTitle(const char * title)
{
    printf("DG_SetWindowTitle\n");
}

int main(int argc, char **argv)
{
    doomgeneric_Create(argc, argv);

    while (1)
    {
        doomgeneric_Tick();
    }

    return 0;
}