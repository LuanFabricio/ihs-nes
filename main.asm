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

	jsr check_player_win
	lda $00
	and #%10000000
	beq check_turn
	rti

check_turn:
	lda $00
	and #$01
	beq lbl_move_player
lbl_move_enemy:
	jsr move_enemy
	jmp nmi_end
lbl_move_player:
	jsr move_player

nmi_end:
	rti
.endproc

.import reset_handler

.export main
.proc main
	;; set game flags to zero
	lda #$00
	sta $00
	;; set enemy count to one
	lda #$01
	sta $01
	;; set player move delay to zero
	lda #$00
	sta $02

	;; loading palette
	ldx PPUSTATUS
	ldx #$3f
	stx PPUADDR
	ldx #$00
	stx PPUADDR

	load_palette:
		lda palette, x
		sta PPUDATA
		inx
		cpx #$20
		bne load_palette

	;; writing a sprite into ram
	ldx #$00
	load_sprites:
		lda sprites, x
		sta $0200, x
		inx
		cpx #$08
		bne load_sprites

	jsr load_background

vblankwait:
	bit PPUSTATUS
	BPL vblankwait

	lda #%10010000
	sta PPUCTRL
	lda #%00011110
	sta PPUMASK

forever:
	jmp forever
.endproc

.import load_background
.import move_player
.import move_enemy
.import check_player_win

.segment "RODATA"
palette:
	.byte $0f, $00, $10, $20
	.byte $0f, $01, $21, $31
	.byte $0f, $06, $16, $26
	.byte $0f, $09, $19, $29

	.byte $0f, $00, $10, $20
	.byte $0f, $01, $21, $31
	.byte $0f, $06, $16, $26
	.byte $0f, $09, $19, $29
;; .incbin "assets/palettes.pal"

sprites:
	.byte $6f, $01, %00000001, $88
	; .byte $5f, $03, %00000010, $88
	; .byte $67, $03, %00000010, $88
	.byte $5f, $01, %00000011, $88
