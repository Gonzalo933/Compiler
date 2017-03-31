%{ 
#include <stdio.h> //no necesario
#include "alfa.h"
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
printf { columna += yyleng;return TOK_PRINTF; }
scanf { columna += yyleng; return TOK_SCANF; }
while { columna += yyleng; return TOK_WHILE; }
main { columna += yyleng;  return TOK_MAIN; }
"==" { columna += yyleng;  return TOK_IGUAL; }
"=" { columna += yyleng;   return TOK_ASIGNACION; }
"||" { columna += yyleng;  return TOK_OR; }
"&&" { columna += yyleng;  return TOK_AND; }
"!=" { columna += yyleng;  return TOK_DISTINTO; }
"!" { columna += yyleng;  return TOK_NOT; }
"*" { columna += yyleng;  return TOK_ASTERISCO; }
"/" { columna += yyleng;  return TOK_DIVISION;}
"+" { columna += yyleng;  return TOK_MAS; }
"-" { columna += yyleng;  return TOK_MENOS;}
">=" { columna += yyleng; return TOK_MAYORIGUAL; }
"<=" { columna += yyleng; return TOK_MENORIGUAL; }
"<" { columna += yyleng;  return TOK_MENOR; }
">" { columna += yyleng;  return TOK_MAYOR; }
"(" { columna += yyleng;  return TOK_PARENTESISIZQUIERDO;}
")" { columna += yyleng; return TOK_PARENTESISDERECHO;}
"{" { columna += yyleng;  return TOK_LLAVEIZQUIERDA;}
"}" { columna += yyleng;  return TOK_LLAVEDERECHA;}
"[" { columna += yyleng;  return TOK_CORCHETEIZQUIERDO;}
"]" { columna += yyleng;  return TOK_CORCHETEDERECHO;}
int { columna += yyleng; return TOK_INT;}
boolean {columna += yyleng;  return TOK_BOOLEAN; }
array {columna += yyleng;  return TOK_ARRAY; }
function { columna += yyleng; return TOK_FUNCTION; }
if {columna += yyleng;  return TOK_IF; }
else {columna += yyleng;  return TOK_ELSE; }
return {columna += yyleng; return TOK_RETURN; }
true {columna += yyleng;  return TOK_TRUE;}
false { columna += yyleng;  return TOK_FALSE;}
{DIGITO}+ {columna += yyleng; yylval.atributos.valor_entero = atoi(yytext); return TOK_CONSTANTE_ENTERA;}
{LETRA}+{DIGITO}* {columna += yyleng; if(yyleng > 100){printf("\t**** Error en [lin %d, col %d]: identificador %s demasiado largo!!\n",linea,columna,yytext); return TOK_ERROR;} strcpy(yylval.atributos.lexema,yytext);  return TOK_IDENTIFICADOR;}
"," {columna += yyleng; return TOK_COMA; }
";" {columna += yyleng; return TOK_PUNTOYCOMA; }
{ESPACIO} {columna++;}
{SALTO} {linea++; columna=1;}
. {columna+= yyleng; flag = 1; printf("\t**** Error en [lin %d, col %d]: caracter %s no permitido\n",linea,columna-yyleng,yytext); return TOK_ERROR;}
%%
int yywrap(){
return 1;
}
