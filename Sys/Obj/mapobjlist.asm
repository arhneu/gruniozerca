;---
objtbll:
 db <obempty
gracz = ($-objtbll)
 db <obgracz
gracz2 = ($-objtbll)
 db <obgracz
gold = ($-objtbll)
 db <obgold

objtblh:
 db >obempty
 db >obgracz
 db >obgracz
 db >obgold
 
 include "Sys\Obj\gracz.asm"
 include "Sys\Obj\gold.asm"
 
 
obempty:
  jmp nextobj