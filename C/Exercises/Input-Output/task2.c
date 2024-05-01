#include <fcntl.h>
#include <unistd.h>
#include <err.h>

int main(int argc,char* argv[]){
        if (argc != 2){
                errx(1,"Invalid number of arguments");
        }

        int fd=open(argv[1],O_RDONLY);
        if (fd==-1){
                err(2,"Couldn't open file");
        }

        int count=0;
        char c;
        ssize_t readSize=0;
        while((readSize=read(fd,&c,sizeof(c)) > 0)){
                if (write(1,&c,sizeof(c))==-1){
                        err(3,"Couldn't write terminal");
                }
                if ( c=='\n'){
                        count++;
                        if ( count==10){
                                break;
                        }
                }
        }

        if (readSize==-1){
                err(4,"Reading error");
        }

        close(fd);

        return 0;
}
