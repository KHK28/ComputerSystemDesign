int csd_main()										//function for calculating time count
{
	unsigned char *SWITCH = (char *)0x41210000;		//pointer for switch mapped in memory
	int i, a;										//variables used in calculating
	unsigned int *retVal = (int *)0x00101c5c;		//pointer which has address for storing counter value

	//calculating count value
	//find appropriate value by shift
	//shift until it finds 1 in binary, and calculate count value by amount of shift operation
	//after calculating, store count value in 0x00101c5c, by retVal variable
	for(i=0;i<8;i++)
	{
		a = 7 - i;
		if (((*SWITCH>>a) % 2) == 1)
		{
			*retVal = (800 - (a * 100)) * 335000;	//335000 is found by several experiments
			return 0;								//return after calculating count value
		}
	}

	//if nothing can be found in switches, store 335000000 (about 1 second) in 0x00101c5c
	*retVal = 335000 * 1000;
	return 0;
}
