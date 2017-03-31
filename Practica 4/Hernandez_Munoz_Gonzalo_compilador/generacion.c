#include "generacion.h"



void cabecera_codigo(FILE *f){		

   	fprintf(f, "\n\nsegment .text\n\n");
   	fprintf(f, "global main\n");
   	fprintf(f, "extern scan_int, scan_boolean\n");
   	fprintf(f, "extern print_int, print_boolean, print_string, print_blank, print_endofline\n\n");
}


void segmento_datos(tablaHash *tabla, FILE * f){
	int i;
	nodo * node; /* un nodo tiene elemento  o siguiente, dentro de elemento esta toda la informacion*/	
	fprintf (f, "segment .bss\n\n");

	for(i=0; i<TAMANO_HASH; i++){
		node=tabla->elemHash[i];
		while (node!=NULL){	
			fprintf (f, "_%s resd %d\n", lexemaNodo(node),tamanoNodo(node));
			node=siguienteNodo(node);		
		}			
	}	
	return;
}

void etiqueta_main(FILE *f){
fprintf(f, "main: \n\n");
return;
}

void mensajes_error(FILE *f){
fprintf(f, "segment .data\n\n");
fprintf(f, "mensaje_1 db \"Indice fuera de rango\" , 0\n");
fprintf(f, "mensaje_2 db \"Division entre cero\" , 0\n\n\n");
return;
}

void errores_fin(FILE *f){
      	fprintf(f, "\njmp near fin\n" );
      	fprintf(f, "error_1: push dword mensaje_1\n");
      	fprintf(f, "		call print_string\n");
      	fprintf(f, "		call print_endofline\n");
      	fprintf(f, "		add esp, 4\n");
      	fprintf(f, "		jmp near fin\n");
   
      	fprintf(f, "jmp near fin\n");
      	fprintf(f, "error_2: push dword mensaje_2\n");
      	fprintf(f, "		call print_string\n");
     	fprintf(f, "		call print_endofline\n");
      	fprintf(f, "		add esp, 4\n");
     	fprintf(f, "		jmp near fin\n");
      	fprintf(f, "fin: ret\n ");
	return;
}
	
void gc_suma_enteros(FILE * f,int es_direccion_op1,int es_direccion_op2){

	fprintf(f, "; cargar el segundo operando en edx\n");
	fprintf(f, "pop dword edx\n");
	
	if (es_direccion_op2 == 1)
		fprintf(f, "mov dword edx , [edx]\n");
	
	fprintf(f, "; cargar el primer operando en eax\n");
	fprintf(f,"pop dword eax\n");
	
	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
	
	fprintf(f, "; realizar la suma y dejar el resultado en eax \n");
	fprintf(f, "add eax,edx\n");
	fprintf(f, "; apilar el resultado\n");
	fprintf(f, "push dword eax\n");
	
return;
}

void gc_resta_enteros(FILE * f,int es_direccion_op1,int es_direccion_op2){
	fprintf(f, "\npop dword edx\n");

	if (es_direccion_op2 == 1)
		fprintf(f, "mov dword edx , [edx]\n");
		
	fprintf(f,"pop dword eax\n");

	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
	fprintf(f, "sub eax,edx\n");
	fprintf(f, "push dword eax\n");

return;
}

void gc_divide_enteros(FILE * f, int es_direccion_op1, int es_direccion_op2) {	
	fprintf(f, "\npop dword edx\n");	
	if (es_direccion_op2 == 1)
		fprintf(f, "mov dword edx , [edx]\n");

	fprintf(f, "pop dword eax\n");
	fprintf(f, "cmp edx, 0\n");
	fprintf(f, "je near error_2\n"); /* Error de division entre 0*/

	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
	fprintf(f, "mov ecx, edx\n");
	fprintf(f, "cdq\n");
	fprintf(f, "idiv ecx\n");
	fprintf(f, "push dword eax\n");	
	
	return;
}

void gc_multiplica_enteros(FILE * f, int es_direccion_op1, int es_direccion_op2) {	
	fprintf(f, "\npop dword edx\n");
	if (es_direccion_op2 == 1)
		
		fprintf(f, "mov dword edx , [edx]\n");
	
	fprintf(f,"pop dword eax\n");

	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
		fprintf(f, "imul edx\n");
		fprintf(f, "push dword eax\n");
	return;

}

