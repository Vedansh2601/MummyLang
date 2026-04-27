%{
#include "mummy.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

%%

"mummy"        { printf("[TOKEN] MUMMY\n"); return MUMMY; }
"ye he"        { printf("[TOKEN] YE_HE\n"); return YE_HE; }
"jab tak"      { printf("[TOKEN] JAB_TAK\n"); return JAB_TAK; }
"agar"         { printf("[TOKEN] AGAR\n"); return AGAR; }
"nahi to"      { printf("[TOKEN] NAHI_TO\n"); return NAHI_TO; }
"bolo"         { printf("[TOKEN] BOLO\n"); return BOLO; }
"pucho"        { printf("[TOKEN] PUCHO\n"); return PUCHO; }
"end"          { printf("[TOKEN] END\n"); return END; }

"="            { printf("[TOKEN] ASSIGN\n"); return ASSIGN; }
";"            { printf("[TOKEN] SEMICOLON\n"); return SEMICOLON; }

"+"            { printf("[TOKEN] PLUS\n"); return PLUS; }
"-"            { printf("[TOKEN] MINUS\n"); return MINUS; }
"*"            { printf("[TOKEN] MUL\n"); return MUL; }
"/"            { printf("[TOKEN] DIV\n"); return DIV; }

"=="           { printf("[TOKEN] EQ\n"); return EQ; }
"<="           { printf("[TOKEN] LE\n"); return LE; }
">="           { printf("[TOKEN] GE\n"); return GE; }

"<"            { printf("[TOKEN] LT\n"); return LT; }
">"            { printf("[TOKEN] GT\n"); return GT; }

"("            { printf("[TOKEN] LPAREN\n"); return LPAREN; }
")"            { printf("[TOKEN] RPAREN\n"); return RPAREN; }

[0-9]+ {
    printf("[TOKEN] NUMBER(%s)\n", yytext);
    yylval.str = strdup(yytext);
    return NUMBER;
}

[a-zA-Z][a-zA-Z0-9]* {
    printf("[TOKEN] ID(%s)\n", yytext);
    yylval.str = strdup(yytext);
    return ID;
}

[ \t\n]+       ;

. { printf("Invalid character: %s\n", yytext); }

%%

int yywrap() { return 1; }