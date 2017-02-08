waitframe:
 lda global
@1
 cmp global
 beq @1
 rts
 
;---------
waitframes:
 jsr waitframe
 dex
 bpl waitframes
 rts
;---------
turnninon:
 lda #%10000000
 sta ppu0
 lda #%00011110
 sta ppu1
 
 inc nmion
 
 lda $2002
 lda #$80
 sta control0
 jsr waitframe
 rts
;---------
turnninoff:
 lda #0
 sta control1
 sta ppu1
 sta nmion
 
 lda #$80
 sta control0
 sta ppu0
 
 jsr waitframe
 rts
;---------
clearnt:
 lda #$20
clearntx:
 sta PPUADDR
 lda #0
 sta PPUADDR
 
 tay
 tax
 
@lp
 sta PPUDATA
 inx
 cpx #0
 bne @lp
 
 iny
 cpy #4
 bne @lp
 
 rts
 
;---------
clearspr:
 lda #$F8
 ldx #0
 stx spriteblockpointer
@1
 sta spriteblock,x
 inx 
 inx
 inx
 inx
 bne @1
 rts
 
;---------
wait:
 dex
 cpx #0
 bne wait
 rts
;---------
startmus:
 asl
 tax
 lda mustbl,x
 sta $F1
 lda mustbl+1,x
 sta $F2
 
 lda #0
 tax
 jsr $C000
 
 rts
 
mustbl:
 dw titlemus,ingamemus,gameovermus,emptymus,ropejmp
 
;---------
addscore
 pha
 lsr
 lsr
 lsr
 lsr
 tay
 pla
 and #$F
@1
 clc
 adc score,y
 sta score,y
 cmp #$1A
 bcc @end
 sec
 sbc #$A
 sta score,y
 
 lda #1
 iny
 cpy #8
 bne @1
 
@end
 lda #$20
 sta buffer
 lda #$41
 sta buffer+1
 lda #$7
 sta buffer+2
 
 ldx #7
 ldy #0
@lp
 lda score,x
 sub #$F
 sta buffer+3,y
 iny
 dex
 bpl @lp
 
 lda #0
 sta buffer+10
 
 rts
;---------
putinbuff:
 sty addr
 stx addr+1
 
 ldx buffptr
 ldy #0
 
--
 clc
 
 lda (addr),y
 bpl +
 cmp #255
 beq +++
 
 sec

+
 sta buffer,x
 
 inx
 iny
 lda (addr),y
 sta buffer,x
 
 inx
 iny
 lda (addr),y
 sta buffer,x
 sta temp			;zapisz długość buffera
 
 bcc ++				;carry clear-nie ma kompresji

 inx
 iny
 lda (addr),y
 sta buffer,x
 inx
 iny
 jmp --

 
++
 inx
 iny
-
 lda (addr),y
 sta buffer,x
 
 inx
 iny
 dec temp 
 lda temp
 bne -
 
 lda (addr),y
 cmp #$FF
 bne --
 
+++
 lda #0
 sta buffer,x		;0 zamiast ppu znaczy koniec buffera

 stx buffptr
 rts
 
;---------
fadein:
 tay
 sta fadecnt
 
 lda #0
 sta fadestat
@lp
 jsr waitframe
 dey
 bpl @lp
 
 ldy fadecnt
 
 lda fadestat
 cmp #4
 beq @end
 asl
 asl
 asl
 asl
 sta temp
 
 ldx #0
@lp2
 lda palcopy,x
 and #$F
 add temp
 cmp palcopy,x
 beq @ok
 bcc @ok
 
 jmp @nope
 
@ok
 sta gamepal,x
@nope
 inx
 cpx #32
 bne @lp2
 inc fadestat
 
 jmp @lp
 
@end
 rts
 

;----------
fadeout:
 tay
 sta fadecnt
 
 lda #0
 sta fadestat
 
@lp
 jsr waitframe
 dey
 bpl @lp
 
 ldy fadecnt
 
 ldx #32
@lp2 
 lda gamepal,x
 sub #$10
 bpl @notminus
 
 lda #15
 
@notminus:
 sta gamepal,x
 
 dex
 bpl @lp2
 
 inc fadestat
 lda fadestat
 cmp #4
 bne @lp
 
 rts
;----------
blackpal:
 lda #15
 ldx #32
@lp
 sta gamepal,x
 dex
 bpl @lp
 
 rts
;----------
loadmappal:						;A-ID PALETY
 tax
 lda mappaltbll,x
 sta addr
 lda mappaltblh,x
 sta addr+1
 
 ldy #0
 ldx #0
@1
 lda (addr),y
 sta gamepal,x
 sta palcopy,x
 iny
 inx
 cpy #32
 bne @1

 rts

mappaltbll
 dl titlepal
 dl mainpal
mappaltblh
 dh titlepal
 dh mainpal
 
titlepal:
 db 15
 db 1,$11,$20
 db 15
 db 15,15,15
 db 15
 db 15,15,15
 db 15
 db 15,15,15
 
 db 15
 db 8,$17,$27
 db 15
 db $16,15,15
 db 15
 db 0,$10,$20
 db 15
 db 15,15,15
 
mainpal:
 db 15
 db 7,$17,$27
 db 15
 db 0,$10,$20
 db 15
 db 6,$16,$26
 db 15
 db 9,$19,$29
 
 db 15
 db $20,$0f,$26
 db 15
 db $16,8,15
 db 15
 db $06,$16,$19
 db 15
 db $16,$26,15
;---------
uplnt:
 tax
 
 lda nttbll,x
 sta addr
 lda nttblh,x
 sta addr+1
 
 lda #$20
 sta PPUADDR
 lda #0
 sta PPUADDR
 
 tax
 tay
@lp
 lda (addr),y
 sta PPUDATA
 iny
 cpy #0
 bne @lp
 
 inc addr+1
 
 inx
 cpx #4
 bne @lp
 
 rts
 
;-----
collplr:
 sta temp
 tya
 sta temp2

 ldy #0
 
 lda Ob.x,y
 clc
 adc #18
 cmp Ob.x,x
 bcc @end

 lda Ob.x,x
 add temp
 cmp Ob.x,y
 bcc @end
 
 lda Ob.y,y
 clc
 adc #8
 cmp Ob.y,x
 bcc @end

 lda Ob.y,x
 add temp2
 cmp Ob.y,y
 bcc @end
 
 sec
 rts
 
@end:
 clc
 rts