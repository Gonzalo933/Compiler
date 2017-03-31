CC = gcc
CFLAGS  = -Wall
EXE = pruebaSintactico
all : $(EXE)

pruebaSintactico:  y.tab.o lex.yy.o main.o
	$(CC) $(CFLAGS) -o pruebaSintactico y.tab.o lex.yy.o main.o

main.o: main.c
	$(CC) $(CFLAGS) -c main.c

lex.yy.o:  lex.yy.c
	$(CC) $(CFLAGS) -c lex.yy.c
lex.yy.c: alfa.l
	flex alfa.l
y.tab.o: y.tab.c
	$(CC) $(CFLAGS) -c y.tab.c
y.tab.c: sintactico.y
	bison -dy sintactico.y
clean :
	rm -f *.o core $(EXE)
