.include "constants.inc"

.segment "RODATA"
nametable:
.incbin "assets/nametable.nam"

.segment "CODE"
.export load_background
.proc load_background
	lda PPUSTATUS
	lda #$20
	sta PPUADDR
	lda #$00
	sta PPUADDR

	ldx #$00
	load_background1:
		lda nametable, x
		sta PPUDATA
		inx
		cpx #$00
		bne load_background1

	load_background2:
		lda nametable+$100, x
		sta PPUDATA
		inx
		cpx #$00
		bne load_background2

	load_background3:
		lda nametable+$200, x
		sta PPUDATA
		inx
		cpx #$00
		bne load_background3

	load_background4:
		lda nametable+$300, x
		sta PPUDATA
		inx
		cpx #$00
		bne load_background4
	rts
.endproc
