#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <err.h>

int main(int argc,char* argv[]){

        if(argc!=2){
                errx(4,"invalid number of args");
        }

        int fd=open("myfifo",O_RDONLY);
        if(fd==-1){
                err(2,"open error");
        }

        dup2(fd,0);

        execlp(argv[1],argv[1],(char*)NULL);
        err(3,"exec error");
}
