September LUG notes 
===================

group dev idea
--------------
github gaming script. Script the github dev process in order to have it appear
that work is done 7 days a week. creat, modify , commit, push origin. Use random
number of commits and file of commit messages.

*OUT OF SYNC WITH LAPTOP*

Follow up from last LUG meet 
----------------------------
* linuxdriverproject.org
* Care required when measuring system resources on read/write. OS caches files
  in core so consecutive IO has different access times.

Wrote/Found/Learnt
------------------
wrote: newchapter.sh apue/ch4/traverse-chdir.c
found: rustup.sh
learnt: directory permission bits. 

Questions 
---------
1. `man which` Check the example function: WTF?
2. Why does the C standard tend to embed structure names in struct elements?
   They have their own scope so it seems unnecessary. e.g `man getpwuid`
   *Related Question* Why do standard headers us __ names for argument names,
   also these have their own scope?
