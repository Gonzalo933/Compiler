CC = gcc
CFLAGS  = -g -Wall
EXE = prueba_tabla
all : $(EXE)

prueba_tabla:  main.o
	$(CC) $(CFLAGS) -o prueba_tabla main.o


main.o:  main.c estructuras.h 
	$(CC) $(CFLAGS) -c main.c

clean :
	rm -f *.o core $(EXE)
