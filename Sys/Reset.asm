reset:
 sei
 cld
 lda #$40
 sta $4017
 
 ldx #$FF
 txs
 inx
 stx $2000
 stx $2001
 stx $4010
 stx addr
 stx addr+1
 
@wait1:
 bit $2002
 bpl @wait1
 
@wait2:
 bit $2002
 bpl @wait2
 
@wait3:
 bit $2002
 bpl @wait3
  
 ldx #0
@seeresetflg:
 inx
 cpx #8
 beq @norm
 
 lda resetflag,x
 cmp scorechk,x
 beq @seeresetflg
 
 ldx #0
@sethiscore:
 lda startowyhiscore,x
 sta hscore,x
 lda scorechk,x
 sta resetflag,x
 inx
 cpx #8
 bne @sethiscore
 
@norm:
 ldy #0
clearram:
@2
 lda #0
@1
 sta (addr),y
 iny
 bne @1
@3
 inc addr+1
 lda addr+1
 cmp #7
 bne @2
 
 lda #$24
 jsr clearntx
 jmp intomaingame
 
 
scorechk:
 db 6,45,89,23
 db 56,34,89,0
 
startowyhiscore:
 db $10,$10,$10,$10,$15,$10,$10,$10