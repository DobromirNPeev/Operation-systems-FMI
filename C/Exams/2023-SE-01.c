#include <fcntl.h>
#include <err.h>
#include <stdint.h>
#include <unistd.h>
#include <stdio.h>

int main(int argc,char* argv[]){
        if(argc!=3){
                errx(1,"invalid number of args");
        }
        int src=open(argv[1],O_RDONLY);
        if(src==-1){
                err(2,"open error");
        }

        int dest=open(argv[2],O_WRONLY | O_CREAT | O_TRUNC,0777);
        if(dest==-1){
                err(2,"open error");
        }
        uint8_t byte;
        ssize_t readSize;
        while((readSize=read(src,&byte,sizeof(byte)))>0){
                if(byte!=0x55){
                        continue;
                }
                uint8_t res=byte;
                uint8_t n;
                if(read(src,&n,sizeof(n))<0){
                        err(3,"read error");
                }
                res^=n;
                int prev=lseek(src,0,SEEK_CUR);
                if(prev==-1){
                        err(5,"lseek error");
                }
                for(int i=3;i<n;i++){
                        if(read(src,&byte,sizeof(byte))<0){
                                err(3,"read error");
                        }
                        res^=byte;
                }
                uint8_t checkSum;
                if(read(src,&checkSum,sizeof(checkSum))<0){
                        err(3,"read error");
                }
                if(checkSum==res){
                        int curr=lseek(src,0,SEEK_CUR);
                        if(curr==-1){
                                err(5,"lseek error");
                        }
                        if(lseek(src,prev,SEEK_SET)==-1){
                                err(5,"lseek error");
                        }
                        for(int i=prev;i<curr;i++){
                                if(read(src,&byte,sizeof(byte))<0){
                                        err(3,"read error");
                                }

                                if(write(dest,&byte,sizeof(byte))==-1){
                                        err(4,"write error");
                                }
                        }
                }
        }
        if(readSize==-1){
                err(3,"read error");
        }
        close(src);
        close(dest);

}
