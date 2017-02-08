spr_x equ temp
spr_y equ temp2

addmirr = $4				;kolejny bajt to bajt odwrócenia w poziomie

putsprite:					;X-pozycja x,Y-pozycja Y,A-ID
 pha
 lda #0
 sta mts
 pla
putspriterev:
 stx spr_x
 sty spr_y

 tay
 asl
 tax
 
 lda spritetable,x
 sta addr
 lda spritetable+1,x
 sta addr+1
 
 cpy #128					;pozwala na więcej niż 128 spritów
 bne +
 
 inc addr+1
+
 ldy #0
@putspritelp
 lda (addr),y				;wczytaj x
 cmp #128
 beq @putspriteend
 
 add spr_x
 sta sprx
 
 iny
 lda (addr),y
 add spr_y
 sta spry
 
 iny
 lda (addr),y
 pha

 iny
 lda (addr),y
 pha
 and #4
 beq @notmirror

 iny
 lda mts
 and #$40
 beq @notmirror
 
 lda (addr),y
 add spr_x
 sta sprx
 
@notmirror
 pla 
 ora mts
 sta spra
 
 pla
 jsr Rys1
 
 iny
 bne @putspritelp
 
@putspriteend
 lda #0
 sta mts
 rts
 
;-----
Rys1:
 ldx spriteblockpointer

 sta spriteblock+1,x
 
 lda spry
 sta spriteblock,x
 
 lda spra
 sta spriteblock+2,x

 lda sprx
 sta spriteblock+3,x
 
@cont
 txa
 add #4
 sta spriteblockpointer
 
 rts

;-----
spritetable:
 dw sempty
goldspr = ($-spritetable)/2
 dw sgold
grunioidlespr = ($-spritetable)/2
 dw sgrunioidle
gruniowalkspr = ($-spritetable)/2
 dw sgruniowalk1
 dw sgruniowalk2
pktspr = ($-spritetable)/2
 dw spkt10
 dw spkt50
 dw spkt100
 dw spkt200
 dw spkt500
 dw spkt1000
 dw spkt2000
 dw spkt5000
explspr = ($-spritetable)/2
 dw sexp
 dw sexp1
 dw sexp2
 dw sexp3
 dw sexp4
 dw sexp5
strus = ($-spritetable)/2
 dw sstrus
 dw sstrus2
 dw sstrus3
mlem = ($-spritetable)/2
 dw smlem
 
 ; = ($-spritetable)/2
 ;dw 
sgold:
 db 0,0,$54,2
 db 8,0,$55,2
 db 2,8,$52,2
 db 2,16,$53,2
sempty
 db 128

sgrunioidle:
 db 0,0,$30,0|addmirr,12
 db 8,0,$31,0|addmirr,4
 db 16,0,$32,0|addmirr,$FC
 db 0,8,$33,0|addmirr,12
 db 8,8,$34,0|addmirr,4
 db 16,8,$35,0|addmirr,$FC
 
 db $0C,$FF,$2E,$01|addmirr,0
 db $0C,$07,$2F,$01|addmirr,0
 
 db 128

sgruniowalk1:
 db 0,-1,$36,0|addmirr,12
 db 8,-1,$37,0|addmirr,4
 db 16,-1,$38,0|addmirr,$FC
 db 0,8-1,$39,0|addmirr,12
 db 8,8-1,$3A,0|addmirr,4
 db 16,8-1,$3B,0|addmirr,$FC
 
 db $0C,$FF,$2E,$01|addmirr,0
 db $0C,$07,$2F,$01|addmirr,0
 db 128
sgruniowalk2:
 db 0,0-1,$3C,0|addmirr,12
 db 8,0-1,$3D,0|addmirr,4
 db 16,0-1,$3E,0|addmirr,$FC
 db 0,8-1,$3F,0|addmirr,12
 db 8,8-1,$40,0|addmirr,4
 db 16,8-1,$41,0|addmirr,$FC
 
 db $0C,$FF,$2E,$01|addmirr,0
 db $0C,$07,$2F,$01|addmirr,0
 db 128
 
spkt10:
 db 0,4,2,0
 db 8,4,1,0
 db 128
 
spkt50:
 db 0,4,6,0
 db 8,4,1,0
 db 128
 
spkt100:
 db 0,4,2,0
 db 8,4,1,0
 db 16,4,1,0
 db 128
 
