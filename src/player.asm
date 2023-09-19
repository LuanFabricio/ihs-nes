.include "constants.inc"

.segment "CODE"
.export move_player
.proc move_player
	lda $02
	cmp #$11
	beq setup_read
	inc $02
	jmp end

setup_read:
	lda #$01
	sta JOY1
	lda #$00
	sta JOY1

	;; Reading BTN A
	lda JOY1

	;; Reading BTN B
	lda JOY1

	;; Reading BTN Select
	lda JOY1

	;; Reading BTN Start
	lda JOY1

read_btn_up:
	;; Reading BTN Up
	lda JOY1
	and #$01
	beq read_btn_down
	jsr move_up
	jmp set_move_delay

read_btn_down:
	;; Reading BTN Down
	lda JOY1
	and #$01
	beq read_btn_left
	jsr move_down
	jmp set_move_delay

read_btn_left:
	;; Reading BTN Left
	lda JOY1
	and #$01
	beq read_btn_right
	jsr move_left
	jmp set_move_delay

read_btn_right:
	;; Reading BTN Right
	lda JOY1
	and #$01
	beq end
	jsr move_right

set_move_delay:
	lda #$00
	sta $02
change_turn:
	lda $00
	ora #$01
	sta $00
end:
	rts
.endproc

.proc move_up
	lda $0200
	cmp #$47
	bmi move_up_end
	beq move_up_end

	clc
	sbc #$07
	sta $0200

move_up_end:
	rts
.endproc

.proc move_down
	lda $0200
	cmp #$7f
	bpl move_down_end
	beq move_down_end

	clc
	adc #$08
	sta $0200

move_down_end:
	rts
.endproc

.proc move_left
	lda $0203
	cmp #$58
	bmi move_left_end
	beq move_left_end

	clc
	sbc #$07
	sta $0203

move_left_end:
	rts
.endproc

.proc move_right
	lda $0203
	cmp #$90
	bpl move_right_end
	beq move_right_end

	clc
	adc #$08
	sta $0203

move_right_end:
	rts
.endproc
