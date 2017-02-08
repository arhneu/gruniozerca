creditsstart:
 lda #4
 jsr fadeout
 
 jsr turnninoff
 
 ;jsr clearnt
 
 jsr blackpal
 
 lda #$20
 sta palcopy+1
 
 jsr turnninon
 
 lda ppu0
 ora #1
 sta ppu0
 
 ldxy authbuff
 jsr putinbuff
 jsr waitframe
 
 ldxy progrbuff
 jsr putinbuff
 jsr waitframe
 
 ldxy Muzyka
 jsr putinbuff
 jsr waitframe
 
 lda #$4
 jsr fadein
 
 lda #0
 sta tempd
  
@credlp:
 jsr waitframe
 jsr KEYPAD
 
 inc tempd

 lda tempd
 cmp #$80
 beq @credend
 
 lda p1button
 and #-1
 beq @credlp 

@credend
 lda #4
 jsr fadeout
 
 lda #$16
 sta palcopy+5
 lda #$20
 sta palcopy+6
 lda #$10
 sta palcopy+7
 
 lda ppu0
 and #$FE
 sta ppu0
 
 lda #0
 sta tempd
 
 lda #4
 jsr fadein
 jmp inf
 
;---
authbuff:
 db $24,$8C,authbuff_end-3-authbuff
 db "AUTORZY"-54,$2C
authbuff_end
 db 255
 
progrbuff:
 db $24,$EB,Lukasz_end-3-progrbuff
 db $2D,"UKASZ"-54,0,"KUR"-54
Lukasz_end
 db $25,$2B-3,Rysard-3-Lukasz_end
 db "RYSZARD"-54,0,"BRZUKA"-54,$2D,"A"-54
Rysard:
 db $25,$6C-3,Rysard_end-3-Rysard
 db "EMUNES"-54,$2B,"PL"-54,0,3,1,2,7
Rysard_end
 db 255


Muzyka:
 db $26,$26,Muzyka_end-3-Muzyka
 db "MUZYKE"-54,0,"SKOMPONOWA"-54,$2D,$2C
Muzyka_end
 db $26,$6D,Ozzed-3-Muzyka_end
 db "OZZED"-54
Ozzed:
 db $26,$A8-3,Ozzed_end-3-Ozzed
 db "NA"-54,0,"LICENCJI"-54,0,"CC"-54,0,"BY"-54,$6F,"SA"-54,0,4,$2B,1
Ozzed_end
 db 255