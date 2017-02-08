xspeedl = Ob.a				;low dla szybkości dodatkowej grunia
xspeedh = Ob.b				;hi dla szybkości dodatkowej grunia
xposl = Ob.c				;low dla pozycji grunia

obgracz:
 ldx tempx
 jsr graczmove

 lda onhscore
 beq @nothscore
 
 jmp nextobj

@nothscore:
 jsr plrcols
 jmp nextobj

;----
plrcols:
 lda p1button
 and #bmask
 beq @seea
 
 inc pigcolor
 
@seea:
 lda p1button
 and #amask
 beq @seest
 
 dec pigcolor
 
@seest
 lda p1button
 and #stmask
 beq @seed
 
 lda #1
 sta pauza
 
 ldxy pausebuff
 jsr putinbuff
 
@seed:
 lda gmpad
 and #dmask
 beq @end
 
 lda Ob.anim+1
 cmp #walkanim+1
 bne @end
 
 inc Ob.y+1
 
@end:
 lda pigcolor
 and #3
 sta pigcolor
 
 tax
 lda gruniocols,x
 sta gamepal+21
 
 rts
 
 
gruniocols:
 db $16,$11,$19,$10

pausebuff:
 db $21,$4C,pausebuff_end-3-pausebuff
 db "PAUZA"-54
pausebuff_end
 db 255
 
pauseoffbuff:
 db $21,$4C,pausebuff_end-3-pausebuff
 db 0,0,0,0,0
 db 255
;----
graczmove:
 lda Ob.id,x
 tay
 dey

@move
 lda gmpad,y
 and #rmask
 beq @lewo
 
 lda Ob.x,x
 cmp #$F0-8
 bcs @noinc
 
 lda xposl,x
 clc
 adc xspeedl,x
 sta xposl,x
 
 lda Ob.x,x
 adc #0
 clc
 adc xspeedh,x
 sta Ob.x,x
 
 jsr incgruniospd
 
 lda Ob.x,x
 cmp #$F0-4
 bcs @noinc
 
 lda #walkanim
 jsr startanim
 rts
 
@noinc
 lda #$F0-4
 sta Ob.x,x
 lda #walkanim
 jsr startanim
 rts
 
;-
@lewo
 lda Ob.id,x
 tay
 dey
 lda gmpad,y
 and #lmask
 beq @end

 lda Ob.x,x
 cmp #$4
 bcc @nodec

 lda xposl,x
 sec
 sbc xspeedl,x
 sta xposl,x
 
 lda Ob.x,x
 sbc #0
 sec
 sbc xspeedh,x
 sta Ob.x,x
 
 jsr incgruniospd
 lda Ob.x,x
 cmp #$4
 bcc @nodec
 
 lda #walkanim
 jsr startanimrev
 rts
 
@nodec: 
 lda #4
 sta Ob.x,x
 
 lda #walkanim
 jsr startanimrev
 rts
 
;-
@end
 lda #>gruniostartspd
 sta xspeedh					;szybkość poruszania się grunia
 lda #<gruniostartspd
 sta xspeedl					;szybkość poruszania się grunia
 
 ldx tempx
 lda #0
 jsr startanimneu
 rts
 
 
;-----
incgruniospd:
 lda xspeedh,x
 cmp #>gruniotopspd
 bne @ok
 
 lda xspeedl,x
 cmp #<gruniotopspd
 bne @ok
 bcc @ok
 
 rts
 
@ok
 lda xspeedl,x
 add #grunioacc
 sta xspeedl,x
 
 lda xspeedh,x
 adc #0
 sta xspeedh,x
 rts