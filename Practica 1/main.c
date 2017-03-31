/* 
 * File:   main.c
 * Author: e267362
 *
 * Created on 17 de octubre de 2013, 13:59
 */

#include <stdio.h>
#include <stdlib.h>
#include "estructuras.h"
#include <string.h>

int main(int argc, char** argv) {
    tablaHash *hashLocal;
    tablaHash *hashGlobal;
    bool ambitoAbierto = false;

    if (argc != 3) {
        printf("Error en los argumentos");
        return;
    }
    char *ficheroIN;
    char *ficheroOUT;
    ficheroIN = argv[1];
    ficheroOUT = argv[2];



    FILE *fIN = NULL;
    FILE *fOUT = NULL;
    fIN = fopen(ficheroIN, "r");
    fOUT = fopen(ficheroOUT, "w");
    if (fIN == NULL || fOUT == NULL) {
        printf("Error al abrir los ficheros.\n");
        return;
    }


    hashLocal = crearHash();
    hashGlobal = crearHash();
    inicializarHash(hashGlobal);
    inicializarHash(hashLocal);
    if (hashLocal == NULL || hashGlobal == NULL) {
        return -1;
    }

    //ambito actual
    tablaHash *ambitoActual = hashGlobal;

    char cadena[60];
    char *id;
    char *num;
    int valor;
    while ( fgets(cadena, 60, fIN) !=NULL) {        
        //ptr -> id        
        id = strtok(cadena, " \t\n\r");
        //ptr -> entero o null
        num = strtok(NULL, " \t\n\r");
        if (num != NULL) {

            valor = atoi(num);
            //si valor >= 0 insertar variable en ambito actual, dentro de esa funcion se comprueba si ya existe
            if (valor >= 0) {
                if (insertarElem(id, ambitoActual, creaNodo(id, valor)) == ERR) {
                    //ERROR AL INSERTAR ELEMENTO (YA EXISTE))
                    // printf("-1\t%s\n", id);
                    fprintf(fOUT, "-1\t%s\n", id);
                } else {
                    //SE INSERTA ELEMENTO CON EXISTO
                    //printf("%s\t%d\n", id, valor);
                    fprintf(fOUT, "%s\n", id);
                }
                //crear o cerrar ambito
            } else if (valor < 0) {
                //1 comprobar si se quiere cerrar ambito abierto
                if ((strcmp(id, "cierre") == 0)&&(valor == -999)) {
                    if (ambitoAbierto == true) {
                        vaciarHash(ambitoActual);
                        ambitoActual = hashGlobal;
                        ambitoAbierto = false;
                        //printf("cierre\n");
                        //AMBITO CERRADO CON EXITO
                        fprintf(fOUT, "cierre\n");
                    }
                } else {
                    //2 comprobar que no esta abierto otro ambito
                    if (ambitoAbierto == true) {
                        //NO SE PUEDE ABRIR OTRO AMBITO, YA HAY UNO ABIERTO
                        fprintf(fOUT, "-1\t%s\n", id);
                    } else {
                        if(insertarElem(id, ambitoActual, creaNodo(id, valor))==ERR){
                            //ya hubo un ambito con ese nombre, error
                            fprintf(fOUT, "-1\t%s\n", id);
                        }else{
                        ambitoActual = hashLocal;
                        ambitoAbierto = true;
                        insertarElem(id, ambitoActual, creaNodo(id, valor));
                        //AMBITO ABIERTO CON EXITO
                        //printf("%s\n", id);
                        fprintf(fOUT, "%s\n", id);
                    }
                    }
                }

            }
        } else {
            //no hay valor
            valor = NULL;
            //se busca el identificador en hash
            nodo* busqueda = buscarNodo(id, ambitoActual);            
            if (busqueda == NULL) {                
                // printf("%s\t-1\n", id);
                //NO SE ENCUENTA EL NODO EN LA TABLA
                //puede estar en la tabla global,si es que se ha buscado en la local
                if(ambitoAbierto==true){
                    busqueda = buscarNodo(id, hashGlobal);
                     if (busqueda == NULL) {   
                         //AHORA SI QUE NO ESTA
                         fprintf(fOUT, "%s\t-1\n", id);
                     }else{
                         //encontrado
                          fprintf(fOUT, "%s\t%d\n", id, valorNodo(busqueda));
                     }
                }else{
                    //no hay mas ambitos abiertos, no se encuentra
                  fprintf(fOUT, "%s\t-1\n", id);   
                }
                
            } else {
                //NODO ENCONTRADO
                // printf("PRUEBA:%s\t%d\n", id, valorNodo(busqueda));
                fprintf(fOUT, "%s\t%d\n", id, valorNodo(busqueda));
            }
        }
    }


    fclose(fOUT);
    fclose(fIN);
    vaciarHash(hashLocal);
    vaciarHash(hashGlobal);
    destruirHash(hashLocal);
    destruirHash(hashGlobal);
    return;
}

