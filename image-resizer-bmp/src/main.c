#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/* define convenience macros */
#define streq(s1,s2)    (!strcmp ((s1), (s2)))

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define STB_IMAGE_RESIZE2_IMPLEMENTATION
#include "stb_image_resize2.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

int main(int argc, char *argv [])
{
    /* function return code to track errors */
    int rc = 0;

    /* get provider host and port from command arguments */
    int argv_index_input = -1;
    int argv_index_xsize = -1;
    int argv_index_ysize = -1;
    int argv_index_channels = -1;
    int argv_index_output = -1;

    // --------------------------------------------------------------------------
    // parse the command arguments (all arguments are optional)

    int argn;
    for (argn = 1; argn < argc; argn++)
    {
        if (streq (argv [argn], "--help")
        ||  streq (argv [argn], "-?"))
        {
            printf("sepp_tm_app [options] ...");
            printf("\n  --input    / -i        input image filename");
            printf("\n  --xsize    / -x        target width");
            printf("\n  --ysize    / -y        target height");
            printf("\n  --channels / -c        desired channels");
            printf("\n  --output   / -o        output image filename");
            printf("\n  --help     / -?        this information\n\n");
            
            /* program exit code */
            return 1;
        }
        else
        if (streq (argv [argn], "--input")
        ||  streq (argv [argn], "-i"))
            argv_index_input = ++argn;
        else
        if (streq (argv [argn], "--xsize")
        ||  streq (argv [argn], "-x"))
            argv_index_xsize = ++argn;
        else
        if (streq (argv [argn], "--ysize")
        ||  streq (argv [argn], "-y"))
            argv_index_ysize = ++argn;
        else
        if (streq (argv [argn], "--channels")
        ||  streq (argv [argn], "-c"))
            argv_index_channels = ++argn;
        else
        if (streq (argv [argn], "--output")
        ||  streq (argv [argn], "-o"))
            argv_index_output = ++argn;
        else
        {
            /* print error message */
            printf("Unknown option: %s\n\n", argv[argn]);

            /* program exit code */
            return 1;
        }
    }

     /* check if mandatory arguments were provided */
    if (argv_index_input < 0 || argv_index_xsize < 0 || argv_index_ysize < 0 || 
        argv_index_channels < 0 || argv_index_output < 0)
    {
        printf("Missing options, try: ./resize --help\n");

        /* program exit code */
        return 1;
    }

    /* these properties from the input image will be read from the file when invoking stbi_load */
    int img_xsize;
    int img_ysize;
    int img_channels_infile;

    /* target properties for the resized image */
    int img_xsize_target = atoi(argv[argv_index_xsize]);
    int img_ysize_target = atoi(argv[argv_index_ysize]);
    int img_channels_desired = atoi(argv[argv_index_channels]);
    
    /* decode the image file */
    uint8_t *img_buffer = (uint8_t*)stbi_load(argv[argv_index_input], &img_xsize, &img_ysize, &img_channels_infile, img_channels_desired);

    /* initialize resized image buffer to target size */
    int img_buffer_resized_size = img_xsize_target * img_ysize_target * img_channels_desired;
    uint8_t img_buffer_resized[img_buffer_resized_size];

    /* downsample the image i.e., resize the image to a smaller dimension */
    rc = stbir_resize_uint8_linear(
        img_buffer, img_xsize, img_ysize, 0, 
        img_buffer_resized, img_xsize_target, img_ysize_target, 0, 
        (stbir_pixel_layout)img_channels_desired
    );
    
    /* returned result is 1 for success or 0 in case of an error */
    if(rc == 0)
    {   
        /* print error message in case of error */
        printf("Error code %d when attempting to resize the image\n", rc);
    }
    else
    {
        /* image successfully resized in memory */
        /* write image to file */
        rc = stbi_write_bmp(argv[argv_index_output], img_xsize_target, img_ysize_target, img_channels_desired, (void *)img_buffer_resized);
    }

    /* the stb_write functions returns 0 on failure and non-0 on success. */
    if(rc == 0)
    {
        /* print error message in case of error */
        printf("Error code %d when attempting to write the resized image\n", rc);
    }
    else
    {
        /* success message */
        printf("Resized: %d x %d --> %d x %d\n", img_xsize, img_ysize, img_xsize_target, img_ysize_target);
    } 

    /* free the input image data buffer */
    stbi_image_free(img_buffer);

    /* end program */
    return 0;
}