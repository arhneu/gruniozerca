goldspdl = Ob.a
goldspdh = Ob.b					;obecna, 16 bitowa szybkość spadania
goldyl = Ob.c					;obecne low dla pozycji y
goldwait = Ob.d
goldcol = Ob.e

obgold:
 ldx tempx
 lda goldwait,x
 beq @nowait
 jmp @wait
 
@nowait
 lda #2
 jsr startanim

 ldx tempx
 lda goldspdl,x
 clc
 adc goldyl,x
 sta goldyl,x
 
 lda goldspdh,x
 adc #0
 clc
 adc Ob.y,x
 sta Ob.y,x
 
 cmp #$B7
 bcs @cont
 
 lda #10
 ldy #16
 jsr collplr		;kolizje z graczem
 bcc @1

 ldx tempx
 lda pigcolor
 cmp goldcol,x
 bne @1
;---
 lda goldspdh,x
 cmp #>goldtopspd
 bcc @ok
 
 lda goldspdl,x
 cmp #<goldtopspd
 bcs @notok
 
@ok
 lda goldspdl,x
 add #<goldacc
 sta goldspdl,x
 
 lda goldspdh,x
 adc #0
 add #>goldacc 
 sta goldspdh,x
;---- 
@notok
 ldx combo
 cpx #8
 bne @combook
 
 lda #7
 sta combo
 tax
 
@combook
 lda scoringcombo,x
 jsr addscore

 lda #1
 ldx #0
 jsr FamiToneSq1Play
 
 ldx tempx
 lda #$20
 sta goldwait,x
 
 lda #pktanim
 add combo
 jsr startanimneu
 
 inc combo
@1
 jmp nextobj
 
@cont:
 lda #0
 ldx #0
 jsr FamiToneSfxPlay
 
 ldx tempx
 lda #0
 sta combo
 
 lda #16
 sta goldwait,x
 
 lda #explanim
 jsr startanimneu
 
 dec life
 jmp nextobj
 
;---
@wait:
 dec goldwait,x
 
 lda goldwait,x
 bne @end
 
 lda #0
 sta Ob.y,x
 
; lda #2
; jsr startanim
 
 lda global
 and #3
 sta goldcol,x
 tay
 lda gruniocols,y
 sta gamepal+26
 
 sub #$10
 sta gamepal+25
 
 
 lda global
 cmp #$F0
 bcs @end
 sta Ob.x,x
 jsr @shake
 jmp @nowait
 
@end
 jsr @shake
 
@notexp
 jmp nextobj
 
@shake:
 lda scrolly
 eor #2
 sta scrolly
 
 lda Ob.y
 eor #2
 sta Ob.y
 
 lda Ob.y,x
 eor #2
 sta Ob.y,x
 
 inc Ob.frma,x
 lda Ob.frma,x
 and #$43
 sta Ob.frma,x
 rts
 
scoringcombo:
 db $11,$15,$21,$22,$25,$31,$32,$35
