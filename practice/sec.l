%option noyywrap
%{
#include<stdio.h>
int cnt=0;
%}

digit [0-9]
delim [ \t\n]
ws {delim}+
letter [A-Za-z]
id {letter}+

%%
if {printf("<Keyword, %s>\n",yytext);}
{ws} {}
{digit} {printf("<DIGIT, %s>\n",yytext);}
exit {return 1;}
{id} {printf("<Identifier, %s>\n",yytext);cnt++;}
[+] {printf("<Arithmetic operator,%s>\n",yytext);}
.* {}

%%
int main()
{
printf("Before calling yylex()");
yylex();
printf("After calling yylex()\n\n\nTotal number of identifiers counted is %d\n",cnt);
}