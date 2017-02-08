;00000001-Prawo
;00000010-Lewo
;00000100-Dó³
;00001000-Góra
;00010000-Start
;00100000-Select
;01000000-B
;10000000-A
KEYPAD:
 lda gmpad
 sta debounce
 lda gmpad+1
 sta debounce+1
 
 ldx #$00
 stx gmpad
 stx gmpad+1
 
Keypad.Test:
 jsr KEYPAD.CHK 
 lda gmpad
 PHA

 jsr KEYPAD.CHK
 PLA
 cmp gmpad
 bne Keypad.Test

 lda gmpad
 EOR debounce
 and gmpad
 sta p1button

 lda gmpad+1
 EOR debounce+1
 and gmpad+1
 sta p1button+1
 rts



;------
KEYPAD.CHK:
 inx
 stx $4016

 dex
 stx $4016

 ldx #$08
Keypad.Loop:
 lda $4016
 lsr a
 rol gmpad
 lsr a

 dex
 bne Keypad.Loop

 ldx #$08
Keypad.Loop2:
 lda $4017
 lsr a
 rol gmpad+1
 lsr a

 dex
 bne Keypad.Loop2
 rts
