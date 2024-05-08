#include <fcntl.h>
#include <unistd.h>
#include <err.h>
#include <stdint.h>
#include <stdio.h>
#include <sys/stat.h>

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
        struct stat st;
        if(fstat(input,&st)==-1){
                err(5,"Stat error");
        }
        if(st.st_size%sizeof(uint16_t)!=0){
                errx(6,"Invalid format");
        }
        uint16_t bytes;
        ssize_t readSize;
        while((readSize=read(input,&bytes,sizeof(bytes)))>0){
                uint8_t maskSave=1<<3;
                uint8_t saveByte=0;
                for(uint16_t  mask=1<<15,i=0;i<4;mask>>=1,i++){
                        if((bytes&mask)==0){
                                mask>>=1;
                                //saveByte|=maskSave;
                                maskSave>>=1;
                        }
                        else{
                                mask>>=1;
                                saveByte|=maskSave;
                                maskSave>>=1;
                        }
                }
                maskSave=1<<7;
                for(uint16_t  mask=1<<7,i=0;i<4;mask>>=1,i++){
                        if((bytes&mask)==0){
                                mask>>=1;
                                //saveByte|=maskSave;
                                maskSave>>=1;
                        }
                        else{
                                mask>>=1;
                                saveByte|=maskSave;
                                maskSave>>=1;
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
