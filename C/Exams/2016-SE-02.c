#include <fcntl.h>
#include <unistd.h>
#include <err.h>
#include <stdint.h>
#include <sys/stat.h>
#include <stdio.h>

int main(int argc,char* argv[]){

        if(argc!=4){
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
        int fd3=open(argv[3],O_CREAT | O_TRUNC | O_WRONLY,S_IRUSR | S_IWUSR);
        if (fd3==-1){
                err(2,"Opening error");
        }
        struct stat s;
        if(fstat(fd1,&s)==-1){
                err(3,"Stat error");
        }
        if(s.st_size % (sizeof(uint32_t)*2)!=0){
                errx(4,"Invalid format");
        }
        uint32_t pair[2];
        ssize_t readSize;
        while((readSize=read(fd1,pair,sizeof(pair)))>0){
                if(lseek(fd2,pair[0],SEEK_SET)==-1){
                        err(5,"Seeking error");
                }
                uint32_t curr;
                for(uint32_t i=0;i<pair[1];i++){
                        if(read(fd2,&curr,sizeof(curr))==-1){
                                err(6,"Reading error");
                        }
                        if(write(fd3,&curr,sizeof(curr))==-1){
                                err(7,"Writing error");
                        }
                }
        }
        if(readSize==-1){
                err(6,"Writing error");
        }
        close(fd1);
        close(fd2);
        close(fd3);
        return 0;
}
