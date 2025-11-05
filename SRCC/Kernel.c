void print(const char *String,int size){
    volatile const char * VGA_MEMORY=(volatile const char*)0xb8000;
    char *memoryPointer = (char*)VGA_MEMORY;
    for(int i=0;i<size;i++){
        *(memoryPointer+i*2)=String[i];
        *(memoryPointer+i*2+1)=0b00001111;

    }
}

void main(){
    char msg[] = "Kernel Code!";
    print(msg, sizeof(msg));
}