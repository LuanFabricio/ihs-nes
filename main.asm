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
	inc $ff
	lda $ff
	cmp #$10
	bpl draw_hud

draw_pieces:
	;; copy memory from $0200-$02ff to OAM
	lda #$00
	sta OAMADDR
	lda #$02
	sta OAMDMA
	lda #$ff
	jmp draw_end

draw_hud:
;;	;; copy memory from $0300-$03ff to OAM
;;	lda #$00
;;	sta OAMADDR
;;	lda #$03
;;	sta OAMDMA

draw_end:
lock_scroll:
	lda #$00
	sta PPUSCROLL
	sta PPUSCROLL

;;	jsr check_player_win
;;	lda $00
;;	and #%10000000
;;	beq check_turn
;;	rti

;; check_turn:
;; 	lda $00
;; 	and #$01
;; 	beq lbl_move_player
;; lbl_move_enemy:
;; 	; jsr move_enemy
;; 	jmp nmi_end
;; lbl_move_player:
;; 	jsr move_player

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
	;; set player 1 move delay to zero
	lda #$00
	sta $02
	;; set player 2 move delay to zero
	lda #$00
	sta $03

	;; loading marker sprite
	lda #$4f
	sta $0300
	lda #$11
	sta $0301
	lda #$00
	sta $0302
	lda #$55
	sta $0303

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
		cpx #$80
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
	.byte $0f, $2d, $10, $20
	.byte $0f, $06, $16, $26
	.byte $0f, $10, $2d, $20
;; .incbin "assets/palettes.pal"

sprites:
	;; grey pieces
	.byte $47, $04, %00000001, $58
	.byte $47, $03, %00000001, $60
	.byte $47, $02, %00000001, $68
	.byte $47, $05, %00000001, $70
	.byte $47, $06, %00000001, $78
	.byte $47, $02, %00000001, $80
	.byte $47, $03, %00000001, $88
	.byte $47, $04, %00000001, $90
	;; grey pawns
	.byte $4f, $01, %00000001, $58
	.byte $4f, $01, %00000001, $60
	.byte $4f, $01, %00000001, $68
	.byte $4f, $01, %00000001, $70
	.byte $4f, $01, %00000001, $78
	.byte $4f, $01, %00000001, $80
	.byte $4f, $01, %00000001, $88
	.byte $4f, $01, %00000001, $90

	;; white pieces
	.byte $7f, $04, %00000011, $58
	.byte $7f, $03, %00000011, $60
	.byte $7f, $02, %00000011, $68
	.byte $7f, $05, %00000011, $70
	.byte $7f, $06, %00000011, $78
	.byte $7f, $02, %00000011, $80
	.byte $7f, $03, %00000011, $88
	.byte $7f, $04, %00000011, $90
	;; white pawns
	.byte $77, $01, %00000011, $58
	.byte $77, $01, %00000011, $60
	.byte $77, $01, %00000011, $68
	.byte $77, $01, %00000011, $70
	.byte $77, $01, %00000011, $78
	.byte $77, $01, %00000011, $80
	.byte $77, $01, %00000011, $88
	.byte $77, $01, %00000011, $90
