#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <err.h>
#include <string.h>
#include <stdint.h>
#include <stdbool.h>

int main(int argc,char* argv[]){
        if(argc==1){
                ssize_t readSize;
                char c;
                while((readSize=read(0,&c,sizeof(c)))>0){
                        if(dprintf(1,"%s",&c)<0){
                                err(2,"Write error");
                        }
                }
                if(readSize==-1){
                        err(3,"Read error");
                }
                return 0;
        }
        for(int i=1;i<argc;i++){
                int fd;
                if(strcmp(argv[i],"-")==0){
                        fd=0;
                }
                else{
                        fd=open(argv[i],O_RDONLY);
                        if(fd==-1){
                                err(1,"Open error");
                        }
                }
                ssize_t readSize;
                char c;
                while((readSize=read(fd,&c,sizeof(c)))>0){
                        if(write(1,&c,readSize)==-1){
                                err(2,"Write error");
                        }
                }
                if(readSize==-1){
                        err(3,"Read error");
                }

                if(fd>2){
                        close(fd);
                }
        }
        return 0;
}