void gc_unario(FILE * f, int es_direccion_op1) {

	fprintf(f, "\npop dword eax\n");

	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
		
	fprintf(f, "neg eax\n");
	fprintf(f, "push dword eax\n");
	return;
}

void gc_and(FILE * f, int es_direccion_op1, int es_direccion_op2){

	/* Segundo operando en edx*/
	fprintf(f, "\npop dword edx\n");

	if (es_direccion_op2 == 1)
		fprintf(f, "mov dword edx , [edx]\n");
		
		/*Cargar el primer operando en eax*/
		fprintf(f,"pop dword eax\n");

	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
		
		fprintf(f, "and eax , edx\n");
		/*Apilar resultado*/
		fprintf(f, "push dword eax\n");
	return;
}

void gc_or(FILE * f, int es_direccion_op1, int es_direccion_op2){

	/* Segundo operando en edx*/
	fprintf(f, "\npop dword edx\n");

	if (es_direccion_op2 == 1)
		fprintf(f, "mov dword edx , [edx]\n");
		
		/*Cargar el primer operando en eax*/
		fprintf(f,"pop dword eax\n");

	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
		
		fprintf(f, "or eax , edx\n");
		/*Apilar resultado*/
		fprintf(f, "push dword eax\n");
	return;
}

void gc_not(FILE * f, int es_direccion_op1,int etiqueta){

	/*operando en eax*/
	fprintf(f, "\npop dword eax\n");


	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
		
		/* ver si eax es 0 y en ese caso saltar a negar_falso*/
		fprintf(f, "or eax , eax\n");
		fprintf(f, "jz near negar_falso%d\n",etiqueta);
		fprintf(f, "mov dword eax , 0\n");
		fprintf(f, "jmp near fin_negacion%d\n",etiqueta);
		fprintf(f, "negar_falso%d: mov dword eax , 1\n", etiqueta);
		fprintf(f, "fin_negacion%d:  push dword eax\n", etiqueta);

	return;
}

void gc_igual(FILE * f, int es_direccion_op1, int es_direccion_op2,int etiqueta){

	/*cargar la segunda expresión en edx*/
	fprintf(f, "\npop dword edx\n");

	if (es_direccion_op2 == 1)
		fprintf(f, "mov dword edx , [edx]\n");
		
		fprintf(f,"pop dword eax\n");

	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
		/*comparar y apilar el resultado*/
		fprintf(f, "cmp eax , edx\n");
		fprintf(f, "je near igual%d\n", etiqueta);
		fprintf(f, "push dword 0\n");
		fprintf(f, "jmp near fin_igual%d\n", etiqueta);
		fprintf(f, "igual%d:  push dword 1\n", etiqueta);
		fprintf(f, "fin_igual%d: \n", etiqueta);		
	return;
}

void gc_distinto(FILE * f, int es_direccion_op1, int es_direccion_op2,int etiqueta) {
	/*cargar la segunda expresión en edx*/
	fprintf(f, "\npop dword edx\n");

	if (es_direccion_op2 == 1)
		fprintf(f, "mov dword edx , [edx]\n");
		
		fprintf(f,"pop dword eax\n");

	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
		
		/*comparar y apilar el resultado*/
		fprintf(f, "cmp eax,edx\n");
		fprintf(f, "jne near distinto%d\n",etiqueta);
		fprintf(f, "push dword 0\n");
		fprintf(f, "jmp near fin_distinto%d\n",etiqueta);
		fprintf(f, "distinto%d:  push dword 1\n",etiqueta);
		fprintf(f, "fin_distinto%d: \n",etiqueta);
	return;
}

void gc_menorigual(FILE * f, int es_direccion_op1, int es_direccion_op2, int etiqueta) {

	fprintf(f, "\npop dword edx\n");

	if (es_direccion_op2 == 1)
		fprintf(f, "mov dword edx , [edx]\n");
		
		fprintf(f,"pop dword eax\n");

	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
		
		/*comparar y apilar el resultado*/
		fprintf(f, "cmp eax,edx\n");
		fprintf(f, "jle near menorigual%d\n",etiqueta);
		fprintf(f, "push dword 0\n");
		fprintf(f, "jmp near fin_menorigual%d\n",etiqueta);
		fprintf(f, "menorigual%d:  push dword 1\n",etiqueta);
		fprintf(f, "fin_menorigual%d: \n",etiqueta);
	return;
}

