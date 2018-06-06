June LUG notes
==============

MIPS, nested procedures, and the beauty of tail calls
-----------------------------------------------------

### Basic MIPS instruction format

instruction <dst>, <operand 1>, <operand 2>

add $s1, $s2, $s3  # s1 = s2 + s3


### Instructions supporting Procedures

Load next instruction address into $ra and jump to <address>

	jal <address>  # Jump and Load

Return from procedure with an unconditional jump

	jr $ra

### Simple procedure

In C


	int sum(int x, int y)
	{
		return x + y;
    }

	result = sum(10, 11);


In MIPS assembler
	
		add   $s0, $zero, 10
		add   $s1, $zero, 11
		jal   sum

		# $v0 now holds result

	sum: 
		add   $v0, $s0, $s1
		jr $ra


### Recursive procedure

In C

	int fact(int n)
	{
		if (n < 1)
			return 1;
		else
			return (n * fact(n - 1));
	}

In MIPS assembler

	fact:
		addi  $sp, $sp, -8       # Add space on stack for two words.
		sw    $ra, 4($sp)        # Save return address.
		sw    $a0, 0($sp)        # Save argument.
	
		slti  $t0, $a0, 1        # Test for n < 1
		beq   $t0, $zero, L1     # if n >= 1 go to L1

		addi  $v0, $zero, 1      # return 1
		addi  $sp, $sp, 8        # pop 2 words off stack.
		jr    $ra

	L1: addi  $a0, $a0, -1       # n >= 1 so decrement argument.
		jal   fact

		# if fact was called with n > 1 then we return here
		lw    $a0, 0($sp)        # Restore argument.
		lw    $ra, 4($sp)        # Restor return address.
		addi  $sp, $sp, 8        # Pop 2 words off stack.
		mul   $v0, $a0, $v0      # Return n * fact(n - 1)
		jr    $ra


### Tail call

In C

	int fact(n)
	{
		return fact_acc(n, 1);
	}

	int fact_acc(int n, int acc)
	{
		if (n > 1) 
			return fact_acc(n-1, acc * n);
		else
			return acc;
	}

Now fact_acc() in MIPS

	fact_acc:
		slti $a0, 1              # Test if n <= 0
		beq  $a0, $zero, fa_exit # goto fa_exit if n <= 0
		add  $a1, $a1, $a0       # Add n to acc
		addi $a0, $a0, -1        # Subtract 1 from n
		j    fact_acc
	fa_exit:
		add  $v0, $a1, $zero      # Return acc
		jr   $ra


Note: no stack usage, only local jumps.


### MIPS registers

$s0-$s7  General registers, preserved across procedure calls.
$t0-$t7  General registers, not preserved across procedure calls.
$a0-$a3  Used for procedure arguments
$v0-$v1  Used for procedure return values
$zero    Always 0
$sp      Stack pointer
$gp      
$fp      Frame pointer
$ra      Return address
$at      Reserved for use by assembler