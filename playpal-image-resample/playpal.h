#ifndef PLAYPAL_H
#define PLAYPAL_H

#include <utility>
#include <vector>
#include <array>

struct closest_color_result
{
    int index;
    int distance;
    unsigned char r;
    unsigned char g;
    unsigned char b;
};

closest_color_result closest_color(unsigned char r, unsigned char g, unsigned char b);
void update_color_with_average(int index, const std::vector<std::array<unsigned char, 3>>& colors);

// doom playpal color index
extern unsigned char color_index[256][3];

#endif
