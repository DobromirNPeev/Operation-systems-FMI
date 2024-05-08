#include <fcntl.h>
#include <unistd.h>
#include <err.h>
#include <stdint.h>
#include <stdio.h>

int main(int argc,char* argv[]){
        if(argc!=3){
                errx(1,"Invalid number of arguments");
        }
        int input=open(argv[1],O_RDONLY);
        if(input==-1){
                err(2,"Open error");
        }
        int output=open(argv[2],O_WRONLY | O_CREAT | O_TRUNC,S_IRUSR | S_IWUSR);
        if(output==-1){
                err(2,"Open error");
        }
        uint8_t byte;
        ssize_t readSize;
        while((readSize=read(input,&byte,sizeof(byte)))>0){
                uint16_t maskSave=1<<15;
                uint16_t saveByte=0;
                for(uint8_t mask=1<<7;mask>0;mask>>=1){
                        if((byte&mask)==0){
                                maskSave>>=1;
                                saveByte|=maskSave;
                                maskSave>>=1;
                        }
                        else{
                                saveByte|=maskSave;
                                maskSave>>=2;
                        }
                }
                if(write(output,&saveByte,sizeof(saveByte))==-1){
                        err(4,"Write error");
                }
        }
        if(readSize==-1){
                err(3,"Read error");
        }
}
