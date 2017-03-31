#ifndef _GENERACION_H
#define _GENERACION_H


#include "alfa.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void cabecera_codigo(FILE *f);
void segmento_datos(tablaHash *tabla, FILE * f);
void etiqueta_main(FILE *f);
void mensajes_error(FILE *f);
void errores_fin(FILE *f);
void gc_suma_enteros(FILE * f,int es_direccion_op1,int es_direccion_op2);
void gc_resta_enteros(FILE * f,int es_direccion_op1,int es_direccion_op2);
void gc_divide_enteros(FILE * f, int es_direccion_op1, int es_direccion_op2);
void gc_multiplica_enteros(FILE * f, int es_direccion_op1, int es_direccion_op2);
void gc_unario(FILE * f, int es_direccion_op1);
void gc_and(FILE * f, int es_direccion_op1, int es_direccion_op2);
void gc_or(FILE * f, int es_direccion_op1, int es_direccion_op2);
void gc_not(FILE * f, int es_direccion_op1,int etiqueta);
void gc_igual(FILE * f, int es_direccion_op1, int es_direccion_op2,int etiqueta);
void gc_distinto(FILE * f, int es_direccion_op1, int es_direccion_op2,int etiqueta);
void gc_menorigual(FILE * f, int es_direccion_op1, int es_direccion_op2, int etiqueta);
void gc_mayorigual(FILE * f, int es_direccion_op1, int es_direccion_op2, int etiqueta);
void gc_menor(FILE * f, int es_direccion_op1, int es_direccion_op2,int etiqueta);
void gc_mayor(FILE * f, int es_direccion_op1, int es_direccion_op2,int etiqueta);
void gc_vector_dentro_rango(FILE * f, int es_direccion_op1, int tamano);
void gc_direccion_vector(FILE * f, char* lexema);
void gc_identificador_igual_identificador(FILE * f, int es_direccion_op1, char * lexema);
void gc_asignacion_funcion_parametro(FILE * f, int es_direccion_op1, int posicion,int locales);
void gc_asignacion_funcion_variable(FILE * f, int es_direccion_op1, int posicion);
void gc_asignacion_elemento_vector(FILE * f, int es_direccion_op1);
void gc_scanf (FILE * f, char* lexema, int tipo);
void gc_scanf_parametro(FILE * f, int tipo,int posicion,int total);
void gc_scanf_variable (FILE * f, int tipo,int posicion);
void gc_if(FILE * f, int es_direccion_op1, int etiqueta);
void gc_else(FILE * f, int etiqueta);
void gc_while(FILE * f,int es_direccion, int etiqueta);
void gc_llamada_funcion (FILE * f, char *lexema, int par_llamada_actual);
void gc_cuerpo_funcion (FILE * f, char *lexema, int num_variables);
void gc_final_funcion (FILE * f, int es_direccion_op1);



































#endif
