.include "constants.inc"

.segment "CODE"
.export move_player
.proc move_player
read_input:
	lda $0000
	cmp #$0f
	bmi setup_read
reset_and_end:
	dec $0000
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

	;; Reading BTN Up
	lda JOY1
	and #$01
	beq read_btn_down
	jsr move_up

	;; Reading BTN Down
read_btn_down:
	lda JOY1
	and #$01
	beq read_btn_left
	jsr move_down

read_btn_left:
	;; Reading BTN Left
	lda JOY1
	and #$01
	beq read_btn_right
	jsr move_left

read_btn_right:
	;; Reading BTN Right
	lda JOY1
	and #$01
	beq end
	jsr move_right

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

	ldx #$ff
	sta $0000

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

	ldx #$ff
	sta $0000

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

	ldx #$ff
	sta $0000

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

	ldx #$ff
	sta $0000

move_right_end:
	rts
.endproc
