#include <unistd.h>
#include <fcntl.h>
#include <err.h>
#include <stdint.h>
#include <stdbool.h>

typedef struct header{
        uint32_t magic;
        uint8_t headerVersion;
        uint8_t dataVersion;
        uint16_t count;
        uint32_t reserved1;
        uint32_t reserved2;
}__attribute__((packed)) header;

typedef struct version00{
        uint16_t offset;
        uint8_t orig;
        uint8_t new;
}__attribute__((packed)) version00;

typedef struct version01{
        uint32_t offset;
        uint16_t orig;
        uint16_t new;
}__attribute__((packed)) version01;

int main(int argc,char* argv[]){
        if(argc!=4){
                errx(1,"Invalid number of arguments");
        }
        int patchFd=open(argv[1],O_RDONLY);
        if(patchFd==-1){
                err(2,"Open error");
        }
        int fd1=open(argv[2],O_RDONLY);
        if(fd1==-1){
                err(2,"Open error");
        }
        int fd2=open(argv[3],O_WRONLY | O_CREAT | O_TRUNC,S_IRUSR | S_IWUSR);
        if(fd2==-1){
                err(2,"Open error");
        }
        header h;
        ssize_t readSize;
        if((readSize=read(patchFd,&h,sizeof(h)))==-1){
                err(3,"Read error");
        }
        if(readSize%sizeof(header)!=0){
                errx(4,"Header is in invalid format");
        }
        if(h.magic!=0xEFBEADDE){
                errx(5,"Wrong specification");
        }
        if(h.headerVersion!=0x01){
                errx(6,"Invalid header version");
        }
        char c[4096];
        while((readSize=read(fd1,c,sizeof(c)))>0){
                if(write(fd2,c,readSize)==-1){
                        err(7,"Write error");
                }
        }
        if(readSize==-1){
                err(3,"Read error");
        }
        if(h.dataVersion==0x00){
                version00 v;
                for(int i=0;i<h.count;i++){
                        if(read(patchFd,&v,sizeof(v))==-1){
                                err(3,"Read error");
                        }
                        if(lseek(fd1,v.offset,SEEK_SET)==-1){
                                err(8,"Seek error");
                        }
                        uint8_t byte;
                        if(read(fd1,&byte,sizeof(byte))==-1){
                                err(3,"Read error");
                        }
                        if(byte!=v.orig){
                                errx(9,"Original byte is different");
                        }
                }
                if(lseek(patchFd,16,SEEK_SET)==-1){
                        err(8,"Seek error");
                }
                for(int i=0;i<h.count;i++){
                        if(read(patchFd,&v,sizeof(v))==-1){
                                err(3,"Read error");
                        }

                        if(lseek(fd2,v.offset,SEEK_SET)==-1){
                                err(8,"Seek error");
                        }
                        if(write(fd2,&v.new,sizeof(v.new))==-1){
                                errx(7,"Write error");
                        }
                }
        }
        else if(h.dataVersion==0x01){
                version01 v;
                for(int i=0;i<h.count;i++){
                        if(read(patchFd,&v,sizeof(v))==-1){
                                err(3,"Read error");
                        }
                        if(lseek(fd1,v.offset*2,SEEK_SET)==-1){
                                err(8,"Seek error");
                        }
                        uint16_t word;
                        if(read(fd1,&word,sizeof(word))==-1){
                                err(3,"Read error");
                        }
                        dprintf(1,"%x %x %u %x\n",word,v.orig,v.offset,v.new);
                        if(word!=v.orig){
                                errx(9,"Original word is different");
                        }
                }
                if(lseek(patchFd,16,SEEK_SET)==-1){
                        err(8,"Seek error");
                }
                for(int i=0;i<h.count;i++){
                        if(read(patchFd,&v,sizeof(v))==-1){
                                err(3,"Read error");
                        }
                        if(lseek(fd2,v.offset*2,SEEK_SET)==-1){
                                err(8,"Seek error");
                        }
                        if(write(fd2,&v.new,sizeof(v.new))==-1){
                                errx(7,"Write error");
                        }
                }
        }
        else{
                errx(7,"Invalid data version");
        }

        return 0;
}
