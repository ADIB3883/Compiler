%option noyywrap
%{
#include <stdio.h>
#include <string.h>
int line = 1;
FILE *yyout;
%}

/* Macro definitions */
GP (13|17)
RO 18
BANG (14|19)
AIR 16
TELE 15

/* PHONE number pattern: optional +880, then 0, then prefix, then 7 or more digits/dashes */
PHONE (\+88)?0({GP}|{RO}|{BANG}|{AIR}|{TELE})[0-9\-]{7,}


%%

[\n] { line++; }
[ \t\r] {}


{PHONE} {
    char clean_number[30];
    int j = 0;
    for (int i = 0; yytext[i] != '\0'; i++) {
        if (yytext[i] != '-')
            clean_number[j++] = yytext[i];
    }
    clean_number[j] = '\0';

    const char *prefix;
    if (strncmp(clean_number, "+880", 4) == 0)
        prefix = clean_number + 4;  // Skip +880
    else if (clean_number[0] == '0')
        prefix = clean_number + 1;   // Skip leading 0
    else
        prefix = clean_number;       // Unlikely, but fallback

    if (strncmp(prefix, "13", 2) == 0 || strncmp(prefix, "17", 2) == 0)
        fprintf(yyout, "TOKEN:<PHONE_GP,%s> At line %d\n", yytext, line);
    else if (strncmp(prefix, "14", 2) == 0 || strncmp(prefix, "19", 2) == 0)
        fprintf(yyout, "TOKEN:<PHONE_BANGLALINK,%s> At line %d\n", yytext, line);
    else if (strncmp(prefix, "18", 2) == 0)
        fprintf(yyout, "TOKEN:<PHONE_ROBI,%s> At line %d\n", yytext, line);
    else if (strncmp(prefix, "16", 2) == 0)
        fprintf(yyout, "TOKEN:<PHONE_AIRTEL,%s> At line %d\n", yytext, line);
    else if (strncmp(prefix, "15", 2) == 0)
        fprintf(yyout, "TOKEN:<PHONE_TELETALK,%s> At line %d\n", yytext, line);
    else
        fprintf(yyout, "TOKEN:<PHONE_UNKNOWN,%s> At line %d\n", yytext, line);
}

. {}

%%

int main() {
    yyin = fopen("input.txt", "r");
    yyout = fopen("output.txt", "w");
    if (!yyin || !yyout) {
        fprintf(stderr, "Error opening files.\n");
        return 1;
    }
    yylex();
    fclose(yyin);
    fclose(yyout);
    return 0;
}
