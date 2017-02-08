intomaingame:
 jsr intotitle
 
intogameplay:
 jsr waitframe
 
 jsr turnninoff
 jsr clearnt
 
 jsr blackpal
 
 lda #1
 jsr uplnt
nextlevel:
 lda #$10
 sta score
 sta score+1
 sta score+2
 sta score+3
 sta score+4
 sta score+5
 sta score+6
 sta score+7
 
 lda #3
 sta life
 
 lda #0
 sta p1button
 
 lda #1
 jsr startmus
 
 jsr turnninon

;---ustaw grunia
 lda #1
 sta Ob.id

 lda #$B0+1
 sta Ob.y
 
 lda #$80-(plrw/3)
 sta Ob.x
 
 lda #>gruniostartspd
 sta xspeedh					;szybkość poruszania się grunia
 lda #<gruniostartspd
 sta xspeedl					;szybkość poruszania się grunia
 
;-ustaw marchewkę
 lda #3
 sta Ob.id+1
 lda #<goldstartspd
 sta goldspdl+1
 lda #>goldstartspd
 sta goldspdh+1
 
 lda global
 sta Ob.x+1
 
 lda #$0
 sta Ob.y+1
 
 lda #walkanim+1
 sta Ob.anim+1
 
 jsr objplay
 jsr drawhp
 
 lda #1
 jsr loadmappal
 jsr blackpal

 lda #8
 jsr fadein
 
@gameplaylp
 jsr waitframe
 jsr clearspr
 jsr KEYPAD

 jsr objplay

 jsr drawhp
 bcs @seepause
 
 lda Ob.anim+1
 cmp #explanim
 beq @seepause
 
 lda #2
 jsr startmus
 
 ldxy gameoverbuff
 jsr putinbuff
 jsr clearspr
@gameoverlp:
 jsr waitframe
 jsr KEYPAD
 
 lda p1button
 and #amask+bmask+stmask+selmask
 beq @gameoverlp
  
 lda #8
 jsr fadeout
 
 lda #3
 jsr startmus
 
 jsr turnninoff
 jsr chkifnewhscore
 jmp reset
 
@seepause
 lda pauza
 beq @endmainlp
 
@pauselp
 jsr waitframe
 jsr KEYPAD
 
 lda p1button
 and #stmask
 beq @pauselp
 
 ldxy pauseoffbuff
 jsr putinbuff
 
 lda #0
 sta pauza
 
@endmainlp
 jmp @gameplaylp
 
;----
drawhp
 lda #$10
 sta spry
 lda #$3
 sta spra
 
 lda life
 cmp #3
 bcc @2
 
 lda #$D9
 sta sprx
 lda #$26
 jsr Rys1
 
@2
 lda life
 cmp #2
 bcc @1
 
 lda #$E3
 sta sprx
 lda #$26
 jsr Rys1
 
@1
 lda life
 cmp #1
 bcc @last
  
 lda #$ED
 sta sprx
 lda #$26
 jsr Rys1
 sec
 rts
@last
 clc
 rts
 
gameoverbuff
 db $21,$4C,gameoverbuff_end-3-gameoverbuff
 db "GAME"-54,0,"OVER"-54
gameoverbuff_end
 db 255