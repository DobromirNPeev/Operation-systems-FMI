#include <fcntl.h>
#include <sys/stat.h>
#include <err.h>
#include <unistd.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>

int main(int argc,char* argv[]){

        if(argc!=4){
                errx(6,"invalid number of args");
        }
        if(strlen(argv[1])>63){
                errx(7,"too long word");
        }

        int dic=open(argv[2],O_RDONLY);
        if(dic==-1){
                err(1,"read error");
        }

        int idx=open(argv[3],O_RDONLY);
        if(idx==-1){
                err(1,"read error");
        }

        struct stat s;
        if(stat(argv[3],&s)==-1){
                err(2,"stat error");
        }
        uint32_t l=0;
        uint32_t r=s.st_size/sizeof(uint32_t);
        char word[64];
        while(l<=r){
                uint32_t mid=l+(r-l)/2;
                if(lseek(idx,mid*sizeof(uint32_t),SEEK_SET)==-1){
                        err(3,"lseek error");
                }
                uint32_t null;
                if(read(idx,&null,sizeof(null))==-1){
                        err(4,"read error");
                }
                if(lseek(dic,null,SEEK_SET)==-1){
                        err(3,"lseek error");
                }
                int index=0;
                char c;
                if(read(dic,&c,sizeof(c))==-1){
                        err(4,"read error");
                }
                ssize_t readSize;
                while((readSize=read(dic,&c,sizeof(c)))>0){
                        if(c=='\n'){
                                break;
                        }
                        word[index++]=c;
                }
                if(readSize==-1){
                        err(4,"read error");
                }
                word[index]='\0';
                if(strcmp(word,argv[1])==0){
                        while((readSize=read(dic,&c,sizeof(c))>0)){
                                if(c==0x00){
                                        break;
                                }
                                if(write(1,&c,sizeof(c))==-1){
                                        err(5,"write error");
                                }
                        }
                        if(readSize==-1){
                                err(4,"read error");
                        }
                        close(dic);
                        close(idx);
                        return 0;
                }
                else if(strcmp(argv[1],word)<0){
                        r=mid-1;
                }
                else{
                        l=mid+1;
                }
        }
        errx(6,"no such word");
        close(dic);
        close(idx);
}
