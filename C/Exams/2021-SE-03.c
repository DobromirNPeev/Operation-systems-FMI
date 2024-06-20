#include <stdio.h>
#include <err.h>
#include <fcntl.h>
#include <stdint.h>
#include <sys/stat.h>
#include <unistd.h>
#include <string.h>

int main(int argc,char* argv[]){
        if(argc!=3){
                errx(1,"invalid number of args");
        }
        int input=open(argv[1],O_RDONLY);
        if(input==-1){
                err(2,"open error");
        }
        int output=open(argv[2],O_WRONLY | O_CREAT | O_TRUNC,0777);
        if(output==-1){
                err(2,"open error");
        }
        struct stat s;
        if(stat(argv[1],&s)==-1){
                err(3,"stat error");
        }
        if(s.st_size%sizeof(uint16_t)!=0){
                err(4,"size error");
        }
        uint32_t arrN=s.st_size/sizeof(uint16_t);
        if(arrN>524288){
                errx(4,"size error");
        }
        if(write(output,"#include <stdint.h>\n\n",strlen("#include <stdint.h>\n\n"))==-1){
                err(7,"write error");
        }
        if(write(output,"uint32_t arrN=",strlen("uint32_t arrN="))==-1){
                err(7,"write error");
        }
        dprintf(output,"%d;\n",arrN);
        if(write(output,"uint16_t arr[]={",strlen("uint16_t arr[]={"))==-1){
                err(7,"write error");
        }
        uint16_t byte;
        if(lseek(output,0,SEEK_END)==-1){
                err(5,"lseek error");
        }
        for(uint32_t i=0;i<arrN-1;i++){
                if(read(input,&byte,sizeof(byte))==-1){
                        err(6,"read error");
                }
                dprintf(output,"%d,",byte);
        }
        if(read(input,&byte,sizeof(byte))==-1){
                err(6,"read error");
        }
        dprintf(output,"%d};\n",byte);

}