spkt200:
 db 0,4,3,0
 db 8,4,1,0
 db 16,4,1,0
 db 128
 
spkt500:
 db 0,4,6,0
 db 8,4,1,0
 db 16,4,1,0
 db 128
 
spkt1000:
 db 0,4,2,0
 db 8,4,1,0
 db 16,4,1,0
 db 24,4,1,0
 db 128
 
spkt2000:
 db 0,4,3,0
 db 8,4,1,0
 db 16,4,1,0
 db 24,4,1,0
 db 128
 
spkt5000:
 db 0,4,6,0
 db 8,4,1,0
 db 16,4,1,0
 db 24,4,1,0
 db 128
 
sexp:
 db 0,0,$56,0
 db 128
sexp1:
 db -4,-4,$56,0
 db 4,-4,$56,0
 db -4,4,$56,0
 db 4,4,$56,0
 db 128
sexp2:
 db -8,-8,$56,0
 db 8,-8,$56,0
 db -8,8,$56,0
 db 8,8,$56,0
 db 128
sexp3:
 db -10,-10,$57,0
 db 10,-10,$57,0
 db -10,10,$57,0
 db 10,10,$57,0
 db 128
sexp4:
 db -12,-12,$58,0
 db 12,-12,$58,0
 db -12,12,$58,0
 db 12,12,$58,0
 db 128
 db 128
sexp5:
 db -13,-13,$59,0
 db 13,-13,$59,0
 db -13,13,$59,0
 db 13,13,$59,0
 db 128

sstrus:
 db $00,$00,$70,$00
 db $00,$08,$71,$00
 db $08,$08,$72,$00|addmirr,-8
 db $00,$10,$73,$00
 db $FA,$08,$74,$01|addmirr,6
 db $02,$08,$75,$01|addmirr,$fe
 db $01,$FF,$76,$02|addmirr,$FF
 db $FF,$07,$77,$02|addmirr,1
 db $07,$07,$78,$02|addmirr,-7
 db $FF,$0F,$79,$02|addmirr,1
 db $07,$0F,$7A,$02|addmirr,-7
 db $02,$17,$7B,$02|addmirr,-2
 db 128

sstrus2:
 db $00,$00,$80,$00
 db $00,$08,$81,$00
 db $08,$08,$82,$00|addmirr,-8
 db $00,$10,$83,$00
 db $FA,$08,$84,$01|addmirr,6
 db $02,$08,$85,$01|addmirr,-2
 db $01,$FF,$86,$02|addmirr,-1
 db $FF,$07,$87,$02|addmirr,1
 db $07,$07,$88,$02|addmirr,-7
 db $FF,$0F,$89,$02|addmirr,1
 db $07,$0F,$8A,$02|addmirr,-7
 db $FF,$17,$8B,$02|addmirr,1
 db $07,$17,$8C,$02|addmirr,-7
 db 128

sstrus3:
 db $00,$00,$90,$00
 db $00,$08,$91,$00
 db $08,$08,$92,$00|addmirr,-8
 db $00,$10,$93,$00
 db $08,$10,$94,$00|addmirr,-8
 db $FA,$08,$95,$01|addmirr,6
 db $02,$08,$96,$01|addmirr,-2
 db $01,$FF,$97,$02|addmirr,-1
 db $FF,$07,$98,$02|addmirr,1
 db $07,$07,$99,$02|addmirr,-7
 db $FF,$0F,$9A,$02|addmirr,1
 db $07,$0F,$9B,$02|addmirr,-7
 db $FF,$17,$9C,$02|addmirr,1
 db $07,$17,$9D,$02|addmirr,-7
 db 128
 
smlem:
 db 0,0,$7C,2
 db 8,0,$7D,2
 db 16,0,$A2,2+$80
 db 24,0,$A2,2+$80
 db 32,0,$A2,2+$80
 db 40,0,$7D,2+$40
 db 40,0,$7D,2+$40
 db 48,0,$7C,2+$40
 db 0,8,$7E,2
 db 8,8,$7F,2
 db 16,8,$8D,2
 db 24,8,$8E,2
 db 32,8,$8F,2
 db 40,8,$9E,2
 db 48,8,$7E,2+$40
 db 0,16,$9F,2
 db 8,16,$A0,2
 db 16,16,$A1,2
 db 24,16,$A2,2
 db 32,16,$A2,2
 db 40,16,$A3,2
 db 48,16,$9F,2+$40
  
 db 128