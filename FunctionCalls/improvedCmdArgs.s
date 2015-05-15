# This program prints out all the arguments from the console
# using a loop
#
# +------------+  
# |  argv+ctr  |             } 
# +------------+  +12        }
# |  curr ctr  |             } this is 16 bytes
# +------------+  +8         } in total so
# |  max ctr   |             } subl $16, %esp
# +------------+  +4         } 
# |  cstr LCO  |             }  
# +------------+  <-- %esp   

  .section .data
  
LC0: 
  .ascii "Argument %i/%i : %s\n\0"

  .section .text
  .globl main

main:
  pushl    %ebp               # save base pointer
  movl     %esp,    %ebp      # set stack starting address as new ebp

  andl     $-16,    %esp      # not needed, but this aligns stack to 
                              # the next paragraph boundary
  subl     $16,     %esp      # 4 bytes for argv
                              # 4 bytes for max counter 
                              # 4 bytes for current counter
                              # 4 bytes for the LCO cstr
                              # %edi holds counter
                              # %eax reserved for printf return 
                              # %ebx holds max counter for compare
                              # %ecx holds start of argv
                              # %edx holds indexed argv
                            
  # INITIALIZATION
  # --------------
  # Don't need to worry about changing these 
  # Only current counter(%edi) and argv[i](%edx) need to be updated

  movl    8(%ebp),  %ebx      
  movl    %ebx,     8(%esp)   # store max counter at %esp + 8

  movl    $LC0,     (%esp)    # store LC0 cstr at top of stack
  movl    $0,       %edi      # set current counter to 0

  # START LOOP
  enterloop:
    movl     %edi,            4(%esp)     # pass current counter as 2nd arg
    addl     $1,              4(%esp)
    movl     12(%ebp),        %ecx        # hold address to start of argv
    movl     (%ecx, %edi, 4), %edx        # index addressing of argv
    movl     %edx,            12(%esp)    # move current argv to the stack
    call     printf
    incl     %edi                         # increment current counter
    cmpl     %edi,            %ebx        # this will subtract %edi and %ebx
    jne      enterloop                    # If ZF(zero flag) != 0 

  movl    $1,       %eax
  movl    $0,       %ebx
  int     $0x80
