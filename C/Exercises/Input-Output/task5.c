#include <err.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc,char* argv[]){
        if (argc != 3){
                errx(1,"Invalid number of arguments");
        }
        int fd1=open(argv[1],O_RDONLY);
        if (fd1==-1){
                err(2,"Couldn't open file");
        }
        int fd2=open(argv[2],O_TRUNC | O_CREAT | O_WRONLY,S_IRUSR | S_IWUSR);
        if (fd2==-1){
                err(2,"Couldn't open file");
        }
        char c;
        ssize_t readSize;
        while((readSize=read(fd1,&c,sizeof(c))) > 0){
                if(write(fd2,&c,readSize) == -1){
                        err(3,"Couln't write to file 2");
                }
        }

        if(readSize==-1){
                err(4,"Reading error");
        }

        close(fd1);
        close(fd2);

        return 0;
}
