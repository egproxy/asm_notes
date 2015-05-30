
  .file "bn.s"
  .section .text

# Function: bn_new
# Purpose:
#  Create new bn struct and return it
#
  .globl  bn_new
  .type bn_new, @function
bn_new:
  pushl %ebp
  movl  %esp,       %ebp
  subl  $4,         %esp
  movl  $12,        (%esp)
  call  malloc
  movl  $0,         (%eax)    # Set size to 0
  movl  $0,         4(%eax)   # Set numOfLimbs to 0
  movl  $0,         8(%eax)   # Set *d to NULL
  addl  $4,         %esp 
  movl  %ebp,       %esp
  popl  %ebp 
  ret
  .size bn_new, .-bn_new


# Function: bn_free
# Purpose: 
#   Takes a bn struct and zero's out all its data
#   Dynamically allocated d will be freed from the
#   heap. Finally, deallocate the struct
#
  .globl  bn_free
  .type bn_free, @function
bn_free:
  pushl %ebp
  movl  %esp,       %ebp
  subl  $4,         %esp
  movl  8(%ebp),    %ebx      # holds address to struct bn
  cmpl  $0,         8(%ebx)   # check if anything was allocated in *d
  je    BND_EMPTY             # skip on NULL
  movl  8(%ebx),    %eax
  movl  %eax,       (%esp)    # Otherwise, free the heap
  call  free
  BND_EMPTY:
  movl  %ebx,       (%esp)      
  call  free                  # Deallocat the struct
  addl  $4,         %esp      # Clear extra space from stack
  leave
  ret
  .size bn_new, .-bn_new

# Function: bn_hex2bn
# Purpose: 
#   Convert hex string to actual hex and store in provided
#   bn struct. If bn already has something, replace it
# Parameters:
#   8(%ebp) - struct to modify by reference
#   12(%ebp) - hex cstring 
#
  .globl  bn_hex2bn
  .type bn_hex2bn, @function
bn_hex2bn:
  pushl %ebp
  movl  %esp,       %ebp
  subl  $16,        %esp
  movl  8(%ebp),    %eax
  
  cmpl  $0,         8(%eax)   # First, is the struct d empty or does it 
  je    BNH_EMPTY             # need to be dealloc'd
  pushl 8(%eax)
  call  free
  addl  $4,         %esp

  BNH_EMPTY:
  movl  12(%ebp),   %eax      # Get the length of the cstring
  movl  %eax,       (%esp) 
  call  strlen
  cmpl  $0,         %eax
  je    S2HEX_SUCCESS         # if length of hexstring is 0, then do nothing
  movl  %eax,       12(%esp)  # Store [ LEN OF HEXSTR ] in bottom of stack

  xorl  %edx,       %edx      # ceil($strlen / 8) = # of limbs
  movl  $8,         %ebx
  divl  %ebx
  cmpl  $0,         %edx      # ceil operation based on remainder in $edx
  je    NOREMAIN
  incl  %eax                  # $eax holds quotient

  NOREMAIN:
  movl  8(%ebp),    %ebx      
  movl  %eax,       (%ebx)    # set size
  movl  %eax,       4(%ebx)   # set numOfLimbs 
  movl  $4,         %ecx
  mull  %ecx                  # multiply number of elements with uint32_t size
 
  movl  %eax,       (%esp)
  call  malloc
  cmpl  $0,         %eax
  je   FAIL_NOMEM             # malloc returns 0 if there isnt any memory left
  movl  %eax,       8(%ebx)   # store newly allocated into *d

# now need to convert hexstring 8 byte sections at a time and store it in little
# endian format which will be 4 bytes in size. Strategy is to read until 8 bytes
# or end and logical shift right 4 times only if 8 bytes are read
  xorl  %ebx,       %ebx
  movl  $0,         4(%esp)   # endptr for  `strtol`
  movl  $16,        8(%esp)   # base 16 for `strtol`
  movl  12(%esp),   %edx      # [ LEN OF HEXSTR ] will be the loop end
  S2HEX_START:
  movl  $8,         %ecx      # subtract 8 from length
  subl  %edx,       %ecx      # if less than 0, this is the end of loop
  cmpl  $0,         %edx
  #jbe   S2HEX_LP_END
  movl  12(%ebp),   %eax
  
  movl  (%eax,%edx,1), %ebx
  movl  $0,         %bl

  movl  %ebx,       
  call  strtol
  # move 8 bytes to top of stack with null character and call
  # strtol with base 16, store  it in *d and lroll 4
  
  
  movl  %ecx,       %edx 
  jmp S2HEX_START  
  S2HEX_LP_END:
  
  
  S2HEX_SUCCESS:
  xorl %eax, %eax
  jmp S2HEX_END

  FAIL_NOMEM: 
  movl $-1, %eax

  S2HEX_END:
  leave
  ret
  .size bn_hex2bn, .-bn_hex2bn



  .globl  bn_bn2hex
  .type bn_bn2hex, @function
bn_bn2hex:
  push  %ebp
  movl  %esp, %ebp

  # Return -1
  movl  $-1, %eax

  leave
  ret
  .size bn_bn2hex, .-bn_bn2hex

  .globl  bn_add
  .type bn_add, @function
bn_add:
  push  %ebp
  movl  %esp, %ebp

  # Return -1
  movl  $-1, %eax

  leave
  ret
  .size bn_add, .-bn_add

