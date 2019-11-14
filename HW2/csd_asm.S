#define csd_LED_ADDR	0x41200000

.extern csd_main

.align 8

// Our interrupt vector table
csd_entry:
	b csd_reset
	b .
	b .
	b .
	b .
	b .
	b csd_irq
	b .

.global main
csd_reset:
main:
	mov r10, #0
	ldr r0, =Input_data
	ldr r1, =Output_data

loop:						//copy data form Input_data to Output_data address
	ldmia r0!, {r2-r9}
	stmia r1!, {r2-r9}
	add r10, r10, #1
	cmp r10, #4
	bne loop

init_sort:					//sorting initialization
	ldr r1, =Output_data	//address for the outer loop of select sort
	mov r2, r1				//address for the inner loop of select sort
	mov r5, r1				//r5 is backup of starting address
	add r2, r2, #124		//r2 initialize : address of the end of Output_data

select_sort:				//selection sort - select the biggest value and move it to the end of Output_data
	cmp r5, r2				//compare r5(end address) and r2(current address)
	beq end_sort			//if current address is bigger than end address, end sorting
	mov r1, r5				//initialize r1(current address)
	ldr r3, [r1]			//get value from [r1]
	mov r6, r3				//r6 has the Max value
	mov r7, r1				//r7 has the address of Max value
	add r1, r1, #4			//move current location

sort_loop:					//loop in sorting
	ldr r3, [r1]			//value from [r1]
	cmp r3, r6				//compare with current Max value
	bge update_max			//if r3 is bigger, update Max value
	add r1, r1, #4
	cmp r2, r1				//if current address reaches to r2, exchange
	bge sort_loop			//value between [r1] and [r2]
	b exchange

update_max:					//if the max value is smaller than [r1], update max value and its address
	mov r6, r3
	mov r7, r1
	add r1, r1, #4
	cmp r2, r1				//if current address reaches to r2, exchange
	bge sort_loop			//value between [r1] and [r2]
	b exchange

exchange:					//exchange max value and [r2]
	ldr r10, [r2]			//r10 saves max value temporarily for exchange
	str r10, [r7]			//r7 has address of max value
	str r6, [r2]
	sub r2, r2, #4			//update r2 by decreasing, because max value from previos data goes
	b select_sort			//to the end of Output_data, in sequence

end_sort:
	bl csd_main

forever:
	nop
	b forever


.data
.align 4
Input_data:	.word 2,0,-7,-1,3,8,-4,10
			.word -9,-16,15,13,1,4,-3,14
			.word -8,-10,-15,6,-13,-5,9,12
			.word -11,-14,-6,11,5,7,-2,-12

Output_data: .word 0,0,0,0,0,0,0,0
			 .word 0,0,0,0,0,0,0,0
			 .word 0,0,0,0,0,0,0,0
			 .word 0,0,0,0,0,0,0,0

dst:
	.space 16  // allocate memory for 16 words


// Normal Interrupt Service Routine
csd_irq:
	b .
