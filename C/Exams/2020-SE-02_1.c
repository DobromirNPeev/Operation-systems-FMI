#include <sys/wait.h>
#include <err.h>
#include <unistd.h>
#include <stdint.h>
#include <fcntl.h>
#include <stdio.h>

int main(int argc,char* argv[]){
        if(argc!=3){
                errx(1,"invalid number of args");
        }
        int p[2];
        if(pipe(p)==-1){
                err(2,"pipe error");
        }
        int pid=fork();
        if(pid==-1){
                err(3,"fork error");
        }
        if(pid==0){
                close(p[0]);
                dup2(p[1],1);
                close(p[1]);
                execlp("cat","cat",argv[1],(char*)NULL);
                err(4,"exec error");
        }

        close(p[1]);
        int fd=open(argv[2],O_WRONLY | O_CREAT | O_TRUNC,0777);
        if(fd==-1){
                err(5,"open error");
        }
        ssize_t readSize;
        uint8_t byte;
        while((readSize=read(p[0],&byte,sizeof(byte)))>0){
                if(byte==0x55){
                        continue;
                }
                if(byte==0x7D){
                        if((readSize=read(p[0],&byte,sizeof(byte)))<0){
                                err(7,"read error");
                        }
                        byte=byte^0x20;
                }

                if(write(fd,&byte,sizeof(byte))==-1){
                        err(6,"write error");
                }
        }
        if(readSize==-1){
                err(7,"read error");
        }
        close(fd);
}
