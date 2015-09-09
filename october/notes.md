October LUG notes 
=================
_discussion topics/questions_

* Getting Valgrind error from calls to pthread_create.
files: threads/thread_ids.c
   $ make ids  
   $ ./thread_ids  
   $ valgrind --leak-check=yes ./thread_ids
   $ valgrind -v --leak-check=yes ./thread_ids  

Man Page Problem
----------------
###problem:#
man page missing for pthread_barrier_init?

###Solution:#
1. investigate: pthread_barrier_destroy includes pthread_barrier_init 
$ man -k pthread_barrier

2. locate man pages (use tree -L 1, grep and find): /usr/share/man/man3

3. get name of file: pthread_barrier_destroy.3p.gz
$ ls | grep 'barrier'

4. add soft link
$ ln -s pthread_barrier_destroy pthread_barrier_init
$ mandb <!-- update databse -->

Question:
To whom should I direct this fix so it can be pushed upstream, Distro
maintainer?

