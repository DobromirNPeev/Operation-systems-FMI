#include <unistd.h>
#include <sys/wait.h>
#include <err.h>
#include <stdlib.h>
#include <time.h>
#include <fcntl.h>
#include <stdio.h>

int main(int argc,char* argv[]){
        if(argc < 3){
                errx(1,"invalid number of args");
        }
        int num=atoi(argv[1]);
        if(num<1 || num>9){
                errx(6,"not a valid number");
        }
        char* q=argv[2];
        char** args=argv+2;
        int fd=open("run.log",O_WRONLY | O_CREAT | O_TRUNC,S_IRUSR | S_IWUSR);
        int count_exits=0;

        while(1){
                int pid=fork();
                if(pid==-1){
                        err(2,"fork error");
                }
                if(pid==0){
                        execvp(q,args);
                        err(3,"exec error");
                }
                time_t before=time(NULL);
                int stat;
                wait(&stat);
                time_t after=time(NULL);
                int exit_status;
                if(!WIFEXITED(stat)){
                        exit_status=129;
                }
                else{
                        exit_status=WEXITSTATUS(stat);
                }
                dprintf(fd,"%ld %ld %d\n",before,after,exit_status);
                int diff=after-before;
                if(WEXITSTATUS(stat)!=0 && diff<num){
                        count_exits++;
                }
                else{
                        count_exits=0;
                }
                if(count_exits>=2){
                        break;
                }
        }
}
