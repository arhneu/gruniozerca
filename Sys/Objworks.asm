;------------
objplay:
 ldx #-1
 stx tempx

nextobj:
 inc tempx
 
 ldx tempx 
 cpx #maxobj
 beq @end
 
 lda Ob.id,x
 beq nextobj				;pusty obiekt

 jsr objanim
  
 lda Ob.id,x
 tax
 lda objtbll,x
 sta addr
 lda objtblh,x
 sta addr+1
 jmp (addr)
 
@end:
 rts

 
;----------
startanimobj
 
 
startanimrev
 pha
 
 lda Ob.frma,x
 ora #$40
 sta Ob.frma,x

 jmp startanimcont
startanim:
 pha

 lda #0
 sta Ob.frma,x
 
startanimcont:
 pla
startanimneu:				;nautralnie odnoœnie kierunku animacji
 cmp Ob.anim,x
 beq @end

 sta Ob.anim,x
 
 lda #0
 sta Ob.frm,x
 
 lda #0
 sta Ob.frm2,x				;czyli w nastêpnym objanim, na³o¿y prawid³owe dane.
 
@end:
 rts
 
;----------
objanim:
 lda Ob.anim,x
 tay

 lda animtbll,y
 sta addr
 lda animtblh,y
 sta addr+1
 
 ldy #0

 dec Ob.frm2,x
 bpl @end						;nie trzeba robiæ nastêpnej klatki
 
 inc Ob.frm,x					;zwiêksz klatkê animacji
 
 lda (addr),y
 sta Ob.frm2,x					;init czasu miêdzy klatkami
 
 iny
 
 tya
 clc
 adc Ob.frm,x					;dodaj numer klatki obecnej...
 tay
 
 lda (addr),y					;sprawdŸ kolejn¹ klatkê
 cmp #255
 bne @end

 lda #0
 sta Ob.frm,x					;init animacji 

@end:
 lda Ob.frm,x
 tay
 iny
 lda (addr),y
 pha
 lda Ob.y,x
 tay

 lda Ob.frma,x
 beq @normal
 
 sta mts
 
 lda Ob.x,x
 tax

 pla
 jsr putspriterev
 jmp @cont
 
@normal
 lda Ob.x,x
 tax
 pla
 jsr putsprite
 
@cont
 ldx tempx
 
 rts


animtbll:
 db <anim.plridle
 
walkanim = ($-animtbll)
 dl anim.gruniowalk
 dl anim.gold
pktanim = ($-animtbll)
 dl anim.pkt10
 dl anim.pkt50
 dl anim.pkt100
 dl anim.pkt200
 dl anim.pkt500
 dl anim.pkt1000
 dl anim.pkt2000
 dl anim.pkt5000
 
explanim = ($-animtbll)
 dl anim.expl
 
animtblh:		
 db >anim.plridle 
 dh anim.gruniowalk
 dh anim.gold
 dh anim.pkt10
 dh anim.pkt50
 dh anim.pkt100
 dh anim.pkt200
 dh anim.pkt500
 dh anim.pkt1000
 dh anim.pkt2000
 dh anim.pkt5000
 dh anim.expl
 
anim.expl
 db 2
 db explspr,explspr+1,explspr+2,explspr+3,explspr+4,explspr+5
 db 0
 db 255
 
anim.pkt10
 db 1
 db pktspr
 db 255
anim.pkt50
 db 1
 db pktspr+1
 db 255
anim.pkt100
 db 1
 db pktspr+2
 db 255
anim.pkt200
 db 1
 db pktspr+3
 db 255
anim.pkt500
 db 1
 db pktspr+4
 db 255
anim.pkt1000
 db 1
 db pktspr+5
 db 255
anim.pkt2000
 db 1
 db pktspr+6
 db 255
anim.pkt5000
 db 1
 db pktspr+7
 db 255
 
anim.gold
 db 1
 db goldspr
 db 255
 
anim.gruniowalk
 db 4
 db gruniowalkspr,gruniowalkspr-1,gruniowalkspr+1,gruniowalkspr-1
 db 255
 
anim.plridle:
 db 10							;szybkoœæ animacji
 db grunioidlespr					;klatki animacji
 db 255							;koniec animacji

 include "Sys\Obj\mapobjlist.asm"