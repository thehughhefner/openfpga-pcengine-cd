GROUP("libgcc.a")

MEMORY {
  RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 0x00008000
  SRAM (rw) : ORIGIN  = 0x00008000, LENGTH = 0x00008000
}

SECTIONS
{
	/* first section is .text which is used for code */
	.text :
	{
    *(.boot)
    KEEP(*(.boot))

		*(.text .text.*)           /* remaining code */
		*(.rodata)                 /* read-only data (constants) */
		*(.rodata*)
		*(.rdata*)
		. = ALIGN(4);
	} > RAM

	/* .data section which is used for initialized data */
	.data :
	{
    *(.got.plt) *(.got)
    *(.shdata)
    *(.data .data.* .gnu.linkonce.d.*)
    . = ALIGN(16);
    *(.lit8)
    *(.lit4)
    *(.sdata .sdata.* .gnu.linkonce.s.*)
    . = ALIGN (8);
    *(.ram)
    . = ALIGN (8);
    _edata = .;
	} > RAM

  .bss :
  {
	. = ALIGN(4);
    _bss_start = . ;

    *(.bss*)
    *(.sbss*)
    *(COMMON)
    /* Allocate room for stack */
    .   =  ALIGN(8) ;
    .   += 3072 ;
    _sp =  . - 16;
  } > RAM

  . = ALIGN(4);
  _end = . ;

  .payload :
  {
    *(.payload)
  }

  .SRAM : {
   __ram_start = .;
   *(SRAM*)
   __ram_end = .;
   } > SRAM

}
