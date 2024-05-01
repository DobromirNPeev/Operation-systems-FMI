#include <fcntl.h>
#include <unistd.h>
#include <err.h>
#include <stdio.h>
#include <stdbool.h>

int main(int argc,char* argv[]){
        if( argc != 2){
                errx(1,"Invalid number of arguments");
        }

        int fd=open(argv[1],O_RDONLY);
        if (fd==-1){
                err(2,"Couldn't open file");
        }

        int bytes=0;
        int words=0;
        int lines=0;
        bool wasNewLine=false;
        int empty=0;
        char c;
        ssize_t readSize=0;

        while((readSize=read(fd,&c,sizeof(c)) > 0)){
                //dprintf(1,"%s",&c);
                if(wasNewLine==true && c=='\n'){
                        wasNewLine=false;
                        empty++;
                }
                if(c=='\n'){
                        wasNewLine=true;
                        lines++;
                        words++;
                        bytes++;
                }
                else if(c==' '){
                        wasNewLine=false;
                        while(c==' ' && (readSize=read(fd,&c,sizeof(c))) > 0){
                                bytes++;
                        }
                        if(readSize==-1){
                                err(3,"Reading error");
                        }
                        bytes++;
                        words++;
                }
                else{
                        wasNewLine=false;
                        bytes++;
                }
        }

        if(readSize==-1){
                err(3,"Reading error");
        }

        dprintf(1,"%d bytes %d words %d lines\n",bytes,words-empty,lines);

        close(fd);

        return 0;
}
