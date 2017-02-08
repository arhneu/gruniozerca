intotitle:
 jsr turnninoff
 
 if isunrom = 1
 lda #<grafikaunrom
 sta addr
 lda #>grafikaunrom
 sta addr+1
 
 lda #$0
 sta PPUADDR
 sta PPUADDR
 
 ldy #0
 ldx #0
@unromlp
 lda (addr),y
 sta PPUDATA
 
 incr addr
 
 lda addr
 cmp #<grafikaunrom_end
 bne @unromlp
 
 lda addr+1
 cmp #>grafikaunrom_end
 bne @unromlp
 
 endif
 
 
 jsr clearspr
  
 lda #15
 sta gamepal+16
 
 lda #0
 sta tempx
 sta tempe
 sta tempd
 
 jsr uplnt

 lda #$B0+8
 sta scrollcon
 sta scrollx
 lda #0
 sta scrollcon
 sta scrolly
 jsr blackpal
 
 jsr turnninon

 lda #0
 jsr loadmappal

 ;lda #10
 ;jsr fadein

 ldx #<sounds
 ldy #>sounds
 jsr FamiToneSfxInit
 
;---------
 lda #0
 sta tempx
 
@struslp
 jsr waitframe
 jsr clearspr
 dec scrollx
 
 lda scrollx
 cmp #$38
 bcs @struslp
 
 lda global
 and #7
 tax
 lda strusanim,x
 ldx tempx
 ldy #$18
 jsr putsprite
 inc tempx
 
 lda scrollx
 beq @strusucieka
 jmp @struslp
 
@strusucieka:
 jsr waitframe
 jsr clearspr
 lda #$40
 sta mts
 lda global
 and #7
 tax
 lda strusanim,x
 ldx tempx
 ldy #$18
 jsr putspriterev
 dec tempx
 lda tempx
 bne @strusucieka
 
 jsr clearspr
;---------
 jsr waitframe
  
@fadetit
 ldx #10
 jsr waitframes
 lda #6
 sta gamepal+5
 lda #$0
 sta gamepal+6
 sta gamepal+7
 
 ldx #8
 jsr waitframes
 lda #$16
 sta gamepal+5
 lda #$10
 sta gamepal+6
 sta gamepal+7
  
 ldx #8
 jsr waitframes
 lda #$20
 sta gamepal+6
 
 lda #0
 jsr startmus
 
 lda #$FF
 sta $1f
 
 ldxy limitedbuff
 jsr putinbuff

 jsr waitframe
 
 ldxy edycjalimitowana
 jsr putinbuff
 
 jsr waitframe
 
 ldxy highscorebuff
 jsr putinbuff
 
  jsr waitframe

  lda #$23
  sta buffer
  lda #$50
  sta buffer+1

  lda #8
  sta buffer+2
  
  ldx #7
  ldy #0
@titlehscore
  lda hscore,x
  sub #15
  sta buffer+3,y
  iny
  dex
  cpx #-1
  bne @titlehscore

  lda #0
  sta buffer+11
 
inf
 jsr waitframe
 jsr clearspr
 jsr KEYPAD

 lda p1button
 and #stmask
 beq @blink

 lda #3
 ldx #0
 jsr FamiToneSq1Play
 
 lda #3
 jsr startmus
 
 lda #8
 jsr fadeout
 jsr turnninoff
 rts 
 
@blink
 inc tempx
 lda tempx
 cmp #$10
 bne inf
 
 lda #0
 sta tempx
 
 inc tempd
 lda tempd
 cmp #16*3
 bne @notcreds
 
 jmp creditsstart
@notcreds
 lda tempe
 eor #1
 sta tempe
 beq @show
 
 ldxy emptyline
 bne @draw
 
@show
 ldxy pressst
 
@draw:
 jsr putinbuff
 
 jmp inf
 
pressst:
 db $21,$CA,pressst_end-3-pressst
 db "PRESS"-54,0,"START"-54
pressst_end
 db 255
 
edycjalimitowana:
 db $22,$44,edycjalimitowana_end-3-edycjalimitowana
 db "EDYCJA"-54,0,"ULTRA"-54,0,"LIMITOWANA"-54
edycjalimitowana_end
 db 255
 
limitedbuff
 db $22,$A6,pressst_end3-3-limitedbuff
 db "DOBRE"-54,0,"SERCE"-54,0,"OKAZALI"-54,$2C
pressst_end3
 db $22,$E6,pressst_end4-3-pressst_end3
 db "ARCHON"-54,$A4,0,"GREM"-54,0,"I"-54,0,"QZAK"-54
pressst_end4
 db 255
 
highscorebuff:
 db $23,$46,highscorebuff_end-3-highscorebuff
 db "HI"-54,$6F,"SCORE"-54,$2C
highscorebuff_end
 db 255
 
emptyline:
 db $21,$CA,11
 db 0,0,0,0,0,0,0,0,0,0,0
 db 255
 
emunesbuff
 db $20,$20,emunesbuff_end-3-emunesbuff
 db "EMUNES"-54,$2B,"PL DLA"-54
emunesbuff_end
 db $20,$40,emunesbuff_end2-3-emunesbuff_end
 db "GRAMYTATYWNIE"-54
emunesbuff_end2
 db 255
 
strusanim:
 db strus,strus,strus+1,strus+1,strus+2,strus+2,strus+1,strus+1