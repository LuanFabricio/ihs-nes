.include "src/constants.inc"
.include "src/header.inc"

.segment "STARTUP"

.segment "CHARS"
.incbin "assets/graphics.chr"

.segment "VECTORS"
	.addr nmi_handler, reset_handler, irq_handler

.segment "CODE"
.proc irq_handler
	rti
.endproc

.proc nmi_handler
	;; copy memory from $0200-$02ff to OAM
	lda #$00
	sta OAMADDR
	lda #$02
	sta OAMDMA

	lda #$00
	sta PPUSCROLL
	sta PPUSCROLL

	rti
.endproc

.import reset_handler

.export main
.proc main
	;; loading palette
	ldx PPUSTATUS
	ldx #$3f
	stx PPUADDR
	ldx #$00
	stx PPUADDR

	ldx #$00
	load_palette:
		lda palette, x
		sta PPUDATA
		inx
		cpx #$10
		bne load_palette

	;; writing a sprite into ram
	lda PPUSTATUS
	lda #$6f
	sta $0200
	lda #$04
	sta $0201
	lda #$00
	sta $0202
	lda #$88
	sta $0203

	lda #$77
	sta $0204
	lda #$05
	sta $0205
	lda #$00
	sta $0206
	lda #$88
	sta $0207

	;; loading background
	;; setting up background
	lda PPUSTATUS
	lda #$21
	sta PPUADDR
	lda #$57
	sta PPUADDR
	ldx #$04
	stx PPUDATA

	lda PPUSTATUS
	lda #$20
	sta PPUADDR
	lda #$57
	sta PPUADDR
	ldx #$04
	stx PPUDATA

	lda PPUSTATUS
	lda #$20
	sta PPUADDR
	lda #$00
	sta PPUADDR
	ldx #$02
	stx PPUDATA

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
vblankwait:
	bit PPUSTATUS
	BPL vblankwait

	lda #%10000000
	sta PPUCTRL
	lda #%00011110
	sta PPUMASK

forever:
	jmp forever
.endproc

.segment "RODATA"
nametable:
.incbin "assets/nametable.nam"

palette:
.incbin "assets/palettes.pal"
