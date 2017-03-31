
#ifndef _ALFA_H
#define _ALFA_H



#define MAX_LONG_ID 100
#define MAX_TAMANIO_VECTOR 64

/* Ni idea de si esta bien este fichero */


#define TIPO_ENTERO 11
#define TIPO_LOGICO 12

#define CLASE_ESCALAR 13
#define CLASE_VECTOR 14

typedef struct
{
char lexema[MAX_LONG_ID+1];
int tipo; 
int valor_entero;
int es_direccion;
int etiqueta;
} tipo_atributos;





/* TABLA DE SIMBOLOS*/

#define TAMANO_HASH 23
#define OK 1
#define ERR -1

typedef int bool;
#define true 1
#define false 0






/*
****************************************************************
********************** Elemento Nodo ***************************
****************************************************************
 */
typedef struct /* elemento de la lista */ {
    char *id;
    int valor;
	/*Nueva estructura*/
	int clase;
	int tipo;
	int tamano_vector;
	bool esFuncion;
	/*funciones*/
	int numero_parametros;
	int posicion_parametro;
	int numero_variables_locales;
	int posicion_variable_local;

} elementoNodo;
/* FUNCIONES */
char *idElemNodo(elementoNodo *ele);
int valorElemNodo(elementoNodo ele);






/*
****************************************************************
***************************** NODO *****************************
****************************************************************
 */
typedef struct  {
    elementoNodo elem; /* información del nodo de la lista */
    struct nodo* siguiente; /* puntero al siguiente nodo */
} nodo;

/* FUNCIONES */
nodo *buscarNodoId(nodo* node, char *id);
nodo * buscarNodoVacio(nodo* node);
nodo * creaNodo(char *id, int valor);
char * idNodo(nodo *node);
void liberarNodos(nodo * node);
int valorNodo(nodo *node);

nodo * siguienteNodo(nodo *node);
nodo * addClaseNodo(nodo * node, int clase);
nodo * addTipoNodo(nodo * node, int tipo);
nodo * addTamanoVector(nodo * node,int tam);
nodo * addNumeroParametros(nodo *node,int tam);
nodo * addNumeroVariables(nodo *node,int tam);
nodo *  crearNodoFuncion(char *id,int tipo,int clase,int tam,int posicion);
nodo * creaNodoVariableFuncion(char *id,int tipo,int clase,int tam,int pos,int posLocal);
nodo * creaNodoVariable(char *id,int tipo,int clase,int tam,int posicion);

int numParametros(nodo *node);
int tipoNodo(nodo *node);
bool esFuncion(nodo *node);
int tamanoNodo(nodo *node);
char * lexemaNodo(nodo *node);
int posicionParametro(nodo *node);
int posicionVariable(nodo *node);
int numVarLocales(nodo *node);




/*
****************************************************************
***************************** HASH *****************************
****************************************************************
 */
typedef struct {
    nodo * elemHash[TAMANO_HASH];
} tablaHash;

/* FUNCIONES */
nodo * buscarNodo(char *id,tablaHash *hash);
tablaHash *crearHash();
int destruirHash(tablaHash *hash);
int indiceHash(char * id);
int inicializarHash(tablaHash * hash);
int insertarElem(char *id, tablaHash *hash, nodo* node);
int insertarEnIndice(tablaHash *hash, int i, nodo *node);
int vaciarHash(tablaHash *hash);
int vaciarHashAux(tablaHash *hash);






#endif
