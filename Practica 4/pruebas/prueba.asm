segment .bss

_x resd 1

segment .text

global main
extern print_int, print_endofline, scan_int
main:
push dword _x

call scan_int
add esp, 4

push dword [_x]
call print_int
add esp, 4
call print_endofline
ret
