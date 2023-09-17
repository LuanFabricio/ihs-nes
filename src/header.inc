.segment "HEADER"
.byte $4e, $45, $53, $1a	; "NES" $1A
.byte 2				; 2x 16KB PRG code
.byte 1				; 1x 8KB CHR data
.byte $00			; Horizontal mirroring, no save ram, no mapper
.byte $00
.byte $00
.byte $00
