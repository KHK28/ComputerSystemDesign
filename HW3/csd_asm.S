#define csd_LED_ADDR	0x41200000
#define COUNT			0x00101c5c

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
	mov r6, #1				//initialize r6 : r6 has value to store in GPIO, LEDs
	ldr r7, =csd_LED_ADDR	//r7 has address of LEDs
	mov r11, #256			//r11 will be compared with r6, and if r6 = r11, r6 will be reinitialized to 1
loop:
	bl csd_main				//call csd_main to get count value
	ldr r3, =COUNT			//r3 has address in which count value is stored
	ldr r4, [r3]			//load count value in r4
	mov r5, #0				//initialize r5, which is used in count_loop to make delay
count_loop:
	cmp r4, r5				//if r4 = r5, which means delay time is over, branch to update LEDs
	beq update_led
	add r5, r5, #1			//increase r5
	b count_loop			//loop until delay time is over
update_led:
	cmp r6, r11				//if r6 = 256, init r6 to 1
	beq init_led
	strb r6, [r7]			//store count value in r6 to LEDs
	movs r10, r6, lsl #1	//shift r6 to turn on another led
	movs r6, r10
	b loop					//infinite loop
init_led:
	mov r6, #1				//initialize r6 to 1
	b update_led			//go back to update_led

.data
.align 4

// Normal Interrupt Service Routine
csd_irq:
	b .
