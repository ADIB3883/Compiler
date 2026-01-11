%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
int line = 1;
%}

/* ===== Patterns ===== */
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
BRACKET     [\[\]]
PREPROC     \#[a-zA-Z_]+
ARITH_OP    [\+\-\*/%]
REL_OP      (==|!=|<=|>=|<|>)
LOGIC_OP    (\&\&|\|\||!)

%%

[\n] { line++; }
[ \t\r] {}  /* Skip spaces/tabs */

/* ===== Token rules ===== */
{KEYWORD}     { fprintf(yyout,"TOKEN:<KEYWORD,%s> At line %d\n", yytext, line); }

{FUNCTION}    {
                  char funcname[100];
                  sscanf(yytext, "%[^ \t(]", funcname);
                  fprintf(yyout,"TOKEN:<FUNCTION,%s> At line %d\n", funcname, line);
              }

{IDENTIFIER}  { fprintf(yyout,"TOKEN:<IDENTIFIER,%s> At line %d\n", yytext, line); }
{NUMBER}      { fprintf(yyout,"TOKEN:<NUMBER,%s> At line %d\n", yytext, line); }
{BITWISE_OPERATOR}     { fprintf(yyout,"TOKEN:<BITWISE OPERATOR,%s> At line %d\n", yytext, line); }
{ASSIGNMENT_OPERATOR}  { fprintf(yyout,"TOKEN:<ASSIGNMENT OPERATOR,%s> At line %d\n", yytext, line); }
{PARENTHESES} { fprintf(yyout,"TOKEN:<PARENTHESES,%s> At line %d\n", yytext, line); }
{CURLY_BRACES} { fprintf(yyout,"TOKEN:<CURLY BRACES,%s> At line %d\n", yytext, line); }
{SEPARATOR}   { fprintf(yyout,"TOKEN:<SEPARATOR,%s> At line %d\n", yytext, line); }
{BRACKET}     { fprintf(yyout,"TOKEN:<BRACKET,%s> At line %d\n", yytext, line); }
{PREPROC}     { fprintf(yyout,"TOKEN:<PREPROCESSOR,%s> At line %d\n", yytext, line); }
{ARITH_OP}    { fprintf(yyout,"TOKEN:<ARITHMETIC OPERATOR,%s> At line %d\n", yytext, line); }
{REL_OP}      { fprintf(yyout,"TOKEN:<RELATIONAL OPERATOR,%s> At line %d\n", yytext, line); }
{LOGIC_OP}    { fprintf(yyout,"TOKEN:<LOGICAL OPERATOR,%s> At line %d\n", yytext, line); }

/* String without quotes */
{STRING} {
    char str[1000];
    strncpy(str, yytext+1, yyleng-2); /* Remove " at start & end */
    str[yyleng-2] = '\0';
    fprintf(yyout,"TOKEN:<STRING LITERAL,%s> At line %d\n", str, line);
}

/* Comments without symbols */
{COMMENT} {
    if (yytext[1] == '/') { /* Single-line */
        fprintf(yyout,"TOKEN:<COMMENT,%s> At line %d\n", yytext+2, line);
    } else { /* Multi-line */
        char temp[1000];
        strncpy(temp, yytext+2, yyleng-4); /* Remove /* and */ */
        temp[yyleng-4] = '\0';
        fprintf(yyout,"TOKEN:<COMMENT,%s> At line %d\n", temp, line);
    }
}

. {} 

%%

int main()
{
    yyin = fopen("input.txt", "r");
    yyout = fopen("output.txt", "w");
    yylex();
    return 0;
}
