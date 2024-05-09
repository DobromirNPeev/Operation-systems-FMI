#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <err.h>
#include <stdio.h>
#include <sys/stat.h>

typedef struct data_header{
        uint32_t magic;
        uint32_t count;
}__attribute__((packed)) data_header;

typedef struct comp_header{
        uint32_t magic1;
        uint16_t magic2;
        uint16_t reserved;
        uint64_t count;
}__attribute__((packed)) comp_header;

typedef struct comp_data{
        uint16_t type;
        uint16_t reserved1;
        uint16_t reserved2;
        uint16_t reserved3;
        uint32_t offset1;
        uint32_t offset2;
}__attribute__((packed)) comp_data;


int main(int argc,char* argv[]){
        if(argc!=3){
                errx(1,"Invalid number of arguments");
        }
        int data=open(argv[1],O_RDWR);
        if(data==-1){
                err(2,"Open error");
        }
        int comp=open(argv[2],O_RDONLY);
        if(comp==-1){
                err(2,"Open error");
        }
        struct stat st;
        if(fstat(data,&st)==-1){
                err(3,"Stat error");
        }
        if(st.st_size%sizeof(uint64_t)!=0){
                errx(4,"Invalid file format");
        }
        data_header dh;
        if(read(data,&dh,sizeof(dh))==-1){
                err(5,"Read error");
        }
        comp_header ch;
        if(read(comp,&ch,sizeof(ch))==-1){
                err(5,"Read error");
        }
        if(dh.magic!=0x21796f4a || ch.magic1!=0xafbc7a37 || ch.magic2!=0x1c27){
                errx(6,"Wrong specification");
        }
        comp_data cd;
        if(fstat(comp,&st)==-1){
                err(3,"Stat error");
        }
        if((st.st_size-sizeof(ch))%sizeof(cd)!=0){
                errx(4,"Invalid file format");
        }
        for(uint64_t i=0;i<ch.count;i++){
                if(read(comp,&cd,sizeof(cd))==-1){
                        err(5,"Read erro");
                }
                if(cd.type>2){
                        errx(7,"Invalid value for type");
                }
                if(cd.reserved1!=0 || cd.reserved2!=0 || cd.reserved3!=0){
                        errx(8,"Invalid value for reseved");
                }
                if(cd.offset1>dh.count || cd.offset2>dh.count){
                        errx(9,"Invalid offset");
                }
                uint64_t firstNum;
                uint64_t secondNum;
                if(lseek(data,sizeof(dh)+cd.offset1*sizeof(uint64_t),SEEK_SET)==-1){
                        err(10,"Seek error");
                }
                if(read(data,&firstNum,sizeof(firstNum))==-1){
                        err(5,"Read error");
                }
                if(lseek(data,sizeof(dh)+cd.offset2*sizeof(uint64_t),SEEK_SET)==-1){
                        err(10,"Seek error");
                }
                if(read(data,&secondNum,sizeof(secondNum))==-1){
                        err(5,"Read error");
                }
                //dprintf(1,"%lu %lu %u %u\n",firstNum,secondNum,sizeof(dh)+cd.offset1*sizeof(uint64_t),sizeof(dh)+cd.offset2*sizeof(uint64_t));
                if(cd.type==0){
                        if(firstNum>secondNum){
                                if(lseek(data,sizeof(dh)+cd.offset1*sizeof(uint64_t),SEEK_SET)==-1){
                                        err(10,"Seek error");
                                }
                                if(write(data,&secondNum,sizeof(secondNum))==-1){
                                        err(11,"Write error");
                                }
                                if(lseek(data,sizeof(dh)+cd.offset2*sizeof(uint64_t),SEEK_SET)==-1){
                                        err(10,"Seek error");
                                }
                                if(write(data,&firstNum,sizeof(firstNum))==-1){
                                        err(11,"Write error");
                                }
                        }
                }
                else{
                        if(firstNum<secondNum){
                                if(lseek(data,sizeof(dh)+cd.offset1*sizeof(uint64_t),SEEK_SET)==-1){
                                        err(10,"Seek error");
                                }
                                if(write(data,&secondNum,sizeof(secondNum))==-1){
                                        err(11,"Write error");
                                }
                                if(lseek(data,sizeof(dh)+cd.offset2*sizeof(uint64_t),SEEK_SET)==-1){
                                        err(10,"Seek error");
                                }
                                if(write(data,&firstNum,sizeof(firstNum))==-1){
                                        err(11,"Write error");
                                }
                        }
                }
        }
}