void gc_mayorigual(FILE * f, int es_direccion_op1, int es_direccion_op2, int etiqueta) {

	fprintf(f, "\npop dword edx\n");

	if (es_direccion_op2 == 1)
		fprintf(f, "mov dword edx , [edx]\n");
		
		fprintf(f,"pop dword eax\n");

	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
		
		/*comparar y apilar el resultado*/
		fprintf(f, "cmp eax,edx\n");
		fprintf(f, "jge near mayorigual%d\n",etiqueta);
		fprintf(f, "push dword 0\n");
		fprintf(f, "jmp near fin_mayorigual%d\n",etiqueta);
		fprintf(f, "mayorigual%d:  push dword 1\n",etiqueta);
		fprintf(f, "fin_mayorigual%d: \n",etiqueta);
	return;
}

void gc_menor(FILE * f, int es_direccion_op1, int es_direccion_op2,int etiqueta) {

	fprintf(f, "\npop dword edx\n");

	if (es_direccion_op2 == 1)
		fprintf(f, "mov dword edx , [edx]\n");
		
		fprintf(f,"pop dword eax\n");

	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
		
		/*comparar y apilar el resultado*/
		fprintf(f, "cmp eax,edx\n");
		fprintf(f, "jl near menor%d\n",etiqueta);
		fprintf(f, "push dword 0\n");
		fprintf(f, "jmp near fin_menor%d\n",etiqueta);
		fprintf(f, "menor%d:  push dword 1\n",etiqueta);
		fprintf(f, "fin_menor%d: \n",etiqueta);
	return;
}


void gc_mayor(FILE * f, int es_direccion_op1, int es_direccion_op2,int etiqueta) {

	fprintf(f, "\npop dword edx\n");

	if (es_direccion_op2 == 1)
		fprintf(f, "mov dword edx , [edx]\n");
		
		fprintf(f,"pop dword eax\n");

	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
		
		/*comparar y apilar el resultado*/
		fprintf(f, "cmp eax,edx\n");
		fprintf(f, "jg near mayor%d\n",etiqueta);
		fprintf(f, "push dword 0\n");
		fprintf(f, "jmp near fin_mayor%d\n",etiqueta);
		fprintf(f, "mayor%d:  push dword 1\n",etiqueta);
		fprintf(f, "fin_mayor%d: \n",etiqueta);
	return;
}

void gc_vector_dentro_rango(FILE * f, int es_direccion_op1, int tamano) {

	fprintf(f, "\npop dword eax\n");


	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
  	
	fprintf(f, "cmp eax,0\n");
	fprintf(f, "jl near error_1\n");
	fprintf(f, "cmp eax, %d\n",tamano- 1);
	fprintf(f, "jg near error_1\n");
		
	return;

}

void gc_direccion_vector(FILE * f, char * lexema) {
	/* Cargar en edx la dirección de inicio del vector*/
	fprintf(f, "\nmov dword edx, _%s\n", lexema);
	/*Cargar en eax la dirección del elemento indexado*/
	fprintf(f, "lea eax, [edx + eax*4]\n");
	/*Apilar la dirección del elemento indexado*/
	fprintf(f, "push dword eax\n");
		
	return;
}

void gc_identificador_igual_identificador(FILE * f, int es_direccion_op1, char * lexema) {
	
	fprintf(f, "\npop dword eax\n");

	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
		
		fprintf(f, "mov dword [_%s] , eax\n", lexema);
	return;
}
	
	
void gc_asignacion_funcion_parametro(FILE * f, int es_direccion_op1, int posicion,int locales) {
	
	fprintf(f, "\npop dword eax\n");

	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");

		fprintf(f, "mov dword [ebp+4+4*%d], eax\n", (locales - posicion));

	return;
}		
	
void gc_asignacion_funcion_variable(FILE * f, int es_direccion_op1, int posicion) {
/*No es parametro*/
	
	fprintf(f, "\npop dword eax\n");	
	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
		
		fprintf(f, "mov dword [ebp-4*%d], eax\n", posicion);

	return;
}	

