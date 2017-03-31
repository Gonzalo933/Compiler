CC=cc

CFLAGS=-g 


EJECUTABLES=pruebaSintactico


all: $(EJECUTABLES)


pruebaSintactico: y.tab.o lex.yy.o main.o
	@echo Creando ejecutable pruebaSintactico...
	gcc -o pruebaSintactico  y.tab.o lex.yy.o main.o

main.o: main.c 
	@echo Compilando main.o ...
	gcc -c main.c

lex.yy.o: lex.yy.c
	@echo Compiando lex.yy.o ...
	gcc -c lex.yy.c

lex.yy.c: alfa.l
	@echo Generando lex.yy.c ...
	flex alfa.l

y.tab.o: y.tab.c
	@echo Compilando y.tab.o ...
	gcc -c y.tab.c

y.tab.c: alfa.y 
	@echo Creando y.tab.c ...
	bison -d -y alfa.y

clean:
	rm -rf *\.o *\.a pruebaSintactico lex.yy.c y.tab.* *~ $(EJECUTABLES)

