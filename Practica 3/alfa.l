%{ 
#include <stdio.h> //no necesario
#include "y.tab.h"
int linea=1;
int columna=1;
int flag=0;
#define TOK_ERROR -1

%}
IDENTIFICADOR [0-9a-zA-Z]
DIGITO [0-9]
LETRA [a-zA-Z]
ESPACIO [ \r\t]
SALTO [\n]
TODO [^\n]
%%
"//"({TODO})* {}
printf { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_PRINTF; }
scanf { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_SCANF; }
while { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_WHILE; }
main { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_MAIN; }
"==" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_IGUAL; }
"=" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_ASIGNACION; }
"||" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_OR; }
"&&" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_AND; }
"!=" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_DISTINTO; }
"!" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_NOT; }
"*" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_ASTERISCO; }
"/" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_DIVISION;}
"+" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_MAS; }
"-" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_MENOS;}
">=" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_MAYORIGUAL; }
"<=" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_MENORIGUAL; }
"<" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_MENOR; }
">" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_MAYOR; }
"(" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_PARENTESISIZQUIERDO;}
")" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_PARENTESISDERECHO;}
"{" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_LLAVEIZQUIERDA;}
"}" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_LLAVEDERECHA;}
"[" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_CORCHETEIZQUIERDO;}
"]" { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_CORCHETEDERECHO;}
int { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_INT;}
boolean {columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_BOOLEAN; }
array {columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_ARRAY; }
function { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_FUNCTION; }
if {columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_IF; }
else {columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_ELSE; }
return {columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_RETURN; }
true {columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_TRUE;}
false { columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_FALSE;}
{DIGITO}+ {columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_CONSTANTE_ENTERA;}
{LETRA}+{DIGITO}* {columna += yyleng; if(yyleng > 100){printf("\t**** Error en [lin %d, col %d]: identificador %s demasiado largo!!\n",linea,columna,yytext); fprintf(yyout,";D:\t%s\n",yytext); return TOK_ERROR;} fprintf(yyout,";D:\t%s\n",yytext); return TOK_IDENTIFICADOR;}
"," {columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_COMA; }
";" {columna += yyleng; fprintf(yyout,";D:\t%s\n",yytext); return TOK_PUNTOYCOMA; }
{ESPACIO} {columna++;}
{SALTO} {linea++; columna=1;}
. {columna+= yyleng; flag = 1; printf("\t**** Error en [lin %d, col %d]: caracter %s no permitido\n",linea,columna-yyleng,yytext); return TOK_ERROR;}
%%
int yywrap(){
return 1;
}
