;; Definition of the .data section
section .data
    ;; The first number
    num1 dq 0x64
    ;; The second number
    num2 dq 0x32
    ;; The message to print if the sum is correct
    msg  db "The sum is correct!", 10

;; Definition of the .text section
section .text
    ;; Reference to the entry point of our program
    global _start

;; Entry point
_start:
<<<<<<< HEAD
    ;; Set the value of the num1 to the rax
    mov rax, [num1]
    ;; Set the value of the num2 to the rbx
    mov rbx, [num2]
    ;; Get sum of the rax and rbx. The result is stored in the rax.
    add rax, rbx
.compare:
    ;; Compare the value of the rax with `150`
    cmp rax, 150
    ;; Go to the .exit label if the values of the rax and 150 are not equal
    jne .exit
    ;; Go to the .correctSum label if the values of the rax and 150 are equal
    jmp .correctSum

; Print message that the sum is correct
.correctSum:
    ;; Number of the sytem call. 1 - `sys_write`.
    mov rax, 1
    ;; The first argument of the `sys_write` system call. 1 is `stdout`.
    mov rdi, 1
    ;; The second argument of the `sys_write` system call. Reference to the message.
    mov rsi, msg
    ;; The third argument of the `sys_write` system call. Length of the message.
    mov rdx, 20
    ;; Call the `sys_write` system call.
    syscall
    ; Go to the exit of the program.
=======
    ;; Set the value of num1 to rax
    mov rax, [num1]
    ;; Set the value of num2 to rbx
    mov rbx, [num2]
    ;; Get the sum of rax and rbx. The result is stored in rax.
    add rax, rbx
.compare:
    ;; Compare the rax value with 150
    cmp rax, 150
    ;; Go to the .exit label if the rax value is not 150
    jne .exit
    ;; Go to the .correctSum label if the rax value is 150
    jmp .correctSum

;; Print a message that the sum is correct
.correctSum:
    ;; Specify the system call number (1 is `sys_write`).
    mov rax, 1
    ;; Set the first argument of `sys_write` to 1 (`stdout`).
    mov rdi, 1
    ;; Set the second argument of `sys_write` to the reference of the `msg` variable.        
    mov rsi, msg
    ;; Set the third argument to the length of the `msg` variable's value (20 bytes).
    mov rdx, 20
    ;; Call the `sys_write` system call.
    syscall
    ;; Go to the exit of the program.
>>>>>>> f4a4294 (Merge pull request #29 from 0xAX/chapter-2-update)
    jmp .exit

;; Exit procedure
.exit:
<<<<<<< HEAD
    ;; Number of the system call. 60 - `sys_exit`.
    mov rax, 60
    ;; The first argument of the `sys_exit` system call.
=======
    ;; Specify the number of the system call (60 is `sys_exit`).
    mov rax, 60
    ;; Set the first argument of `sys_exit` to 0. The 0 status code is success.
>>>>>>> f4a4294 (Merge pull request #29 from 0xAX/chapter-2-update)
    mov rdi, 0
    ;; Call the `sys_exit` system call.
    syscall
