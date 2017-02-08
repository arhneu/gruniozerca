chkifnewhscore:
 ldx #8
@seehscoregm:
 dex
 cpx #0
 bne @newhscore
 
@nonewhscore
 rts
 
@newhscore: 
 lda score,x
 cmp hscore,x
 beq @seehscoregm
 bcc @nonewhscore
 
 ldx #0
@copynewhscore:
 lda score,x
 sta hscore,x
 
 inx
 cpx #8
 bne @copynewhscore
 
 jsr clearspr
  
 jsr clearnt
 
 jsr turnninon
 ldxy gruniorekordbuff
 jsr putinbuff
 
 jsr waitframe
 
 ldxy gruniorekordbuff2
 jsr putinbuff
 jsr waitframe
 
 ldxy rekordgrat
 jsr putinbuff
 jsr waitframe
 
 ldxy rekordnowy
 jsr putinbuff
 jsr waitframe
 
 ldxy rekordatt
 jsr putinbuff
 jsr waitframe
 
 lda #$20
 sta gamepal+3
 
 lda #$A0
 sta scrolly
 
 lda #4
 jsr startmus
@scroll 
 jsr waitframe
 inc scrolly
 inc scrolly
 lda scrolly
 cmp #$e0
 bne @scroll
 
 ldx #$10
 jsr waitframes
 lda #$02
 sta gamepal+5
 lda #$0
 sta gamepal+6
 sta gamepal+7
 
 ldx #$10
 jsr waitframes
 lda #$12
 sta gamepal+5
 lda #$10
 sta gamepal+6
 sta gamepal+7
 
 ldx #$10
 jsr waitframes
 lda #$20
 sta gamepal+6
 
 ldxy rekordbuff
 jsr putinbuff
 
 jsr waitframe
 
  lda #$21
  sta buffer
  lda #$D0
  sta buffer+1

  lda #8
  sta buffer+2
  
  ldx #7
  ldy #0
@endhscore
  lda hscore,x
  sub #15
  sta buffer+3,y
  iny
  dex
  cpx #-1
  bne @endhscore

  lda #0
  sta buffer+11
  
 ldx #$40
 jsr waitframes
 
 lda #1
 sta Ob.id
 sta onhscore
 
 lda #$B1
 sta Ob.y
 
 lda #0
 sta Ob.x
 sta Ob.id+1
 
 lda #$36
 sta gamepal+11+16
 
 lda #$20
 sta gamepal+1+16
 sta gamepal+9+16
 lda #$26
 sta gamepal+3+16
 sta gamepal+10+16
 lda #$16
 sta gamepal+5+16
 lda #8
 sta gamepal+6+16
 
@inf2
 jsr waitframe
 jsr clearspr
 lda #rmask
 sta gmpad
 
 lda Ob.x,x
 cmp #$80-16
 bcc @notmid
 
 lda #mlem
 ldx #$90-8-16
 ldy #$90+4
 jsr putsprite
 jsr objplay
 
 lda #0
 sta global
 jmp @atmid
 
@notmid
 jsr objplay
 jmp @inf2
 
@atmid:
 jsr waitframe
 jsr KEYPAD
 
 lda global
 beq @dofade
 
 lda p1button
 and #amask+bmask+selmask+stmask
 beq @atmid
 
@dofade
 lda #4
 jsr fadeout
 jmp reset

gruniorekordbuff:
 db $21,$29,gruniorekordbuff_end-3-gruniorekordbuff
 db $5A,$5C,$5E,$60,$62,$6D,$5c,$67,$a5,$6d,$5c,$a6,$a9,$a9
gruniorekordbuff_end:
 db 255
 
gruniorekordbuff2
 db $21,$49,gruniorekordbuff2_end-3-gruniorekordbuff2
 db $5b,$5d,$5f,$61,$63,$6e,$5d,$68,$a7,$6e,$5d,$a8,$aa,$aa
gruniorekordbuff2_end
 db 255 
 
rekordnowy:
 db $20,$CD,rekordnowy2-3-rekordnowy
 db $60,$6D,$AB,$AC,$AD
rekordnowy2:
 db $20,$ED,rekordnowy_end-3-rekordnowy2
 db $61,$6e,$ae,$af,$B0
rekordnowy_end
 db 255
 
rekordatt:
 db $23,$CB,2
 db $50,$50
 db $23,$D2,4
 db $55,$55,$55,$55
 ;db $23,$DA,3
 ;db $55,$55,$55
 db 255
 
rekordgrat:
 db $20,$8A,rekordgrat_end-3-rekordgrat
 db "GRATULACJE"-54,$25
rekordgrat_end
 db 255
 
rekordbuff:
 db $21,$C6,rekordbuff_end-3-rekordbuff
 db "HI"-54,$6F,"SCORE"-54,$2C
rekordbuff_end
 db 255
