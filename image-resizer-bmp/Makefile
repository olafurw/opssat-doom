TARGET = dev

# Compiler options.
CC_DEV = gcc
CC_ARM = /usr/bin/arm-linux-gnueabihf-gcc

# Header includes.
INCLUDEPATH = -Istb

# Flags.
CFLAGS = -Wall -static -O3

# Library flags
LIBFLAGS = -lm

# Source directory and files.
SOURCEDIR = src
HEADERS := $(wildcard $(SOURCEDIR)/*.h)
SOURCES := $(wildcard $(SOURCEDIR)/*.c)

# Target output.
BUILDTARGET = resize

# Target compiler environment.
ifeq ($(TARGET),arm)
	CC = $(CC_ARM)
else
	CC = $(CC_DEV)
endif

all:
	$(CC) $(CFLAGS) $(INCLUDEPATH) $(HEADERS) $(SOURCES) -o $(BUILDTARGET) $(LIBFLAGS)

clean:
	rm -f $(BUILDTARGET)