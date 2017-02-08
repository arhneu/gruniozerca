;----------------------------------------------------------------
; constants
;----------------------------------------------------------------
 include "Macro.asm"
;----------------------------------------------------------------
; variables
;----------------------------------------------------------------
   .enum $0030
global: dsb 1
nmion: dsb 1
ppu0: dsb 1
ppu1: dsb 1
spriteblockpointer: dsb 1
ntemp1: dsb 1
ntemp0: dsb 1				;zmienne tymczasowe dla nmi

addr: dsb 2
addr2: dsb 2
addr3: dsb 2

temp: dsb 1
temp1: dsb 1
temp2: dsb 1
temp3: dsb 1
temp4: dsb 1
temp5: dsb 1
temp6: dsb 1
temp7: dsb 1
temp8: dsb 1
temp9: dsb 1
tempa: dsb 1
tempb: dsb 1
tempc: dsb 1
tempd: dsb 1
tempe: dsb 1
tempx: dsb 1

gmpad: dsb 2
debounce: dsb 2
p1button: dsb 2
plrno: dsb 1		;ilu graczy
spra: dsb 1			;tymczasowy atrybut dla sprita
sprx: dsb 1			;tymczasowa pozycja x dla sprita
mts: dsb 1			;atrybut dla meta sprita
spry: dsb 1
gamepal: dsb 32
palcopy: dsb 32
fadestat: dsb 1
fadecnt: dsb 1
scrollx: dsb 1
scrolly: dsb 1
combo: dsb 1
pigcolor: dsb 1
pauza: dsb 1
gameover: dsb 1
;---				;zmienne menu
score: dsb 8
life: dsb 1
onhscore: dsb 1
;---
 .enum $100
buffer: dsb 64		;buffer dla tła
buffptr: dsb 1		;pointer x dla buffera

 .enum $400
Ob.id: dsb maxobj
Ob.x: dsb maxobj
Ob.y: dsb maxobj
Ob.anim: dsb maxobj		;id animacji
Ob.frm: dsb maxobj		;obecna klatka animacji
Ob.frm2: dsb maxobj		;liczy czas do następnej klatki animacji
Ob.frma: dsb maxobj		;atryb klatki
Ob.a: dsb maxobj		;zmienne dla obiektów.
Ob.b: dsb maxobj
Ob.c: dsb maxobj
Ob.d: dsb maxobj
Ob.e: dsb maxobj
Ob.f: dsb maxobj
Ob.g: dsb maxobj

 .enum $700
hscore: dsb 8
resetflag: dsb 8
   .ende

;----------------------------------------------------------------
; iNES header
;----------------------------------------------------------------

   .db "NES", $1a ;identification of the iNES header
 if isunrom = 0 
  .db $02 ;number of 16KB PRG-ROM pages
   .db $01 ;number of 8KB CHR-ROM pages
   .db $00|%0001 ;mapper 2 and mirroring
 else
  db 8*2
  db 0
  db $20|%0001
 endif
   .dsb 9, $00 ;clear the remaining bytes

;----------------------------------------------------------------
; MapData
;----------------------------------------------------------------
   .base $8000
nttbll:
 db <Titlent
 dl gament
 
nttblh:
 db >Titlent
 dh gament
 
Titlent:
 incbin "Gfx\nam\Title.nam"
gament:
 incbin "Gfx\nam\gameplay.nam"

titlemus:
 incbin "Muzyka\title.mus"
gameovermus:
 incbin "Muzyka\over.mus"
ingamemus:
 incbin "Muzyka\ingame.mus"
emptymus:
 incbin "Muzyka\empty.mus"
ropejmp:
 incbin "Muzyka\ropejump.mus"
   .org $c000
   
 if isunrom = 1
   .base $8000
   .org $c000
   .base $8000
   .org $c000
   .base $8000
   .org $c000
   .base $8000
   .org $c000
   .base $8000
   .org $c000
   .base $8000
   .org $c000
   .base $8000
   .org $c000
   .base $8000
   .org $c000
   .base $8000
   .org $c000
   
   .base $8000
   .org $c000
   
   .base $8000
   .org $c000
   
   .base $8000
   .org $c000
   
   .base $8000
   .org $c000
   
   .base $8000
   .org $c000
   
  endif
;----------------------------------------------------------------
; Bank 3
;----------------------------------------------------------------
   .base $c000
   incbin "Muzyka\Engine.bin"				;przerobiony silnik FamiTracker by jsr. See Famitracker.com
   
   include "Sys\Reset.asm"
   include "Sys\nmi.asm"
   include "Sys\KEYPAD.asm"
   include "Sys\general.asm"
   include "Sys\mainloop.asm"
   include "Sys\title.asm"
   include "Sys\Credits.asm"
   include "Sys\Sprity.asm"
   include "Sys\Objworks.asm"
   include "Muzyka\famitone2.asm"			;Silnik Famitone 2 by Shiru. See https://shiru.untergrund.net/
   include "Sys\hscore.asm"
   include "Muzyka\sounds.asm"
   
   if isunrom = 1							;jeśli unrom.
banktbl:
 db 0,1,2,3
  endif
  
bittable:
 db 1,2,4,8,16,32,64,128

 if isunrom = 1
grafikaunrom:
 incbin "gfx\unromchr.chr"
grafikaunrom_end
 endif
   .org $fffa

	dw nmi
	dw reset
	dw break

 if isunrom = 0
 base 0	
 incbin "Gfx\chr.chr"
 endif