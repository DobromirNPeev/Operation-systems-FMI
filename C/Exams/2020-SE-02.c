#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <stdio.h>
#include <err.h>

int main(int argc,char* argv[]){
        if(argc!=1){
                errx(1,"Invalid number of arguments");
        }
        int scl=open("input.scl",O_RDONLY);
        if(scl==-1){
                err(2,"Open error");
        }
        int sdl=open("input.sdl",O_RDONLY);
        if(sdl==-1){
                err(2,"Open error");
        }
        int output=open("output.sdl",O_CREAT | O_WRONLY | O_TRUNC,S_IRUSR | S_IWUSR);
        if(output==-1){
                err(2,"Open error");
        }
        uint8_t pos;
        ssize_t readSize;
        while((readSize=read(scl,&pos,sizeof(pos)))>0){
                uint16_t el;
                for(uint8_t mask=1<<7;mask>0;mask>>=1){
                        if((readSize=read(sdl,&el,sizeof(el)))==-1){
                                err(3,"Read error");
                        }
                        if((pos&mask)!=0){
                                if(write(output,&el,sizeof(el))==-1){
                                        err(4,"Write error");
                                }
                        }
                }
        }
        if(readSize==-1){
                err(3,"Read error");
        }
        return 0;
}