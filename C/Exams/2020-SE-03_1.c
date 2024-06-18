#include <sys/wait.h>
#include <fcntl.h>
#include <err.h>
#include <stdint.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

typedef struct data{
        char filename[8];
        uint32_t offset;
        uint32_t length;
}__attribute__((packed)) data;

void calculate(int p[],data d){
        uint16_t res=0;
        int fd=open(d.filename,O_RDONLY);
        if(fd==-1){
                err(2,"open error");
        }
        if(lseek(fd,d.offset,SEEK_SET)==-1){
                err(8,"lseek error");
        }
        uint16_t num;
        for(uint32_t i=0;i<d.length;i++){
                if(read(fd,&num,sizeof(num))<0){
                        err(5,"read error");
                }
                res^=num;
        }
        if(write(p[1],&res,sizeof(res))==-1){
                err(9,"write error");
        }
        close(p[1]);
        close(fd);
}

int main(int argc,char* argv[]){
        if(argc!=2){
                errx(1,"invalid number of args");
        }
        int fd=open(argv[1],O_RDONLY);
        if(fd==-1){
                err(2,"open error");
        }
        data d;
        struct stat s;
        if(stat(argv[1],&s)<0){
                err(3,"stat error");
        }
        if(s.st_size%sizeof(d)!=0  || s.st_size/sizeof(d)>8){
                errx(4,"invalid size of file");
        }

        int p[2];
        if(pipe(p)==-1){
                err(7,"pipe erro");
        }
        ssize_t readSize;
        for(int i=0;i<8;i++){
                if((readSize=read(fd,&d,sizeof(d)))<0){
                        err(5,"read erro");
                }
                if(d.filename[7]!=0x00){
                        errx(6,"invalid byte");
                }

                int pid=fork();
                if(pid==-1){
                        err(8,"fork error");
                }
                if(pid==0){
                        close(p[0]);
                        calculate(p,d);
                        exit(0);
                }
        }
        close(p[1]);

        uint16_t res=0;
        uint16_t num;
        while((readSize=read(p[0],&num,sizeof(num)))>0){
                res^=num;
        }
        dprintf(1,"result: %dB\n",res);
        if(readSize==-1){
                err(5,"read error");
        }

        int stat;
        while(wait(&stat)>0){
                if(!WIFEXITED(stat)){
                        err(10,"child was killed");
                }
                else if(WEXITSTATUS(stat)!=0){
                        err(1,"exit status not zero");
                }
        }

        close(fd);
}
