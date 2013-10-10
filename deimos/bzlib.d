module deimos.bzlib2;
/*-------------------------------------------------------------*/
/*--- Public header file for the library.                   ---*/
/*---                                               bzlib.h ---*/
/*-------------------------------------------------------------*/

/* ------------------------------------------------------------------
   This file is part of bzip2/libbzip2, a program and library for
   lossless, block-sorting data compression.

   bzip2/libbzip2 version 1.0.6 of 6 September 2010
   Copyright (C) 1996-2010 Julian Seward <jseward@bzip.org>

   Please read the WARNING, DISCLAIMER and PATENTS sections in the
   README file.

   This program is released under the terms of the license contained
   in the file LICENSE.
   ------------------------------------------------------------------ */


extern(C) nothrow:

enum BZ_RUN               = 0;
enum BZ_FLUSH             = 1;
enum BZ_FINISH            = 2;

enum BZ_OK                = 0;
enum BZ_RUN_OK            = 1;
enum BZ_FLUSH_OK          = 2;
enum BZ_FINISH_OK         = 3;
enum BZ_STREAM_END        = 4;
enum BZ_SEQUENCE_ERROR    = (-1);
enum BZ_PARAM_ERROR       = (-2);
enum BZ_MEM_ERROR         = (-3);
enum BZ_DATA_ERROR        = (-4);
enum BZ_DATA_ERROR_MAGIC  = (-5);
enum BZ_IO_ERROR          = (-6);
enum BZ_UNEXPECTED_EOF    = (-7);
enum BZ_OUTBUFF_FULL      = (-8);
enum BZ_CONFIG_ERROR      = (-9);


   struct bz_stream {
      char *next_in;
      uint avail_in;
      uint total_in_lo32;
      uint total_in_hi32;

      char *next_out;
      uint avail_out;
      uint total_out_lo32;
      uint total_out_hi32;

      void *state;

      void** function(void *,int,int) bzalloc;
      void* function(void *,void *) bzfree;
      void* opaque;
   }

import std.c.stdio;

//#ifdef _WIN32
//#   include <windows.h>
//#   ifdef small
      ///* windows.h define small to char */
//#      undef small
//#   endif
//#   ifdef BZ_EXPORT
//#   define BZ_API(func) WINAPI func
//#   define BZ_EXTERN extern
//#   else
   ///* import windows dll dynamically */
//#   define BZ_API(func) (WINAPI * func)
//#   define BZ_EXTERN
//#   endif
//#else
//#   define BZ_API(func) func
//#   define BZ_EXTERN extern
//#endif


/*-- Core (low-level) library functions --*/

int BZ2_bzCompressInit (
      bz_stream* strm,
      int        blockSize100k,
      int        verbosity,
      int        workFactor
   );

int BZ2_bzCompress (
      bz_stream* strm,
      int action
   );

int BZ2_bzCompressEnd (
      bz_stream* strm
   );

int BZ2_bzDecompressInit (
      bz_stream *strm,
      int       verbosity,
      int       small
   );

int BZ2_bzDecompress (
      bz_stream* strm
   );

int BZ2_bzDecompressEnd (
      bz_stream *strm
   );



/*-- High(er) level library functions --*/

enum BZ_MAX_UNUSED = 5000;

alias void BZFILE;

BZFILE* BZ2_bzReadOpen (
      int*  bzerror,
      FILE* f,
      int   verbosity,
      int   small,
      void* unused,
      int   nUnused
   );

void BZ2_bzReadClose (
      int*    bzerror,
      BZFILE* b
   );

void BZ2_bzReadGetUnused (
      int*    bzerror,
      BZFILE* b,
      void**  unused,
      int*    nUnused
   );

int BZ2_bzRead (
      int*    bzerror,
      BZFILE* b,
      void*   buf,
      int     len
   );

BZFILE* BZ2_bzWriteOpen (
      int*  bzerror,
      FILE* f,
      int   blockSize100k,
      int   verbosity,
      int   workFactor
   );

void BZ2_bzWrite (
      int*    bzerror,
      BZFILE* b,
      void*   buf,
      int     len
   );

void BZ2_bzWriteClose (
      int*          bzerror,
      BZFILE*       b,
      int           abandon,
      uint* nbytes_in,
      uint* nbytes_out
   );

void BZ2_bzWriteClose64 (
      int*          bzerror,
      BZFILE*       b,
      int           abandon,
      uint* nbytes_in_lo32,
      uint* nbytes_in_hi32,
      uint* nbytes_out_lo32,
      uint* nbytes_out_hi32
   );


/*-- Utility functions --*/

int BZ2_bzBuffToBuffCompress (
      char*         dest,
      uint* destLen,
      char*         source,
      uint  sourceLen,
      int           blockSize100k,
      int           verbosity,
      int           workFactor
   );

int BZ2_bzBuffToBuffDecompress (
      char*         dest,
      uint* destLen,
      char*         source,
      uint  sourceLen,
      int           small,
      int           verbosity
   );


/*--
   Code contributed by Yoshioka Tsuneo (tsuneo@rr.iij4u.or.jp)
   to support better zlib compatibility.
   This code is not _officially_ part of libbzip2 (yet);
   I haven't tested it, documented it, or considered the
   threading-safeness of it.
   If this code breaks, please contact both Yoshioka and me.
--*/

const(char*) BZ2_bzlibVersion ();

//#ifndef BZ_NO_STDIO
BZFILE * BZ2_bzopen (
      in char *path,
      in char *mode
   );

BZFILE * BZ2_bzdopen (
      int        fd,
      in char *mode
   );

int BZ2_bzread (
      BZFILE* b,
      void* buf,
      int len
   );

int BZ2_bzwrite (
      BZFILE* b,
      void*   buf,
      int     len
   );

int BZ2_bzflush (
      BZFILE* b
   );

void BZ2_bzclose (
      BZFILE* b
   );

const(char*) BZ2_bzerror(
      BZFILE *b,
      int    *errnum
   );


/*-------------------------------------------------------------*/
/*--- end                                           bzlib.h ---*/
/*-------------------------------------------------------------*/
