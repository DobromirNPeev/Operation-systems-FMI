#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <err.h>
#include <sys/stat.h>
#include <stdint.h>

typedef struct idx{
        uint16_t offset;
        uint8_t length;
        uint8_t nothing;
} idx;


int main(int argc,char* argv[]){
        if(argc!=5){
                errx(1,"Invalid number of arguments");
        }
        int fd1=open(argv[1],O_RDONLY);
        if(fd1==-1){
                err(2,"Opening error");
        }
        int fd2=open(argv[2],O_RDONLY);
        if(fd2==-1){
                err(2,"Opening error");
        }
        struct stat s;
        if(fstat(fd2,&s)==-1){
                err(3,"Stat error");
        }
        idx index;
        if(s.st_size % sizeof(index) !=0){
                errx(4,"Invalid format");
        }

        int fd3=open(argv[3],O_CREAT | O_TRUNC | O_WRONLY,S_IRUSR | S_IWUSR);
        if(fd3==-1){
                err(2,"Opening error");
        }
        int fd4=open(argv[4],O_CREAT | O_TRUNC | O_WRONLY,S_IRUSR | S_IWUSR);
        if(fd4==-1){
                err(2,"Opening errorr");
        }
        ssize_t readSize;
        uint16_t begin=0;
        uint8_t nothing=0;
        while((readSize=read(fd2,&index,sizeof(index)))>0){
                if(lseek(fd1,index.offset,SEEK_SET)==-1){
                        err(5,"Seek error");
                }
                char c;
                if(read(fd1,&c,sizeof(c))==-1){
                        err(6,"Read error");
                }
                if(c<='A' || c>='Z'){
                        continue;
                }
                if(write(fd3,&c,sizeof(c))==-1){
                        err(7,"Write error");
                }
                uint8_t len=index.length-1;
                while(len>0 && (readSize=read(fd1,&c,sizeof(c)))>0){
                        if(write(fd3,&c,sizeof(c))==-1){
                                err(7,"Write error");
                        }
                        len--;
                }
                if(readSize==-1){
                        err(6,"Read error");
                }
                idx toWrite={begin,index.length,nothing};
                if(write(fd4,&toWrite,sizeof(toWrite))==-1){
                        err(7,"Write error");
                }
                begin+=index.length;
        }

        if(readSize==-1){
                err(6,"Read error");
        }

        close(fd1);
        close(fd2);
        close(fd3);
        close(fd4);
        return 0;
}
