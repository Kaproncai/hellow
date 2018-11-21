; Windows intro skeleton by TomCat/Abaddon
; Flashdance/MIDI music by ern0

RESX EQU 256
RESY EQU 160

BASE EQU 00400000H
ORG BASE
USE32

FORMAT BINARY AS 'exe'
 DW 'MZ'       ; 00.e_magic
 DW ?          ; 02.e_cblp
 DD 'PE'       ; 04.Signature
 DW 014CH      ; 08.Machine
 DW 0          ; 0A.NumberOfSections
 DD ?          ; 0C.TimeDateStamp
 DD ?          ; 10.PointerToSymbolTable
 DD ?          ; 14.NumberOfSymbols
 DW 0          ; 18.SizeOfOptionalHeader
 DW 2          ; 1A.Characteristics IMAGE_FILE_EXECUTABLE_IMAGE&!IMAGE_FILE_DLL
 DW 010BH      ; 1C.Magic
 DB ?          ; 1E.MajorLinkerVersion
 DB ?          ; 1F.MinorLinkerVersion
 DD ?          ; 20.SizeOfCode
 DD ?          ; 24.SizeOfInitializedData
 DD ?          ; 28.SizeOfUninitializedData
 DD start-BASE ; 2C.AddressOfEntryPoint
 DD ?          ; 30.BaseOfCode
 DD ?          ; 34.BaseOfData
 DD BASE       ; 38.ImageBase
 DD 4          ; 3C.SectionAlignment (.e_lfanew)
 DD 4          ; 40.FileAlignment
 DW ?          ; 44.MajorOperatingSystemVersion
 DW ?          ; 46.MinorOperatingSystemVersion
 DW ?          ; 48.MajorImageVersion
 DW ?          ; 4A.MinorImageVersion
 DW 4          ; 4C.MajorSubsystemVersion
 DW ?          ; 4E.MinorSubsystemVersion
 DD 0          ; 50.Win32VersionValue
 DD 00100000H  ; 54.SizeOfImage
 DD 2CH        ; 58.SizeOfHeaders
 DD ?          ; 5C.CheckSum
 DW 2          ; 60.Subsystem 2->gui
 DW 0          ; 62.DllCharacteristics
 DB ?,?,?,0    ; 64.SizeOfStackReserve
 DD ?          ; 68.SizeOfStackCommit
 DB ?,?,?,0    ; 6C.SizeOfHeapReserve
 DD ?          ; 70.SizeOfHeapCommit
 DD ?          ; 74.LoaderFlags
 DD 13         ; 78.NumberOfRvaAndSizes
 DD ?          ; 7C.Export.RVA
 DD ?          ; 80.Export.Size
 DD IMPORT-BASE; 84.Import.RVA
 DD ?          ; 88.Import.Size
 DD 0          ; 8C.Resource.RVA
 DD ?          ; 90.Resource.Size
 DD ?          ; 94.Exception.RVA
 DD ?          ; 98.Exception.Size
 DD ?          ; 9C.Security.RVA
 DD ?          ; A0.Security.Size
 DD ?          ; A4.Basereloc.RVA
 DD ?          ; A8.Basereloc.Size
 DD ?          ; AC.Debug.RVA
 DD 0          ; B0.Debug.Size
 DD ?          ; B4.Copyright.RVA
 DD ?          ; B8.Copyright.Size
 DD ?          ; BC.Globalptr.RVA
 DD ?          ; C0.Globalptr.Size
 DD 0          ; C4.TLS.RVA
 DD ?          ; C8.TLS.Size
 DD ?          ; CC.LoadConfig.RVA
 DD ?          ; D0.LoadConfig.Size
 DD ?          ; D4.BoundImport.RVA
 DD ?          ; D8.BoundImport.Size
 DD IAT-BASE   ; DC.IAT.RVA
 DD IATend-IAT ; E0.IAT.Size

IMPORT:
 DD 0
 DD ?
 DD ?
 DD gdi32-BASE
 DD g32-BASE
 DD 0
 DD ?
 DD ?
 DD user32-BASE
 DD u32-BASE
 DD 0
 DD ?
 DD ?
 DD kern32-BASE
 DD k32-BASE
 DD 0
 DD ?
 DD ?
 DD midi32-BASE
 DD m32-BASE
 DD ?
 DD ?
 DD ?
 DD 0          ; TERMINATOR
 DD ?

_showc:
 DB 0,0,'ShowCursor',0
_creat:
 DB 0,0,'CreateWindowExA',0
_getwr:
 DB 0,0,'GetWindowRect',0
_getdc:
 DB 0,0,'GetDC',0
_check:
 DB 0,0,'GetAsyncKeyState',0
_stret:
 DB 0,0,'StretchDIBits',0
_gtick:
 DB 0,0,'GetTickCount',0
_mopen:
 DB 0,0,'midiOutOpen',0
_moutm:
 DB 0,0,'midiOutShortMsg',0
_exitp:
 DB 0,0,'ExitProcess',0

edit:
 DB 'edit',0

user32:
 DB 'user32',0
gdi32:
 DB 'gdi32',0
kern32:
 DB 'kernel32',0
midi32:
 DB 'winmm',0

score:        
 DB 4CH,4CH,2BH,2BH,2BH,2BH
 DB 29H,29H,09H,09H,07H,07H
tricky:
 DB 24H,67H,9BH,0C9H,46H,89H,0BCH
last:
 DB 0EFH

IAT:;--------------------------
m32:
midiOutOpen:
 DD _mopen-BASE; .AddressOfData
