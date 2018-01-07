upxbc: UPX-based compressor for execuables and data files
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
upxbc is s Python script for compressing and decompressing executables and
data files, using UPX (https://upx.github.io/) as a backend.

Features:

* Compressing and decompressing ELF, Windows EXE and DOS EXE files. UPX is
  called directly for this, without pre- or post-processing.
* Compressing Syslinux COM32R (.c32) executables.
* Compressing and decompressing arbitrary binary data files to the UPXZ
  format (which is specific to upxbc).
* (--flat32 and --flat16) Compressing arbitrary i386 32-bit and 16-bit flat
  executables in a position-independent way. `flat' means that enough bytes
  are memory-mapped after the text segment, and the text segment is
  read-write-execute, and the files don't need to have a specific header.
  This is usable for compressing bootloaders and memtest.
* Compressing arbitrary i386 flat executables to GNU assembler .s source
  files, to be included in other programs.
* (--elftiny) Compressing statically linked Linux i386 ELF executables with
  about 1500 bytes smaller output file size than UPX. This is accomplished
  by generating a smaller stub, at the cost of some runtime security.
* (--elfstrip) Removing section headers and other stuff from ELF32
  executables. This is a supercharged `strip -s', similar to sstrip(1).
* It works better for small files (as small as 512 bytes), where UPX refuses
  to do anything.

Requirements and compatibility:

* upxbc has been tested on Linux, but it probably runs on other Unix
  systems, and with a few changes it may also run on Windows.
* Python 2.4, 2.5, 2.6 or 2.7 is needed.
* UPX 3.94 is needed. Probably earlier or later versions also work. No need
  to recompile, an unmodified binary works just fine.

Usage on Linux, macOS and other Unix systems:

  # Install Python and UPX first.
  $ upx -V
  ...
  $ curl -O https://raw.githubusercontent.com/pts/upxbc/master/upxbc
  $ chmod 755 ./upxbc
  $ ./upxbc INPUTFILE
  $ ./upxbc --elftiny INPUTPROG
  $ ./upxbc -f -o OUTPUTFILE.c32 INPUTFILE.c32

Why use upxbc instead vanilla UPX?

* upxbc enables strongest compression (smallest output file) by default:
  upx --ultra-brute --lzma.
* upxbc refuses to run if conflicting compression flags are specified (e.g.
  --nrv2b and --lzma).
* upxbc also works on very small files (i.e. smaller than 512 bytes), for
  which UPX refuses to operate. Please note that most of the time it won't
  be able to make such files smaller, but sometimes it can.
* `upxbc --elftiny' can produces Linux i386ELF executables which are about
  1500 bytes smaller than what UPX would produce. This is accomplished
  by generating a smaller stub, at the cost of some runtime security.
* `upxbc --upxz' works as a general-purpose compressor, it only adds a
  minimal header (no decompressor) to the existing file.
* `upxbc --c32' can compress Syslinux COM32R (.c32) executables.
* `upxbc --flat32' can compress any i386 flat executable, even
  those without any header.
* `upxbc --flat16' can compress any i386 16-bit flat executable, even
  those without any header. (The flat16 signature needs to be present
  in the exectuable, and there are some alignment requirements, see the
  docstring of the compress_flat16 function.)
* `upxbc --asm' can generate .s source files containing the compressed
  data and the i386 decompressor, which GCC and other tools can understand,
  so you can add compressed data to your program, and make it decompress
  it on the fly.

Disadvantages of upxbc:

* Has Python (2.4, 2.5, 2.6 or 2.7) as an additional dependency.
* Stores 2 extra copies of the input file and 2 copies of the output file
  in memory, so it's not suitable for very large files.
* It doesn't support all file formats supported by UPX.

The license of upxbc is GNU GPL v2 or newer.

__END__
