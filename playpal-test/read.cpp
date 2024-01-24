#include <fstream>
#include <sstream>
#include <vector>
#include <iostream>

int main(int argc, char* argv[])
{
    std::ifstream file("playpal.lmp", std::ios::binary);
    std::ifstream new_playpal("new_playpal.txt");

    std::vector<unsigned char> new_playpal_buffer;
    new_playpal_buffer.reserve(256 * 3);

    std::string line;
    while (std::getline(new_playpal, line)) {
        std::istringstream iss(line);
        int r, g, b;
        iss >> r >> g >> b;

        new_playpal_buffer.push_back(static_cast<unsigned char>(r));
        new_playpal_buffer.push_back(static_cast<unsigned char>(g));
        new_playpal_buffer.push_back(static_cast<unsigned char>(b));
    }

    std::vector<unsigned char> buffer(std::istreambuf_iterator<char>(file), {});

    std::ofstream outputFile("new_playpal.lmp", std::ios::binary);

    for (int i = 0; i < buffer.size(); i++) {
        if (i < 256) {
            outputFile.write(reinterpret_cast<const char*>(&new_playpal_buffer[i]), 1);
        } else {
            outputFile.write(reinterpret_cast<const char*>(&buffer[i]), 1);
        }
    }

    outputFile.close();

    return 0;
}