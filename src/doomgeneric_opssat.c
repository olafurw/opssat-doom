#include "doomkeys.h"
#include "m_argv.h"
#include "doomgeneric.h"
#include "g_game.h"
#include "m_random.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

#include <stdio.h>
#include <time.h>
#include <unistd.h>

#include <stdbool.h>
#include <sys/stat.h>
#include <errno.h>

static int ticks = 0;
static int frames = 0;
static int runid = 0;
//static int killcount = 0;

void DG_Init()
{
    int result;
    int p;
    p = M_CheckParmWithArgs("-runid", 1);
    if (p)
    {
        runid = atoi(myargv[p + 1]);
    }

    char* toGroundDir = (char*)malloc(9 * sizeof(char));
    sprintf(toGroundDir, "toGround");
    result = mkdir(toGroundDir, 0755);
    free(toGroundDir);

    char* dirname = (char*)malloc(20 * sizeof(char));
    sprintf(dirname, "toGround/run-%06d", runid);
    result = mkdir(dirname, 0755);
    free(dirname);

    if (result == -1 && errno != EEXIST)
    {
        printf("Error creating directory (%d): %s\n", errno, dirname);
        exit(1);
    }
}

void WriteFrameToDisk(int id, int frameid)
{
    char* filename = (char*)malloc(37 * sizeof(char));
    sprintf(filename, "toGround/run-%06d/frame-%06d.jpg", id, frameid);

    stbi_write_jpg(filename, DOOMGENERIC_RESX, DOOMGENERIC_RESY, 4, DG_ScreenBuffer, 100);
    free(filename);
}

int DG_ShouldDrawFrame()
{
    frames++;
    return (runid == 1 && frames == 1911)
        || (runid == 2 && frames == 2113)
        || (runid == 3 && frames == 1624)
        || (runid == 4 && frames == 1234)
        || (runid == 5 && frames == 6560)
        || (runid == 6 && frames == 24695)
        || (runid == 7 && frames == 2320);
}

void DG_DrawFrame()
{
    WriteFrameToDisk(runid, frames);
}

void DG_SleepMs(uint32_t ms)
{
}

uint32_t DG_GetTicksMs()
{
    ticks += 30;
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
    M_AllocateRandom();
    
    doomgeneric_Create(argc, argv);

    while (1)
    {
        doomgeneric_Tick();
    }

    M_FreeRandom();

    return 0;
}