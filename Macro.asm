PPUADDR = $2006
PPUDATA = $2007
spriteblock = $600
dmafunc = $4014
control0 = $2000
control1 = $2001
scrollcon = $2005

OAM_FLIP_H = $40
OAM_FLIP_V = $80

nmask=	$00
rmask=	$01
lmask=	$02
dmask=	$04
umask=	$08
stmask=	$10
selmask=$20
bmask=	$40
amask=	$80

rbitmask = 0
lbitmask = 1
dbitmask = 2
ubitmask = 3
stbitmask = 4
selbitmask = 5
bbitmask = 6
abitmask = 7

plrh = 10
plrw = 20
maxmus = $14
maxobj = 16				;ile max obiektów na mapie
maxgravity = $20
grunioacc = $4
gruniostartspd = $100
gruniotopspd = $250
goldacc = $E
goldstartspd = $150
goldtopspd = $250

isunrom = 0				;0-nrom,1-unrom
;---------------------------------------------------------------
macro ldxy var		;Adres do X(high) i Y(low)

 ldx #>(var)
 ldy #<(var)

 .endm

;-----------------------
macro add var
 clc
 adc var

 .endm

;-----------------------
macro sub var
 sec
 sbc var

 .endm

;-----------------------
macro nega
 eor #255
 clc
 adc #1

 .endm

;-----------------------1-zmienna w ram, 2-liczba do dodania
macro addto16 var,var2
 lda var1
 clc
 adc #var2
 sta var1
 bcc @1

 inc var1+1

@1
 .endm
 
;----------
; Unsigned 16-bit shift
; 10 cycles if var is on zero page
macro lsr16 var1
        lsr var1+1
        ror var1
 .endm

; Add two 16-bit integers and store result in var1
; 20 cycles if both vars are on zero page
macro add16 var1,var2
        clc
        lda var1
        adc var2
        sta var1
        lda var1+1
        adc var2+1
        sta var1+1
 .endm

; 16-bit subtract var2 from var1 and store result in var1
macro sub16 var1,var2
        sec
        lda var1
        sbc var2
        sta var1
        lda var1+1
        sbc var2+1
        sta var1+1
 .endm
 
 ;---------------------------------------------------------------
macro incr	adres1		;entry address
	inc adres1
	bne @1
	inc adres1+1
@1
	endm