.include "constants.inc"

.segment "CODE"
.export check_player_win
.proc check_player_win
check_enemy_count:
	;; enemy count is equal to zero
	lda $01
	cmp #$00
	bne end
	jmp set_win_flag

set_win_flag:
	lda $00
	ora #%10000000
	sta $00
	jmp end

end:
	rts
.endproc
