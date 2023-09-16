.include "constants.inc"

.segment "CODE"
.import main
.export reset_handler

.proc reset_handler
	sei
	cld
	ldx #$00
	stx PPUCTRL
	stx PPUMASK
vblank_wait:
	bit PPUSTATUS
	bpl vblank_wait

	lda #%10000000
	sta PPUCTRL
	lda #%00011110
	sta PPUMASK
clear_memory:
	lda #$00
	sta $0000, x
	sta $0100, x
	sta $0200, x
	sta $0300, x
	sta $0400, x
	sta $0500, x
	sta $0600, x
	sta $0700, x
	inx
	bne clear_memory
	jmp main
.endproc
