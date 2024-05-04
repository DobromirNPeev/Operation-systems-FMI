#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <err.h>
#include <stdbool.h>

int main(int argc,char* argv[]){
        if(argc==3){
                if(strcmp(argv[1],"-d")==0){
                        int arr[256]={0};
                        size_t len=strlen(argv[2]);
                        for(size_t i=0;i<len;i++){
                                arr[(int)(argv[2][i])]++;
                        }
                        ssize_t readSize;
                        char c;
                        while((readSize=read(0,&c,sizeof(c)))>0){
                                if(arr[(int)(c)]==0){
                                        if(write(1,&c,readSize)==-1){
                                                err(1,"Write error");
                                        }
                                }
                        }
                        if(readSize==-1){
                                err(2,"Read error");
                        }
                }
                else if(strcmp(argv[1],"-s")==0){
                        int arr[256]={0};
                        size_t len=strlen(argv[2]);
                        for(size_t i=0;i<len;i++){
                                arr[(int)(argv[2][i])]++;
                        }
                        ssize_t readSize;
                        char c;
                        while((readSize=read(0,&c,sizeof(c)))>0){
                                if(arr[(int)(c)]>=1){
                                        if(write(1,&c,sizeof(c))==-1){
                                                err(1,"Write error");
                                        }
                                        char next;
                                        while((readSize=read(0,&next,sizeof(next)))>0 && next==c){
                                                continue;
                                        }
                                        if(readSize==-1){
                                                err(2,"Read error");
                                        }
                                        if(write(1,&next,sizeof(next))==-1){
                                                err(1,"Write error");
                                        }
                                }
                                else{
                                        if(write(1,&c,sizeof(c))==-1){
                                                err(1,"Write error");
                                        }
                                }
                        }
                        if(readSize==-1){
                                err(2,"Read error");
                        }
                }
                else{
                        size_t len1=strlen(argv[1]);
                        size_t len2=strlen(argv[2]);
                        if(len1!=len2){
                                errx(3,"Differents lengths of sets");
                        }
                        char arr[256]={0};
                        for(size_t i=0;i<len1;i++){
                                arr[(int)(argv[1][i])]=argv[2][i];
                        }
                        ssize_t readSize;
                        char c;
                        while((readSize=read(0,&c,sizeof(c)))>0){
                                if(arr[(int)(c)]!=0){
                                        if(write(1,&arr[(int)(c)],sizeof(char))==-1){
                                                err(1,"Write error");
                                        }
                                }
                                else{
                                        if(write(1,&c,sizeof(c))==-1){
                                                err(1,"Write error");
                                        }
                                }
                        }
                        if(readSize==-1){
                                err(2,"Read error");
                        }
                }
        }
}
