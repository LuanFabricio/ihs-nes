.include "constants.inc"

.segment "CODE"

.export move_enemy
.proc move_enemy
	lda $0204	;; enemy y
	cmp #$7f
	bpl reset_turn
	beq reset_turn

	clc
	adc #$08
	sta $204

reset_turn:
	lda $00
	and #%11111110
	sta $00

end:
	rts
.endproc
