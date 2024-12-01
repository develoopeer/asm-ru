
Это уже шестая часть цикла статей "Say hello to x86_64 Assembly", и в ней мы рассмотрим синтаксис ассемблера AT&T. Ранее, во всех предыдущих частях, мы использовали ассемблер NASM, но есть и другие ассемблеры с другим синтаксисом, FASM, YASM и другие. Как я уже писал выше, мы рассмотрим gas (ассемблер GNU) и разницу между его синтаксисом и NASM. GCC использует ассемблер GNU, поэтому если вы посмотритет на испольняемый файл GNU ассемблера для простого hello world:

```C
#include <unistd.h>

int main(void) {
	write(1, "Hello World\n", 15);
	return 0;
}
```

То увидите следующее:

```assembly
	.file	"test.c"
	.section	.rodata
.LC0:
	.string	"Hello World\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$15, %edx
	movl	$.LC0, %esi
	movl	$1, %edi
	call	write
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.9.1-16ubuntu6) 4.9.1"
	.section	.note.GNU-stack,"",@progbits
```

Выглядит иначе, нежели "Hello World" ассемблера NASM, давайте рассмотрим некоторые отличия.

## AT&T синтаксис

### Разделы

Не знаю как вы, но когда я начинаю писать программу на ассемблере, обычно я начинаю с определения секций. Давайте рассмотрим простой пример:

```assembly
.data
    //
    // initialized data definition
    //
.text
    .global _start

_start:
    //
    // main routine
    //
```

Здесь вы можете заметить два небольших отличия:

* Определение раздела начинается с символа `.`
* Основная процедура определяется с помощью `.globl` вместо `global`, как мы делаем в NASM

Также gas использует другие директивы для определения данных:

```assembly
.section .data
    // 1 byte
    var1: .byte 10
    // 2 byte
    var2: .word 10
    // 4 byte
    var3: .int 10
    // 8 byte
    var4: .quad 10
    // 16 byte
    var5: .octa 10

    // assembles each string (with no automatic trailing zero byte) into consecutive addresses
    str1: .asci "Hello world"
    // just like .ascii, but each string is followed by a zero byte
    str2: .asciz "Hello world"
    // Copy the characters in str to the object file
    str3: .string "Hello world"
```

Порядок операндов
Когда мы пишем программу на ассемблере с помощью NASM, у нас есть следующий общий синтаксис для манипулирования данными:

```assembly
mov destination, source
```

С ассемблером GNU порядок операндов обратный NASM, а именно:

```assembly
mov source, destination
```

К примеру

```assembly
;;
;; nasm syntax
;;
mov rax, rcx

//
// gas syntax
//
mov %rcx, %rax
```

Также регистры начинаются с символа %. Если вы используете прямые операнды, нужно использовать символ `$`:

```assembly
movb $10, %rax
```

### Размер операндов и синтаксис инструкций

Иногда, когда нам нужно получить часть памяти регистра, например, первый байт 64 битного регистра, мы используем следующий синтаксис:

```assembly
mov ax, word [rsi]
```

Есть другой способ для таких операций в ассемблере Gas. Мы определяем размер не в операндах, а в инструкции:

```assembly
movw (%rsi), %ax
```

В ассемблере GNU имеется 6 постфиксов(окончаний) для операций:

* `b` - 1 байт операнда
* `w` - 2 байта операнда
* `l` - 4 байта операнда
* `q` - 8 байт операнда
* `t` - 10 байт операнда
* `o` - 16 байт операнда

Это правило касается не только инструкции mov, но и всех других, таких как addl, xorb, cmpw и т. д.

### Доступ к памяти

Вы можете заметить, что мы использовали скобки () в предыдущем примере, нежели [] в примере с NASM. Для разыменования значений в скобках используется: 
`(%rax)`, например:

```assembly
movq -8(%rbp),%rdi
movq 8(%rbp),%rdi
```

### Переходы

Ассемблер GNU поддерживает следующие операторы для вызова и перехода функций:

```assembly
lcall $section, $offset
```

Дальний переход(far jump) — переход к инструкции, расположенной в сегменте, отличном от текущего сегмента кода, но на том же уровне привилегий, иногда называемый межсегментным переходом.

### Коментарии

Gas поддерживает 3 вида комментариев:

```
    # - single line comments
    // - single line comments
    /* */ - for multiline comments
```
