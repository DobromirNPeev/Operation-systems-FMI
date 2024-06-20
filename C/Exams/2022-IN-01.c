#include <fcntl.h>
#include <err.h>
#include <stdint.h>
#include <unistd.h>
#include <stdio.h>

typedef struct header{
        uint16_t magic;
        uint16_t filetype;
        uint32_t count;
}__attribute__((packed)) header;

int main(int argc,char* argv[]){
        if(argc!=4){
                errx(1,"invalid number of args");
        }
        //add additonal checks
        int list=open(argv[1],O_RDONLY);
        if(list==-1){
                err(2,"open error");
        }

        int data=open(argv[2],O_RDONLY);
        if(data==-1){
                err(2,"open error");
        }

        int out=open(argv[3],O_WRONLY | O_CREAT | O_TRUNC,0777);
        if(out==-1){
                err(2,"open error");
        }
        header list_h;
        if(read(list,&list_h,sizeof(list_h))==-1){
                err(3,"read error");
        }
        if(list_h.filetype!=1){
                errx(4,"not list.bin");
        }
        header out_h;
        out_h.magic=0x5A4D;
        out_h.filetype=3;
        out_h.count=0;
        if(write(out,&out_h,sizeof(out_h))==-1){
                err(3,"read error");
        }

        for(uint32_t i=0;i<list_h.count;i++){
                uint16_t val;
                if(read(list,&val,sizeof(val))==-1){
                        err(3,"read error 2");
                }
                uint32_t data_val;
                if(lseek(data,sizeof(list_h)+i*sizeof(int32_t),SEEK_SET)==-1){
                        err(4,"lseek error");
                }
                if(read(data,&data_val,sizeof(data_val))==-1){
                        err(3,"read error 1");
                }
                uint64_t toWrite=data_val;
                if(lseek(out,sizeof(list_h)+val*sizeof(int64_t),SEEK_SET)==-1){
                        err(4,"lseek error");
                }
                if(write(out,&toWrite,sizeof(toWrite))==-1){
                        err(5,"write error");
                }
                if(val>out_h.count){
                        out_h.count=val;
                }
        }
        out_h.count++;
        if(lseek(out,0,SEEK_SET)==-1){
                err(4,"lseek error");
        }
        if(write(out,&out_h,sizeof(out_h))==-1){
                err(5,"write error");
        }
}
