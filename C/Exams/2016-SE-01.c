#include <fcntl.h>
#include <unistd.h>
#include <err.h>
#include <stdio.h>

int main(int argc,char* argv[]){
        if(argc!=2){
                errx(1,"Invalid number of arguments");
        }

        int fd=open(argv[1],O_RDWR);
        if(fd==-1){
                err(2,"Opening error");
        }
        char currByte;
        char nextByte;
        ssize_t readSize;
        int i=0;

        //SS Sort
        while((readSize=read(fd,&currByte,sizeof(currByte)))>0){
                int j=i;
                if(lseek(fd,i+1,SEEK_SET)==-1){
                        err(3,"Seeking error");
                }
                int innerJ=i+1;
                while((readSize=read(fd,&nextByte,sizeof(nextByte)))>0){
                        if(nextByte<currByte){
                                currByte=nextByte;
                                j=innerJ;
                        }
                        innerJ++;
                }

                if(readSize==-1){
                        err(6,"Reading error");
                }
                if(i!=j){
                        if(lseek(fd,i,SEEK_SET)==-1){
                                err(3,"Seeking error");
                        }
                        if(read(fd,&nextByte,sizeof(nextByte))==-1){
                                err(4,"Reading error");
                        }
                        if(lseek(fd,-1,SEEK_CUR)==-1){
                                err(3,"Seeking error");
                        }
                        if(write(fd,&currByte,sizeof(currByte))==-1){
                                err(5,"Writing error");
                        }
                        if(lseek(fd,j,SEEK_SET)==-1){
                                err(3,"Seeking error");
                        }
                        if(write(fd,&nextByte,sizeof(nextByte))==-1){
                                err(5,"Writing error");
                        }
                }
                i++;
                if(lseek(fd,i,SEEK_SET)==-1){
                        err(3,"Seeking error");
                }
        }

        if(readSize==-1){
                err(6,"Reading error");
        }
        close(fd);

        return 0;
}
