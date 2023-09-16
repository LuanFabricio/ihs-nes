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
		ldx PPUSTATUS
		lda #$70
		sta $0200
		lda #$04
		sta $0201
		lda #$00
		sta $0202
		lda #$10
		sta $0203

		;; loading background
		;; setting up background
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
			lda nametable+256, x
			sta PPUDATA
			inx
			cpx #$00
			bne load_background2

		;; write background
		;; lda PPUSTATUS
		;; lda #$21
		;; sta PPUADDR
		;; lda #$2d
		;; sta PPUADDR
		;; lda #$01
		;; sta PPUDATA

		;; setting attribute table
		lda PPUSTATUS
		lda #$23
		sta PPUADDR
		lda #$d3
		sta PPUADDR
		ldx #%00000001
		stx PPUDATA
		stx PPUDATA
		stx PPUDATA


	.endproc

nametable:
.include "assets/nametable.asm"

palette:
	.byte $0f,$00,$10,$30
	.byte $0f,$01,$21,$31
	.byte $0f,$06,$16,$26
	.byte $0f,$09,$19,$29
