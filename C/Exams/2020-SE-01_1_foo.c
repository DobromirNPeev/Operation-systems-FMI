#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <err.h>

int main(int argc,char* argv[]){

        if(argc!=2){
                errx(4,"invalid number of args");
        }
        if(mkfifo("myfifo",0777)==-1){
                err(1,"fifo error");
        }

        int fd=open("myfifo",O_WRONLY);
        if(fd==-1){
                err(2,"open error");
        }

        dup2(fd,1);

        execlp("cat","cat",argv[1],(char*)NULL);
        err(3,"exec error");
}
