%{ 
#include <stdio.h> //no necesario
#include "tokens.h"
int linea=1;
int columna=1;
/*version 1.2*/
%}
IDENTIFICADOR [0-9a-zA-Z]
DIGITO [0-9]
LETRA [a-zA-Z]
ESPACIO [ \r\t]
SALTO [\n]
TODO [^\n]
%%
"//"({TODO})* {}
printf { return TOK_PRINTF; }
scanf { return TOK_SCANF; }
while { return TOK_WHILE; }
main { return TOK_MAIN; }
"=" { return TOK_ASIGNACION; }
"==" { return TOK_IGUAL; }
"||" { return TOK_OR; }
"&&" { return TOK_AND; }
"!" { return TOK_NOT; }
"!=" { return TOK_DISTINTO; }
"*" { return TOK_ASTERISCO; }
"/" {return TOK_DIVISION;}
"+" { return TOK_MAS; }
"-" {return TOK_MENOS;}
">=" {  return TOK_MAYORIGUAL; }
"<=" {  return TOK_MENORIGUAL; }
"<" {  return TOK_MENOR; }
">" {  return TOK_MAYOR; }
"(" { return TOK_PARENTESISIZQUIERDO;}
")" { return TOK_PARENTESISDERECHO;}
"{" { return TOK_LLAVEIZQUIERDA;}
"}" { return TOK_LLAVEDERECHA;}
"[" { return TOK_CORCHETEIZQUIERDO;}
"]" { return TOK_CORCHETEDERECHO;}
int { return TOK_INT;}
boolean {return TOK_BOOLEAN; }
array {return TOK_ARRAY; }
function {return TOK_FUNCTION; }
if {return TOK_IF; }
else {return TOK_ELSE; }
return {return TOK_RETURN; }
true { return TOK_TRUE;}
false { return TOK_FALSE;}
{DIGITO}+ { return TOK_CONSTANTE_ENTERA;}
{LETRA}+{IDENTIFICADOR}* { return TOK_IDENTIFICADOR;}
"," { return TOK_COMA; }
";" { return TOK_PUNTOYCOMA; }
{ESPACIO} {columna++;}
{SALTO} {linea++; columna=1;}
. {return TOK_ERROR;}
%%
int yywrap(){
return 1;
}
