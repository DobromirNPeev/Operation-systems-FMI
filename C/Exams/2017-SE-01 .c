#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <err.h>
#include <stdint.h>


typedef struct data{
        uint16_t offset;
        uint8_t old;
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
        int fd3=open(argv[3],O_WRONLY | O_TRUNC | O_CREAT,S_IRUSR | S_IWUSR);
        uint16_t offset=0;
        struct stat s1;
        struct stat s2;
        if(fstat(fd1,&s1)==-1){
                err(3,"Stat error");
        }
        if(fstat(fd2,&s2)==-1){
                err(3,"Stat error");
        }
        if(s1.st_size!=s2.st_size){
                errx(4,"Files not the same size");
        }
        ssize_t readSize1;
        ssize_t readSize2;
        uint8_t oldByte;
        uint8_t newByte;
        while((readSize1=read(fd1,&oldByte,sizeof(oldByte)))>0 && (readSize2=read(fd2,&newByte,sizeof(newByte)))>0){
                if(oldByte!=newByte){
                        data toWrite={offset,oldByte,newByte};
                        if(write(fd3,&toWrite,sizeof(toWrite))==-1){
                                err(5,"Write error");
                        }
                }
                offset+=sizeof(uint8_t);
        }
        if(readSize1==-1 || readSize2==-1){
                err(6,"Read error");
        }

        close(fd1);
        close(fd2);
        close(fd3);
        return 0;
}
