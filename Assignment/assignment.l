%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
int line = 1;
%}

KEYWORD int|float|return|if|else|for|while|do|break|continue|void
IDENTIFIER [a-zA-Z_][a-zA-Z0-9_]*
FUNCTION ([a-zA-Z_][a-zA-Z0-9_]*)[ \t]*\(
NUMBER ([0-9]*[.])?[0-9]+([eE][+-]?[0-9]+)?
STRING \"([^\\\"]|\\.)*\"
COMMENT (\/\/.*|\/\*([^*]|\*+[^*/])*\*+\/)
BITWISE_OPERATOR >>|<<|&|^|\|
ASSIGNMENT_OPERATOR =|<<=|>>=|&=|^=|\|=
PARENTHESES \(|\)
CURLY_BRACES \{|\}
SEPARATOR ,|;|:

%%
[\n] { line++; }
{COMMENT} {}
[ \t\r] {} // Skip spaces/tabs

{KEYWORD}     { fprintf(yyout,"TOKEN:<KEYWORD,%s> At line %d\n", yytext, line); }
{FUNCTION}    {
                  char funcname[100];
                  sscanf(yytext, "%[^ \t(]", funcname);
                  fprintf(yyout,"TOKEN:<FUNCTION,%s> At line %d\n", funcname, line);
              }
{IDENTIFIER}  { fprintf(yyout,"TOKEN:<IDENTIFIER,%s> At line %d\n", yytext, line); }
{NUMBER}      { fprintf(yyout,"TOKEN:<NUMBER,%s> At line %d\n", yytext, line); }
{BITWISE_OPERATOR}     { fprintf(yyout,"TOKEN:<BITWISE OPERATOR,%s> At line %d\n", yytext, line); }
{ASSIGNMENT_OPERATOR}     { fprintf(yyout,"TOKEN:<ASSIGNMENT OPERATOR,%s> At line %d\n", yytext, line); }
{PARENTHESES}     { fprintf(yyout,"TOKEN:<PARENTHESES,%s> At line %d\n", yytext, line); }
{CURLY_BRACES}     { fprintf(yyout,"TOKEN:<CURLY BRACES,%s> At line %d\n", yytext, line); }
{SEPARATOR}     { fprintf(yyout,"TOKEN:<SEPARATOR,%s> At line %d\n", yytext, line); }
{STRING}      { fprintf(yyout,"TOKEN:<STRING LITERAL,%s> At line %d\n", yytext, line); }

. {} 
%%

int main()
{
    yyin = fopen("input.txt", "r");
    yyout = fopen("output.txt", "w");
    yylex();
    return 0;
}
