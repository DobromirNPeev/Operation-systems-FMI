#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <err.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>

int main(int argc,char* argv[]){
        if(argc!=2){
                errx(1,"invalid number of args");
        }

        int p[2];
        if(pipe(p)==-1){
                err(3,"pipe erro");
        }

        int pid=fork();
        if(pid==-1){
                err(2,"fork error");
        }

        if(pid==0){
                close(p[0]);
                dup2(p[1],1);
                close(p[1]);
                execlp("find","find",argv[1],"-type","f","-not","-name","*.hash",(char*)NULL);
                err(4,"exec error");
        }
        close(p[1]);
        char buff[4096];
        char c;
        int index=0;
        ssize_t readSize;

        while((readSize=read(p[0],&c,sizeof(c)))>0){
                buff[index++]=c;
                if(c=='\n'){
                        char old[4096];
                        buff[index-1]='\0';
                        strcpy(old,buff);
                        strcat(buff,".hash");
                        pid=fork();
                        if(pid==-1){
                                err(2,"fork error");
                        }
                        if(pid==0){
                                int fd=open(buff,O_CREAT | O_TRUNC | O_WRONLY,0777);
                                if(fd==-1){
                                        err(5,"open error");
                                }
                                if(dup2(fd,1)==-1){
                                        err(6,"dup error");
                                }
                                execlp("md5sum","md5sum",old,(char*)NULL);
                                err(4,"exec error");
                        }
                        index=0;
                }
        }
        if(readSize==-1){
                err(7,"read erro");
        }
        int stat;
        while(wait(&stat)>0){
                if(!WIFEXITED(stat)){
                        err(8,"child was killed");
                }
                if(WEXITSTATUS(stat)!=0){
                        err(9,"exit stat not zero");
                }
        }
}
