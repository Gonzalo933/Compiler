/* 
 * File:   estructuras.h
 * Author: e267362
 *
 * Created on 17 de octubre de 2013, 14:02
 */

#ifndef ESTRUCTURAS_H
#define	ESTRUCTURAS_H

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

#endif	/* ESTRUCTURAS_H */

