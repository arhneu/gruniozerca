nmi:
 pha
 txa
 pha
 tya
 pha
 
 inc global

 lda #>(spriteblock)
 sta dmafunc
 
 lda nmion
 bne doupdates
 
 jmp noupdates
 
doupdates
 lda #$3F
 sta PPUADDR
 lda #0
 sta PPUADDR
 tax
nmipal = 0
 rept 32
	lda gamepal+nmipal,x
	sta PPUDATA
 nmipal = nmipal+1
 endr

;--
nmibuff:
 ldx #0
nmibufflp
 lda buffer,x
 beq nonmibuff
 bpl +
 
 and #$7F
 sta PPUADDR
 
 inx
 lda buffer,x
 sta PPUADDR
 
 inx
 lda buffer,x
 tay
 
 inx
 lda buffer,x
@bufcomprlp
 sta PPUDATA
 dey
 bne @bufcomprlp
 inx
 bne nmibufflp
 
+
 sta PPUADDR
 
 inx
 lda buffer,x
 sta PPUADDR
 
 inx
 lda buffer,x
 tay
 
 inx
- 
 lda buffer,x
 sta PPUDATA
 
 
 inx
 dey
 cpy #0
 bne -
 beq nmibufflp
 
 
;--
nonmibuff
 lda #0
 sta buffer
 sta buffptr
 
 lda ppu0
 sta control0
 lda ppu1
 sta control1
 
 lda scrollx
 sta scrollcon
 lda scrolly
 sta scrollcon
 
noupdates:
 jsr $C003
 jsr FamiToneUpdate
 
@bank
 lda #0
 sta @bank+1
 
 pla
 tay
 pla
 tax
 pla
 
break
 rti