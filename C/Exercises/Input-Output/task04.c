#include <fcntl.h>
#include <unistd.h>
#include <err.h>

int main(int argc, char* argv[]){
        if ( argc!=3){
                errx(1,"Invalid number of arguments");
        }

        int fd1=open(argv[1],O_RDWR);
        if(fd1==-1){
                err(2,"Couldn't open");
        }

        int fd2=open(argv[2],O_RDWR);

        if(fd2==-1){
                err(2,"Couldn't open");
        }

        int tmp=open("temp",O_CREAT | O_TRUNC | O_RDWR,S_IRUSR | S_IWUSR);
        if(tmp==-1){
                err(2,"Couldn't open");
        }

        ssize_t readSize;
        char c;

        while((readSize=read(fd1,&c,sizeof(c)))>0){
                if(write(tmp,&c,readSize)==-1){
                        err(3,"Writing error");
                }
        }

        if(readSize==-1){
                err(4,"Reading error");
        }

        if(lseek(fd1,0,SEEK_SET)==-1 || lseek(tmp,0,SEEK_SET)==-1){
                err(5,"Seeking error");
        }

        while((readSize=read(fd2,&c,sizeof(c)))>0){
                if(write(fd1,&c,readSize)==-1){
                        err(3,"Writing error");
                }
        }

        if(readSize==-1){
                err(4,"Reading error");
        }

        if(lseek(fd2,0,SEEK_SET)){
                err(5,"Seeking error");
        }

        while((readSize=read(tmp,&c,sizeof(c)))>0){
                if(write(fd2,&c,readSize)==-1){
                        err(3,"Writing error");
                }
        }

        if(readSize==-1){
                err(4,"Reading error");
        }

        close(fd1);
        close(fd2);
        close(tmp);

        return 0;
}