midiOutShortMsg:
 DD _moutm-BASE; .AddressOfData
 DD 0          ; .Terminator
k32:
ExitProcess:
 DD _exitp-BASE; .AddressOfData
GetTickCount:
 DD _gtick-BASE; .AddressOfData
 DD 0          ; .Terminator
g32:
StretchDIBits:
 DD _stret-BASE; .AddressOfData
 DD 0          ; .Terminator
u32:
ShowCursor:
 DD _showc-BASE; .AddressOfData
CreateWindowExA:
 DD _creat-BASE; .AddressOfData
GetWindowRect:
 DD _getwr-BASE; .AddressOfData
GetDC:
 DD _getdc-BASE; .AddressOfData
GetAsyncKeyState:
 DD _check-BASE; .AddressOfData
 DD 0          ; .Terminator
IATend:;-----------------------

start:
 MOV EBX,EDX

;midiOutOpen(&handle, 0, 0, 0, CALLBACK_NULL);
 SUB ECX,ECX
 PUSH ECX      ; CALLBACK_NULL
 PUSH ECX      ; 0
 PUSH ECX      ; 0
 PUSH ECX      ; 0
 PUSH EDX      ; lphmo      
 CALL DWORD [EBX-start+midiOutOpen]

 LEA EAX,[EBX-start+edit]
 CDQ           ; EDX:zero

 PUSH 6
 POP ECX       ; ECX:6
@@:
 PUSH EDX
 LOOP @B
 PUSH 00200001H; .biPlanes+.biBitCount
 PUSH -RESY    ; .biHeight
 PUSH RESX     ; .biWidth
 PUSH 40       ; .biSize
 MOV EBP,ESP   ; BITMAPINFOHEADER

 PUSH 00CC0020H; SRCCOPY
 PUSH EDX      ; DIB_RGB_COLORS
 PUSH EBP      ; BITMAPINFOHEADER 
 PUSH 00410000H; pixels
 PUSH RESY
 PUSH RESX
;PUSH EDX
;PUSH EDX

 MOV CL,8+4+2
@@:
 PUSH EDX
 LOOP @B
 PUSH 91000000H; WS_POPUP|WS_MAXIMIZE|WS_VISIBLE
 PUSH EDX
 PUSH EAX
 PUSH EDX

;ShowCursor(FALSE);
 PUSH EDX
 CALL DWORD [EBX-start+ShowCursor]

;CreateWindowEx(0,"edit",0,WS_POPUP|WS_MAXIMIZE|WS_VISIBLE,0,0,0,0,0,0,0,0);
 CALL DWORD [EBX-start+CreateWindowExA]

 MOV EDX,ESP
 PUSH EAX      ; hwnd
 PUSH EDX      ; RECT
 PUSH EAX      ; hwnd
 CALL DWORD [EBX-start+GetWindowRect]

;GetDC(hwnd);
 CALL DWORD [EBX-start+GetDC]
 PUSH EAX      ; hdc

 MOV EDI,0FFFF3C00H ; inital value of DI, AH, AL

main0:
 PUSH 32       ; tempo of the music
 POP EBP

main:
 CALL DWORD [EBX-start+GetTickCount]
 CMP EAX,ESI
 JE main
 XCHG ESI,EAX  ; time counter

visual:
 PUSHAD
 SHR ESI,6     ; speed of the visual
 MOV EDI,00410000H
 MOV ECX,RESX*RESY
@@:
 LEA EAX,[ESI+ECX-85]
 CBW
 XOR AL,AH
 ADD AL,AL
 STOSB
 MOV EAX,ESI
 ADD AL,CH
 CBW
 XOR AL,AH
 ADD AL,AL
 STOSB
 LEA EAX,[ESI+ECX+85]
 CBW
 XOR AL,AH
 ADD AL,AL
 STOSB
 INC EDI
 LOOP @B
 POPAD

;StretchDIBits(hdc,rc.left,rc.top,rc.right,rc.bottom,0,0,ResX,ResY,pixels,bmpnfo,0,SRCCOPY);
 CALL DWORD [EBX-start+StretchDIBits]
 SUB ESP,13*4  ; repair the stack frame (preserves StretchDIBits arguments)

 DEC EBP
 JNZ main

music:
 MOV EAX,EDI   ; AL: note counter, AH: adder
 SAR EDI,16    ; EDI: score pointer

 MOV EDX,007F4090H
 MOV CL,0      ; get lower digit
 AND AL,3
 JNZ .read_note

.no_trick:
 SALC
 INC EDI
 MOV CL,4      ; get upper digit

 CMP EDI,last-score
 JBE .read_note 

 SUB EDI,EDI
 XOR AH,(60 XOR 72)
 XOR BYTE [EBX-start+last],(0EFH XOR 0EBH)

.read_note:
 MOV DH,[EBX-start+score+EDI]
 SHR DH,CL
 CMP AL,2
 JNE .play_note

 DEC DH        ; part 1, note 3 of 4: pitch -1
 CMP EDI,tricky-score
 JNB .no_trick

.play_note:
 AND DH,15
 ADD DH,AH
 INC EAX       ; increment note counter
 PUSH DI
 PUSH AX
 POP EDI       ; save to EDI

;midiOutShortMsg(handle, 0x007f4090);
 PUSH EDX      ; send note on channel 0
 PUSH DWORD [EBX]
 CALL DWORD [EBX-start+midiOutShortMsg]

 PUSH 1BH      ; VK_ESCAPE
 CALL DWORD [EBX-start+GetAsyncKeyState]
 TEST EAX,EAX
 JZ main0

quit:
 JMP DWORD [EBX-start+ExitProcess]
