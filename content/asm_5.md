
Это уже пятая часть цикла "Say hello to x86_64 Assembly" и здесь мы рассмотрим макросы. Это не будет блог-пост о x86_64, в основном он будет об ассемблере NASM и его препроцессоре. Если вам это интересно, читайте дальше.

## Макросы

NASM поддерживает две формы макросов:

* однострочные
* многострочные

Все однострочные макросы должны начинаться с директивы `%define`. В общем случае они выглядят следующим образом:

```assembly
%define macro_name(parameter) value
```

Макрос NASM ведет себя и выглядит очень так же как и макрос в C. Например, мы можем создать следующий однострочный макрос:

```assembly
%define argc rsp + 8
%define cliArg1 rsp + 24
```

и затем использовать его в коде:

```assembly
;;
;; argc will be expanded to rsp + 8
;;
mov rax, [argc]
cmp rax, 3
jne .mustBe3args
```

Многострочный макрос начинается с директивы `%macro ` и заканчивается `%endmacro`. Его общая выглядит вот так:

```assembly
%macro number_of_parameters
    instruction
    instruction
    instruction
%endmacro
```

Для примера:

```assembly
%macro bootstrap 1
          push ebp
          mov ebp,esp
%endmacro
```

Использовать его мы можем вот так:

```assembly
_start:
    bootstrap
```

Для примера создадим макрос для вывода строки на экран `PRINT`

```assembly
%macro PRINT 1
    pusha
    pushf
    jmp %%astr
%%str db %1, 0
%%strln equ $-%%str
%%astr: _syscall_write %%str, %%strln
popf
popa
%endmacro

%macro _syscall_write 2
	mov rax, 1
        mov rdi, 1
        mov rsi, %%str
        mov rdx, %%strln
        syscall
%endmacro
```

Давайте попробуем разобрать этот макрос и понять, как он работает: В первой строке мы определили макрос `PRINT` с одним параметром. Затем мы помещаем все регистры общего назначения (с помощью инструкции `pusha`) и регистр флагов (с помощью инструкции `pushf`) в стек. После этого мы переходим к метке `%%astr`. Обратите внимание, что все метки, которые определены в макросе, должны начинаться с `%%`. Теперь мы переходим к макросу `__syscall_write` с 2 параметрами. Давайте рассмотрим реализацию `__syscall_write`. Вы можете помнить, что во всех предыдущих постах мы использовали системный вызов `write` для вывода строки в `stdout`. Выглядит это следующим образом:

```assembly
;; write syscall number
mov rax, 1
;; file descriptor, standard output
mov rdi, 1
;; message address
mov rsi, msg
;; length of message
mov rdx, 14
;; call write syscall
syscall
```

В нашем макросе `__syscall_write` мы определяем первые две инструкции для помещения 1 в регистры `rax` (запись номера системного вызова) и `rdi` (файловый дескриптор stdout). Затем мы помещаем `%%str` в регистр `rsi` (указатель на строку), где `%%str `— локальная метка, к которой мы получаем первый параметр макроса `PRINT` (обратите внимание, что доступ к параметру макроса осуществляется по `$parameter_number`) и заканчивается `0` (каждая строка должна заканчиваться нулем). `%%strlen` вычисляет длину строки. После этого мы вызываем системный вызов с помощью инструкции `syscall`, и на этом макрос заканчивается

Теперь мы можем очень просто его использовать:

```assembly
label: PRINT "Hello World!"
```

## Полезные стандартные макросы

NASM поддерживает следующие стандартные макросы:

### STRUC

Мы можем использовать `STRUCT` и `END STRUCT` для определения структуры данных. Например:

```assembly
struc person
   name: resb 10
   age:  resb 1
endstruc
```

И теперь мы можем создать экземпляр нашей структуры:

```assembly
section .data
    p: istruc person
      at name db "name"
      at age  db 25
    iend

section .text
_start:
    mov rax, [p + person.name]
```

### %include

Мы можем включать другие файлы сборки и переходить к их меткам или вызывать функции с помощью директивы %include.
