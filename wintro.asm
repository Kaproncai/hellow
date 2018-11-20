; Windows intro skeleton by TomCat/Abaddon

RESX EQU 256
RESY EQU 192

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
_peekm:
 DB 0,0,'PeekMessageA',0
_stret:
 DB 0,0,'StretchDIBits',0
_gtick:
 DB 0,0,'GetTickCount',0

edit:
 DB 'edit',0

user32:
 DB 'user32',0
gdi32:
 DB 'gdi32',0
kern32:
 DB 'kernel32',0

IAT:;--------------------------
k32:
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
PeekMessageA:
 DD _peekm-BASE; .AddressOfData
 DD 0          ; .Terminator
IATend:;-----------------------

start:
 MOV EBP,EDX

 PUSHAD        ; MSG

 LEA EAX,[EBP-start+edit]
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
 MOV EBX,ESP   ; BITMAPINFOHEADER

 PUSH 00CC0020H; SRCCOPY
 PUSH EDX      ; DIB_RGB_COLORS
 PUSH EBX      ; BITMAPINFOHEADER 
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
 CALL DWORD [EBP-start+ShowCursor]

;CreateWindowEx(0,"edit",0,WS_POPUP|WS_MAXIMIZE|WS_VISIBLE,0,0,0,0,0,0,0,0);
 CALL DWORD [EBP-start+CreateWindowExA]

 MOV EDX,ESP
 PUSH EAX      ; hwnd
 PUSH EDX      ; RECT
 PUSH EAX      ; hwnd
 CALL DWORD [EBP-start+GetWindowRect]

;GetDC(hwnd);
 CALL DWORD [EBP-start+GetDC]
 PUSH EAX      ; hdc

main:
 CALL DWORD [EBP-start+GetTickCount]

 LEA EAX,[ESP+92]
 SUB EDX,EDX
 PUSH 1        ; PM_REMOVE
 PUSH EDX
 PUSH EDX
 PUSH EDX
 PUSH EAX
 CALL DWORD [EBP-start+PeekMessageA]

;StretchDIBits(hdc,rc.left,rc.top,rc.right,rc.bottom,0,0,ResX,ResY,pixels,bmpnfo,0,SRCCOPY);
 CALL DWORD [EBP-start+StretchDIBits]
 SUB ESP,13*4  ; repair the stack frame (preserves StretchDIBits arguments)

 CMP DWORD [ESP+96],00000100H
 JNE main      ; WM_KEYDOWN
 ADD ESP,124   ; 13*4+40+8*4 (StretchDIBits+BITMAPINFOHEADER+MSG)

RETN
