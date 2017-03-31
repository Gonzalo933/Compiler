CC = gcc
CFLAGS  = -Wall
EXE = pruebaMorfo
all : $(EXE)

pruebaMorfo:  lex.yy.o main.o
	$(CC) $(CFLAGS) -o pruebaMorfo lex.yy.o main.o

main.o: main.c tokens.h
	$(CC) $(CFLAGS) -c main.c

lex.yy.o:  lex.yy.c tokens.h
	$(CC) $(CFLAGS) -c lex.yy.c
lex.yy.c: 
	flex alfa.l

clean :
	rm -f *.o core $(EXE)
