#include <fcntl.h>
#include <err.h>
#include <unistd.h>

int main(int argc,char* argv[]) {
        if (argc != 2){
                errx(1,"invalid number of arguments");
        }

        int cat[2];
        if (pipe(cat)==-1){
                err(2,"pipe error");
        }

        int pid=fork();
        if(pid==0){
                close(cat[0]);
                dup2(cat[1],1);
        close(cat[1]);
                execlp("cat","cat",argv[1],(char*)NULL);
                err(3,"exec error");
        }

        close(cat[1]);
        dup2(cat[0],0);
        close(cat[0]);
        execlp("sort","sort",(char*)NULL);
        err(3,"exec error");


}
