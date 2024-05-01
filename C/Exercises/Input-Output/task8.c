#include <fcntl.h>
#include <unistd.h>
#include <err.h>

int main(int argc,char* argv[]){
        if(argc!=1){
                errx(1,"Invalid number of arguments");
        }
        int fdetc=open("/etc/passwd",O_RDONLY);
        if(fdetc==-1){
                err(1,"Openning err");
        }
        int fdnew=open("passwd",O_RDWR | O_CREAT | O_TRUNC,S_IRUSR | S_IWUSR);
        if(fdnew==-1){
                err(1,"Opennig err");
        }
        ssize_t readSize;
        char c;

        while((readSize=read(fdetc,&c,sizeof(c)))>0){
                if(c==':'){
                        c='?';
                }
                if(write(fdnew,&c,readSize)==-1){
                        err(2,"Writing err");
                }
        }

        if(readSize==-1){
                err(3,"Reading err");
        }


        close(fdetc);
        close(fdnew);
        return 0;
}