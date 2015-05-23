Unix File Handling with GAS
---------------------------
  
Opening a File:  
  %eax - syscall number for open (5)
  %ebx - Address of first character in filename  
  %ecx - Mode for file handle <fcntl.h>
  %edx - File permision octal

Return:
  %eax - file descriptor number or negative on fail
