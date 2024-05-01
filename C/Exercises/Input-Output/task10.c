#include <fcntl.h>
#include <unistd.h>
#include <err.h>
#include <string.h>
#include <stdint.h>
#include <sys/stat.h>
#include <stdio.h>

int main(int argc,char* argv[]){
        if(argc!=2){
                errx(1,"Invalid number of arguments");
        }
        unsigned char ans=0;
        int fd=open(argv[1],O_RDONLY);
        if(fd==-1){
                err(3,"Openning err");
        }
        unsigned char  byte;
        ssize_t readSize;
        struct stat s;
        if(fstat(fd,&s)==-1){
                err(4,"Status err");
        }
        if(s.st_size % sizeof(uint16_t) != 0){
                errx(5,"Invalid format");
        }

        while((readSize=read(fd,&byte,sizeof(byte)))>0){
                if(byte>ans){
                        ans=byte;
                }
        }

        if(readSize==-1){
                err(6,"Reading err");
        }

        dprintf(1,"%u\n",ans);

        close(fd);
        return 0;
}
