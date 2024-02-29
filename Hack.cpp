#define TX_USE_SPEAK
#include"TXLib.h"
#include <stdio.h>
#include <stdlib.h>

const int OFFSET = 438;

int main() {

    FILE* asm_code = fopen("VZLOM.COM", "rb+");

    if (asm_code == NULL) {
        printf("ERROR! Can't find file with hexadecimal code\n");
    }

    char* new_password = "22222";

    fseek(asm_code, OFFSET, SEEK_SET);

    for (int i = 0; i < 5; i++) {
        fwrite(new_password, sizeof(char), 1, asm_code);
    }

    fclose(asm_code);


    txSpeak("Ма ма ма мама Мария маа Ма ма ма мама Мария маа Ма ма ма мама Мария маа \
                                            Я тебя взломала хахахахахахахахахахахах");

    return 0;
}
