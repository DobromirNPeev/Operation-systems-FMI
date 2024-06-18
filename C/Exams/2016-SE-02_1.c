#include <unistd.h>
#include <err.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>

int main(int argc,char* argv[]){

        while(1){
                if(write(1,"Enter prompt: ",13)==-1){
                        err(1,"write error");
                }
                char c[4096];
                ssize_t readSize=read(0,c,sizeof(c));
                if(readSize==-1){
                        err(2,"read error");
                }
                c[readSize-1]='\0';
                //dprintf(1,"%s exit",c);
                if(strcmp(c,"exit")==0){
                        exit(0);
                }
                int pid=fork();
                if(pid==0){
                        execlp(c,c,(char*)NULL);
                        err(6,"exec erro");
                }
                int stat;
                if(wait(&stat)==-1){
                        err(3,"wait");
                }
                if(!WIFEXITED(stat)){
                        errx(4,"child was killed");
                }
                else if(WEXITSTATUS(stat)!=0){
                        errx(5,"exit status was not zero");
                }
        }
}
