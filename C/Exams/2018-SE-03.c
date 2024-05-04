#include <fcntl.h>
#include <err.h>
#include <unistd.h>
#include <string.h>

//improve clean code
int main(int argc,char* argv[]){
        if(strcmp(argv[1],"-c")==0){
                if(strlen(argv[2])==1 && argv[2][0]>='1' && argv[2][0]<='9'){
                        int num=argv[2][0]-'0';
                        int count=0;
                        char c;
                        ssize_t readSize;
                        while((readSize=read(0,&c,sizeof(c)))>0){
                                if(c=='\n'){
                                        count=0;
                                        if(write(1,&c,readSize)==-1){
                                                err(1,"Write error");
                                        }
                                        continue;
                                }
                                count++;
                                if(count==num){
                                        if(write(1,&c,readSize)==-1){
                                                err(1,"Write error");
                                        }
                                }
                        }
                        if(readSize==-1){
                                err(2,"Read error");
                        }
                }
                else if(strlen(argv[2])==3 && (argv[2][0]>='1' && argv[2][0]<='9') && (argv[2][2]>='1' && argv[2][2]<='9') && argv[2][1]=='-'){
                        int n=argv[2][0]-'0';
                        int m=argv[2][2]-'0';
                        if(n>m){
                                errx(3,"Lhs is bigger than rhs");
                        }
                        int count=0;
                        char c;
                        ssize_t readSize;
                        while((readSize=read(0,&c,sizeof(c)))>0){
                                if(c=='\n'){
                                        count=0;
                                        if(write(1,&c,readSize)==-1){
                                                err(1,"Write error");
                                        }
                                        continue;
                                }
                                count++;
                                if(count>=n && count<=m){
                                        if(write(1,&c,readSize)==-1){
                                                err(1,"Write error");
                                        }
                                }
                        }
                        if(readSize==-1){
                                err(2,"Read error");
                        }
                }
                else{
                        errx(4,"Invalid format");
                }
        }
        else if (strcmp(argv[1],"-d")==0 && argc==5){
                char del=argv[2][0];
                if(strcmp(argv[3],"-f")==0){
                        if(strlen(argv[4])==1 && argv[4][0]>='1' && argv[4][0]<='9'){
                                int num=argv[4][0]-'0';
                                int count=1;
                                ssize_t readSize;
                                char c;
                                while((readSize=read(0,&c,sizeof(c)))>0){
                                        if(c=='\n'){
                                                count=1;
                                                if(write(1,&c,readSize)==-1){
                                                        err(1,"Write error");
                                                }
                                                continue;
                                        }
                                        if(c==del){
                                                count++;
                                        }
                                        else if(count==num){
                                                if(write(1,&c,readSize)==-1){
                                                        err(1,"Write error");
                                                }
                                        }
                                }
                                if(readSize==-1){
                                        err(2,"Read error");
                                }
                        }
                        else if(strlen(argv[4])==3 && (argv[4][0]>='1' && argv[4][0]<='9') && (argv[4][2]>='1' && argv[4][2]<='9') && argv[4][1]=='-'){
                                int n=argv[4][0]-'0';
                                int m=argv[4][2]-'0';
                                if(n>m){
                                        errx(3,"Lhs is bigger than rhs");
                                }
                                int count=1;
                                char c;
                                ssize_t readSize;
                                while((readSize=read(0,&c,sizeof(c)))>0){
                                        if(c=='\n'){
                                                count=1;
                                                if(write(1,&c,readSize)==-1){
                                                        err(1,"Write error");
                                                }
                                                continue;
                                        }
                                        if(c==del){
                                                count++;
                                                if(count==n)
                                                        continue;
                                        }
                                        if(count>=n && count<=m){
                                                if(write(1,&c,readSize)==-1){
                                                        err(1,"Write error");
                                                }
                                        }
                                }
                        }
                        else{
                                errx(4,"Invalid format");
                        }
                }
                else{
                        errx(4,"Invalid format");
                }
        }
        else{
                errx(4,"Invalid format");
        }
}
