/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>



###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(handle0, T_DIVIDE)
TRAPHANDLER_NOEC(handle1, T_DEBUG)
TRAPHANDLER_NOEC(handle2, T_NMI)
TRAPHANDLER_NOEC(handle3, T_BRKPT)
TRAPHANDLER_NOEC(handle4, T_OFLOW)
TRAPHANDLER_NOEC(handle5, T_BOUND)
TRAPHANDLER_NOEC(handle6, T_ILLOP)
TRAPHANDLER(handle7, T_DEVICE)
TRAPHANDLER_NOEC(handle8, T_DBLFLT)
TRAPHANDLER(handle10, T_TSS)
TRAPHANDLER(handle11, T_SEGNP)
TRAPHANDLER(handle12, T_STACK)
TRAPHANDLER(handle13, T_GPFLT)
TRAPHANDLER(handle14, T_PGFLT)
TRAPHANDLER_NOEC(handle16, T_FPERR)
TRAPHANDLER_NOEC(handle48, T_SYSCALL)


/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	pushl %ds 
	pushl %es 
	pushal
	movw $GD_KD, %ax
	movw %ax, %ds 
	movw %ax, %es 
	pushl %esp
	call trap
