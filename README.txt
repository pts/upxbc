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
* Compressing arbitrary i386 flat executables in a position-independent way.
  `flat' means that enough bytes are memory-mapped after the text segment,
  and the text segment is read-write-execute, and the files don't need to
  have a specific header.
* Compressing arbitrary i386 flat executables to GNU assembler .s source
  files, to be included in other programs.
* (--elftiny) Compressing statically linked Linux i386 ELF executables with
  about 1500 bytes smaller output file size than UPX. This is accomplished
  by generating a smaller stub, at the cost of some security.
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

__END__