char *idElemNodo(elementoNodo *ele) {
    return ele->id;
}

int valorElemNodo(elementoNodo ele) {
    return ele.valor;
}

int valorNodo(nodo *node) {
    if (node == NULL) {
        return NULL;
    }
    return valorElemNodo(node->elem);
}
char * idNodo(nodo *node) {
    if (node == NULL) {
        return NULL;
    }
    elementoNodo *ele = (elementoNodo*)&((node)->elem);
    return idElemNodo(ele);
}

tablaHash *crearHash() {
    return (tablaHash *) malloc(sizeof (tablaHash));
}

nodo * creaNodo(char *id, int valor) {
    /*Error aqui */
    nodo * node = (nodo *) malloc(sizeof (nodo));
    node->elem.valor = valor;
    node->elem.id = (char *) malloc(sizeof (char)*strlen(id));
    strcpy(node->elem.id, id);   
    
    node->siguiente = NULL;
    return node;
}

nodo * buscarNodo(char *id, tablaHash *hash) {
    if (id == NULL) {
        return NULL;
    }
    int indice = indiceHash(id);
    if (hash->elemHash[indice] == NULL) {
        return NULL;
    }
    return buscarNodoId(hash->elemHash[indice], id);

}

int insertarElem(char *id, tablaHash *hash, nodo* node) {
    return insertarEnIndice(hash, indiceHash(id), node);
}



int insertarEnIndice(tablaHash *hash, int i, nodo *node) {

    if (hash->elemHash[i] == NULL) {
        //la lista en ese indice no existe, crearla
        //1 se reserva memoria para un nodo, 2 se hae apuntar el anterior nodo al nuevo

        if (node == NULL) {
            return ERR;
        }
        hash->elemHash[i] = node;
        return OK;
    } else {
        //buscar si ya existe un nodo con esa id
        if (buscarNodoId(hash->elemHash[i], node->elem.id) != NULL) {
            return ERR;
        }

        nodo* vacio = buscarNodoVacio(hash->elemHash[i]);

        if (vacio == NULL) {


        }
        vacio->siguiente = node;


        return OK;
    }
    return ERR;
}

nodo *buscarNodoId(nodo* node, char *id) {
    char *actual = node->elem.id;
    if (strcmp(actual, id) == 0) {
        return node;
    }
    if (node->siguiente == NULL) {
        return NULL;
    }
    return buscarNodoId(node->siguiente, id);
}

nodo * buscarNodoVacio(nodo* node) {

    if (node->siguiente == NULL) {
        return node;
    }
    return buscarNodoVacio(node->siguiente);
}

void liberarNodos(nodo * node) {
    if (node->siguiente == NULL) {//çççççç
        free(node);
        return;
    }
    liberarNodos(node->siguiente);
    free(node);
    return;

}

int destruirHash(tablaHash *hash) {
    free(hash);
    return OK;
}

int vaciarHash(tablaHash *hash) {
    int i = 0;
    for (i = 0; i < TAMANO_HASH; i++) {
        if (hash->elemHash[i] != NULL) {
            liberarNodos(hash->elemHash[i]);
            hash->elemHash[i]=NULL;
        }
    }

    return OK;

}

int inicializarHash(tablaHash * hash) {
    int i = 0;
    for (i = 0; i < TAMANO_HASH; i++) {
        hash->elemHash[i] = NULL;
    }
    return OK;
}

int indiceHash(char * id) {
    int i = 0;
    int suma = 0;
    for (i = 0; id[i] != '\0'; i++) {
        suma += id[i];
    }

    return suma % TAMANO_HASH;
}