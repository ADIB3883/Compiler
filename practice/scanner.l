%option noyywrap
%{
#include<stdio.h>
#include<stdlib.h>
int line=1;
extern FILE *yyin, *yyout;
%}
KEYWORD int|float|return|if|else|for|while|do|break|continue|void
IDENTIFIER [a-zA-Z_][a-zA-Z0-9_]*
FUNCTION {IDENTIFIER}[ \t]*\(
NUMBER ([0-9]*[.])?[0-9]+([eE][+-]?[0-9]+)?
OPERATOR (\+=|-=|\*=|/=|==|!=|<=|>=|<<=|>>=|=|<|>|\+|-|\*|/|%|>>|<<)
PUNCTUATION [(){};,:\[\]]
STRING \"([^\\\"]|\\.)*\"
COMMENT (\/\/.*|\/\*([^*]|\*+[^*/])*\*+\/)
%%
[\n] {line++;}
{COMMENT} {}
[ \t\r] {}
{KEYWORD} {fprintf(yyout,"<KEYWORD, %s, %d>\n",yytext,line);}
{FUNCTION} {fprintf(yyout,"<FUNCTION, %s, %d>\n",yytext,line);}
{IDENTIFIER} {fprintf(yyout,"<IDENTIFIER, %s, %d>\n",yytext,line);}
{NUMBER} {fprintf(yyout,"<NUMBER, %s, %d>\n",yytext,line);}
{OPERATOR} {fprintf(yyout,"<OPERATOR, %s, %d>\n",yytext,line);}
{PUNCTUATION} {fprintf(yyout,"<PUNCTUATION, %s, %d>\n",yytext,line);}
{STRING} {fprintf(yyout,"<STRING, %s, %d>\n",yytext,line);}
. {}
%%
int main()
{
yyin=fopen("input.txt","r");
yyout=fopen("output.txt","w");
yylex();
return 0;
}