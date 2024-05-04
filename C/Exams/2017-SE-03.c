#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <err.h>
#include <unistd.h>
#include <sys/stat.h>

typedef struct data{
        uint16_t offset;
        uint8_t orig;
        uint8_t new;
} __attribute__((packed)) data;

int main(int argc,char* argv[]){
        if(argc!=4){
                errx(1,"Invalid number of arguments");
        }
        int fd1=open(argv[1],O_RDONLY);
        if(fd1==-1){
                err(2,"Open error");
        }
        int fd2=open(argv[2],O_RDONLY);
        if(fd2==-1){
                err(2,"Open error");
        }
        int fd3=open(argv[3],O_WRONLY | O_CREAT | O_TRUNC,S_IRUSR | S_IWUSR);
        if(fd3==-1){
                err(2,"Open error");
        }
        struct stat st;
        if(fstat(fd1,&st)==-1){
                err(3,"Stat error");
        }
        if(st.st_size%sizeof(data)!=0){
                errx(4,"Invalid format");
        }
        data d;
        if(fstat(fd2,&st)==-1){
                err(3,"Stat error");
        }
        ssize_t readSize;
        while((readSize=read(fd1,&d,sizeof(d)))>0){
                if(d.offset>st.st_size){
                        errx(5,"Offset is larger than file size");
                }
                if(lseek(fd2,d.offset,SEEK_SET)==-1){
                        err(6,"Seek error");
                }
                uint8_t byte;
                if(read(fd2,&byte,sizeof(byte))==-1){
                        err(7,"Read error");
                }
                if(byte!=d.orig){
                        errx(8,"Different original bytes");
                }
        }
        if(readSize==-1){
                err(7,"Read error");
        }
        if(lseek(fd1,0,SEEK_SET)==-1){
                err(6,"Seek error");
        }
        if(lseek(fd2,0,SEEK_SET)==-1){
                err(6,"Seek error");
        }
        uint8_t arr[4096];
        while((readSize=read(fd2,arr,sizeof(arr)))>0){
                if(write(fd3,arr,readSize)==-1){
                        err(9,"Write error");
                }
        }
        if(readSize==-1){
                err(7,"Read error");
        }
        while((readSize=read(fd1,&d,sizeof(d)))>0){
                if(lseek(fd3,d.offset,SEEK_SET)==-1){
                        err(6,"Seek error");
                }
                if(write(fd3,&d.new,sizeof(d.new))==-1){
                        err(9,"Write error");
                }
        }
        if(readSize==-1){
                err(7,"Read error");
        }

        close(fd1);
        close(fd2);
        close(fd3);

        return 0;
}