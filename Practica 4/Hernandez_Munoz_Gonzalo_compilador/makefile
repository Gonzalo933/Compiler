BISON=bison -d -y -v
FLEX=flex
CC=gcc
CFLAGS=-Wall

all: alfa

alfa: 
	$(BISON) sintactico.y
	$(FLEX) alfa.l
	$(CC) -o alfa main.c tabla_simbolos.c generacion.c y.tab.c lex.yy.c $(CFLAGS)



clean:
		rm -f lex.yy.c y.tab.c y.tab.h y.output core alfa
