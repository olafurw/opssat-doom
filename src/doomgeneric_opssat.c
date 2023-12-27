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

void DG_Init()
{
}

void DG_DrawFrame()
{
    char* filename = (char*)malloc(24 * sizeof(char));
    sprintf(filename, "output/output%06d.bmp", frames);
    stbi_write_bmp(filename, DOOMGENERIC_RESX, DOOMGENERIC_RESY, 4, DG_ScreenBuffer);
    free(filename);

    frames++;
}

void DG_SleepMs(uint32_t ms)
{
}

uint32_t DG_GetTicksMs()
{
    ticks += 100;
    return ticks;
}

int DG_GetKey(int* pressed, unsigned char* doomKey)
{
    return 0;
}

void DG_SetWindowTitle(const char * title)
{
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