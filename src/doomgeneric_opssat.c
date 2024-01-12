#include "doomkeys.h"
#include "m_argv.h"
#include "doomgeneric.h"
#include "g_game.h"

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
static int killcount = 0;

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

void WriteFrameToDisk()
{
    char* filename = (char*)malloc(37 * sizeof(char));
    sprintf(filename, "toGround/run-%06d/frame-%06d.jpg", runid, frames);
    stbi_write_jpg(filename, DOOMGENERIC_RESX, DOOMGENERIC_RESY, 4, DG_ScreenBuffer, 100);
    free(filename);
}

void DG_DrawFrame()
{
    int current_killcount;
    current_killcount = G_GetPlayerKillCount();

    if (current_killcount != killcount)
    {
        killcount = current_killcount;
        WriteFrameToDisk ();
    }

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