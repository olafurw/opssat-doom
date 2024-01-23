//
// Copyright(C) 1993-1996 Id Software, Inc.
// Copyright(C) 2005-2014 Simon Howard
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// DESCRIPTION:
//	Random number LUT.
//

//
// M_Random
// Returns a 0-255 number
//

#include <stdlib.h>

#ifndef RANDVAL
#define RANDVAL 0
#endif

#define RNDTABLESIZE 65536
unsigned char* rndtable = 0;

int	rndindex = 0;
int	prndindex = 0;
int totalrngcalls = 0;

void M_AllocateRandom (void)
{
    int i;
    rndtable = malloc (RNDTABLESIZE * sizeof(*rndtable));
    for (i = 0; i < RNDTABLESIZE; i++)
    {
        rndtable[i] = RANDVAL;
    }

    rndindex = prndindex = 0;
    totalrngcalls = 0;
}

void M_FreeRandom (void)
{
    free (rndtable);
}

// Which one is deterministic?
int P_Random (void)
{
    totalrngcalls++;
    prndindex = (prndindex+1)&0xffff;
    return rndtable[prndindex];
}

int M_Random (void)
{
    totalrngcalls++;
    rndindex = (rndindex+1)&0xffff;
    return rndtable[rndindex];
}

void M_ClearRandom (void)
{
    rndindex = prndindex = 0;
}

int TotalRngCalls (void)
{
    return totalrngcalls;
}