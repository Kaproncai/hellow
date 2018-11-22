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

_check:
 DB 0,0,'GetAsyncKeyState',0
_moutm:
 DB 0,0,'midiOutShortMsg',0
_creat:
 DB 0,0,'CreateWindowExA',0
_stret:
 DB 0,0,'StretchDIBits',0
_getwr:
 DB 0,0,'GetWindowRect',0
_gtick:
 DB 0,0,'GetTickCount',0
_exitp:
 DB 0,0,'ExitProcess',0
_mopen:
 DB 0,0,'midiOutOpen',0
_showc:
 DB 0,0,'ShowCursor',0
_getdc:
 DB 0,0,'GetDC',0

kern32:
 DB 'kernel32',0
user32:
 DB 'user32',0
gdi32:
 DB 'gdi32',0
midi32:
 DB 'winmm',0
edit:
 DB 'edit',0

;bit mirror table
;0123456789ABCDEF
;084C2A6E195D3B7F

score:        
 DB 32H,3DH,32H,3DH,0D4H,0D5H,0D4H,0D5H,0D4H,0D5H,0D4H,0D5H
 DB 94H,91H,94H,91H,90H,91H,90H,91H,0E0H,0E6H,0E0H,0E6H
 DB 24H,0E6H,0D9H,93H,62H,91H,03DH
last:
 DB 0F7H       ; XOR 0D7H
adder:
 DB 60         ; XOR 72 

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
 MOV EDI,EDX
 SUB EBX,EBX

 LEA ECX,[EBX+6]
@@:
 PUSH EBX
 LOOP @B
 PUSH 00200001H; .biPlanes+.biBitCount
 PUSH -RESY    ; .biHeight
 PUSH RESX     ; .biWidth
 PUSH 40       ; .biSize
 MOV EBP,ESP   ; BITMAPINFOHEADER

 PUSH 00CC0020H; SRCCOPY
 PUSH EBX      ; DIB_RGB_COLORS
 PUSH EBP      ; BITMAPINFOHEADER 
 DB 66H,6AH,41H; pixels (PUSH 00410000H)
 PUSH EBX
 DW 6866H,RESY ; RESY (PUSH RESY)
 PUSH RESX     ; RESX
;PUSH EBX      ; 0
;PUSH EBX      ; 0

 MOV CL,2+4+8+4; 2:StretchDIBits, 4:midiOutOpen, 8:CreateWindowEx, 4:RECT
@@:
 PUSH EBX      ; fill by zero
 LOOP @B

;midiOutOpen(&handle, 0, 0, 0, CALLBACK_NULL);
 PUSH EDX      ; lphmo      
 CALL DWORD [EDI-start+midiOutOpen]

 LEA EAX,[EDI-start+edit]
 PUSH 91000000H; WS_POPUP|WS_MAXIMIZE|WS_VISIBLE
 PUSH EBX
 PUSH EAX
 PUSH EBX

;ShowCursor(FALSE);
 PUSH EBX
 CALL DWORD [EDI-start+ShowCursor]

;CreateWindowEx(0,"edit",0,WS_POPUP|WS_MAXIMIZE|WS_VISIBLE,0,0,0,0,0,0,0,0);
 CALL DWORD [EDI-start+CreateWindowExA]

 MOV EDX,ESP
 PUSH EAX      ; hwnd
 PUSH EDX      ; RECT
 PUSH EAX      ; hwnd
 CALL DWORD [EDI-start+GetWindowRect]

;GetDC(hwnd);
 CALL DWORD [EDI-start+GetDC]
 PUSH EAX      ; hdc

music:
 MOV EDX,007F1090H
@@:
 BT [EDI-start+score],EBX
 RCL DH,1
 INC BL
 JNC @B
 ADD DH,[EDI-start+adder]
 TEST BL,BL
 JNZ @F
 XOR WORD [EDI-start+last],7420H
@@:

;midiOutShortMsg(handle, 0x007f4090);
 PUSH EDX      ; send note on channel 0
 PUSH DWORD [EDI]
 CALL DWORD [EDI-start+midiOutShortMsg]

 PUSH 32       ; tempo of the music
 POP EBP

main:
 CALL DWORD [EDI-start+GetTickCount]
 CMP EAX,ESI
 JE main
 XCHG ESI,EAX  ; time counter

 DEC EBP
 JZ music

visual:
 PUSHAD
 SHR ESI,6     ; speed of the visual
 MOV EDI,[ESP+17*4]
 MOV ECX,RESX*RESY
@loop:
 LEA EAX,[ESI+ECX]
 PUSH EAX
 MOV DL,CH
 ADD EDX,ESI
 PUSH EDX
 ADD EAX,EDX
 PUSH EAX
 SUB EDX,EDX
@@:
 POP EAX
 CBW
 XOR AL,AH
 ADD AL,AL
 STOSB
 INC EDX
 JPO @B
 INC EDI
 LOOP @loop
 POPAD

;StretchDIBits(hdc,rc.left,rc.top,rc.right,rc.bottom,0,0,ResX,ResY,pixels,bmpnfo,0,SRCCOPY);
 CALL DWORD [EDI-start+StretchDIBits]
 SUB ESP,13*4  ; repair the stack frame (preserves StretchDIBits arguments)

 PUSH 1BH      ; VK_ESCAPE
 CALL DWORD [EDI-start+GetAsyncKeyState]
 TEST EAX,EAX
 JZ main

quit:
 JMP DWORD [EDI-start+ExitProcess]