void gc_asignacion_elemento_vector(FILE * f, int es_direccion_op1) {

	fprintf(f, "\npop dword eax\n");

	
	if (es_direccion_op1 == 1)
		fprintf(f, "mov dword eax , [eax]\n");
		
		fprintf(f, "pop dword edx\n");
		fprintf(f, "mov dword [edx] , eax\n");
		
	return;
}


/*Scanf*/

void gc_scanf (FILE * f, char* lexema, int tipo){

	fprintf(f, "\npush dword _%s\n",lexema );

	if(tipo==TIPO_ENTERO)
		fprintf(f, "call scan_int\n");
	else
		fprintf(f, "call scan_boolean\n");

		/*Restaurar la pila*/
	fprintf(f, "add esp,4\n" );
}


void gc_scanf_parametro(FILE * f, int tipo,int posicion,int total){


/* estas dos lineas*/
		fprintf(f, "\nlea eax, [ebp+4+4*%d]\n", (total - posicion));
		fprintf(f, "\npush dword eax\n");


	if(tipo==TIPO_ENTERO)
		fprintf(f, "call scan_int\n");
	else
		fprintf(f, "call scan_boolean\n");

	fprintf(f, "add esp,4\n " );

}



void gc_scanf_variable (FILE * f, int tipo,int posicion) {

/* Si hay fallos en lectura cambiar estas dos lineas por las dos lineas de la funcion de arriba,obviamente habra que cambiar los argumentos tambien  çç */
		fprintf(f, "\nlea eax, [ebp-4*%d]\n", posicion);
		fprintf(f, "\npush dword eax\n");

	if(tipo==TIPO_ENTERO)
		fprintf(f, "call scan_int\n");
	else
		fprintf(f, "call scan_boolean\n");

	fprintf(f, "add esp,4\n " );

	return;
}

void gc_printf(FILE * f, int es_direccion_op1,int tipo) {

	
	if (es_direccion_op1 == 1){
		fprintf(f, "\npop dword eax\n");
		fprintf(f, "mov dword eax , [eax]\n");
		fprintf(f, "push dword eax\n");
		}
		if(tipo==TIPO_ENTERO)
			fprintf(f, "call print_int\n");
		else
			fprintf(f, "call print_boolean\n");
			/*Restauración del puntero de pila*/
		fprintf(f, "add esp,4\n");
		/*call print_endofnile*/
		fprintf(f,"call print_endofline\n\n");
		
	return;
}


void gc_if(FILE * f, int es_direccion_op1, int etiqueta) {

	fprintf(f, "\npop eax\n");

	if (es_direccion_op1 == 1)
		fprintf(f, "mov eax, [eax]\n");
		
	fprintf(f, "cmp eax,0\n");
	fprintf(f, "je near fin_si%d\n",etiqueta);
	
		
	return;
}

void gc_else(FILE * f, int etiqueta) {

	fprintf(f, "\njmp near fin_sino%d\n",etiqueta);
	fprintf(f, "fin_si%d:\n",etiqueta);
	
		
	return;
}

void gc_while(FILE * f,int es_direccion, int etiqueta) {

	fprintf(f, "\npop eax\n");
	if (es_direccion==1)
		fprintf(f, "mov eax, [eax]\n");
		
	fprintf(f, "cmp eax,0\n");
	fprintf(f, "je near fin_while%d\n",etiqueta);

		
	return;
}


void gc_llamada_funcion (FILE * f, char *lexema, int par_llamada_actual){

	fprintf(f, "\ncall _%s\n", lexema);
	fprintf(f, "add esp, 4*%d\n", par_llamada_actual);
	fprintf(f, "push dword eax\n");

	return;
}

void gc_cuerpo_funcion (FILE * f, char *lexema, int num_variables){

/*_<nombre_funcion>:*/
	fprintf(f, "\n_%s:\n", lexema);
	fprintf(f, "push ebp\n");
	fprintf(f, "mov ebp, esp\n");
	/*sub esp, <4*nº variables locales>*/
	fprintf(f, "sub esp, 4*%d\n", num_variables);

	return;
	
}

void gc_final_funcion (FILE * f, int es_direccion_op1){

	fprintf(f, "\npop dword eax\n");
	
	if (es_direccion_op1 == 1)
		fprintf(f, "mov eax, [eax]\n");
		
	fprintf(f, "mov dword esp, ebp\n");
	fprintf(f, "pop dword ebp\n");
	fprintf(f, "ret\n");

	return;
}
