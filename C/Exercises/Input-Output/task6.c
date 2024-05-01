#include <fcntl.h>
#include <unistd.h>
#include <err.h>

int main(int argc,char* argv[]){
        for(int i=1;i<argc;i++){
                int fd=open(argv[i],O_RDONLY);
                if(fd==-1){
                        err(1,"Opening error");
                }

                ssize_t readSize=0;
                char c;
                while((readSize=read(fd,&c,sizeof(c)))>0){
                        if(write(1,&c,readSize)==-1){
                                err(2,"Writing error");
                        }
                }

                if(readSize==-1){
                        err(3,"Reading error");
                }

                close(fd);
        }
}
