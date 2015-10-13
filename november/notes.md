November LUG notes 
=================
_discussion topics/questions_


Crazy C Macro 
-------------
Round up 'a' to next multiple of 'size', which must be a power of 2
#define ROUNDUP (a, size) (((a) & ((size) - 1)) ? (1 + ((a) | ((size) - 1))) : (a))

(size - 1) is equivalent to ~size if size is power of 2
Extra parenthesis because it is a macro (each variable must be parenthesized).

