# Image Resizer

- A simple image resizer that uses the [stb library](https://github.com/georgeslabreche/stb).
- The format of the resized output is in bmp.

## Build

- Initialize and update the stb Git submodule: `git submodule init && git submodule update`.
- Compile with `make`. Can also compile for ARM architecture with `make TARGET=arm`.

## Usage

```bash
./resize --help
```

## Future Work

Specify other output formats other than jpeg. Simple use the available stb write functions:

```c
int stbi_write_png(char const *filename, int w, int h, int comp, const void *data, int stride_in_bytes);
int stbi_write_jpg(char const *filename, int w, int h, int comp, const void *data);
int stbi_write_tga(char const *filename, int w, int h, int comp, const void *data);
int stbi_write_jpg(char const *filename, int w, int h, int comp, const void *data, int quality); /* we use this one */
int stbi_write_hdr(char const *filename, int w, int h, int comp, const float *data);
```
