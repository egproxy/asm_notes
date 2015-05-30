#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

int main(int argc, char* argv[]) {
  
  char d[] = "f00D\0";
  char *end = d+2;
  uint32_t converted; 
  printf("str to be converted: %s\n", d);
  printf("Size of uint32_t: %i\n", sizeof(converted));

  converted = strtol(d, &end, 16); 
  printf("Converted number %04x\n", converted);
  
  return 0;
}
