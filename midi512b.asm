; The Grid - Windows 512 bytes intro by TomCat/Abaddon
; Flashdance/MIDI music by ern0

RESX EQU 1280/5
RESY EQU 768

BASE EQU 00400000H
ORG BASE
USE32

FORMAT BINARY AS 'exe'
DIV24:           DW 'MZ'       ; 00.e_magic
                 DW 0x3D2A     ; 02.e_cblp
                 DD 'PE'       ; 04.Signature
                 DW 014CH      ; 08.Machine
                 DW 0          ; 0A.NumberOfSections
LoadLibraryA:    DD 0xE9826FC6 ; 0C.TimeDateStamp
GetWindowRect:   DD 0xF9AC1F38 ; 10.PointerToSymbolTable
ShowCursor:      DD 0x19A434A8 ; 14.NumberOfSymbols
                 DW 8          ; 18.SizeOfOptionalHeader
                 DW 2          ; 1A.Characteristics IMAGE_FILE_EXECUTABLE_IMAGE
ZOOMY:           DW 010BH      ; 1C.Magic
color2:          DW 0x49A0     ; 1E.Major+MinorLinkerVersion (0xFF1AE6)
GetDC:           DD 0xA4D450D1 ; 20.SizeOfCode
CreateWindowExA: DD 0xF8820ECC ; 24.SizeOfInitializedData
StretchDIBits:   DD 0x4ED54D5C ; 28.SizeOfUninitializedData
                 DD start-BASE ; 2C.AddressOfEntryPoint
ExitProcess:     DD 0x38A66AE8 ; 30.BaseOfCode
edit:            DD 'edit'     ; 34.BaseOfData
                 DD BASE       ; 38.ImageBase
                 DD 4          ; 3C.SectionAlignment (.e_lfanew)
                 DD 4          ; 40.FileAlignment
GetAsyncKeyState:DD 0xDE59F860 ; 44.Major+MinorOperatingSystemVersion
GetTickCount:    DD 0xFBBA3133 ; 48.Major+MinorImageVersion
DIV1024:         DW 4          ; 4C.MajorSubsystemVersion
                 DW 0x3A80     ; 4E.MinorSubsystemVersion
midiOutOpen:     DD 0xC7AE717F ; 50.Win32VersionValue
color1:          DD 0x4DB1E6   ; 54.SizeOfImage (malloc)
                 DD 30H        ; 58.SizeOfHeaders
midiOutShortMsg: DD 0x0AE8E716 ; 5C.CheckSum
                 DW 2          ; 60.Subsystem 2->gui
                 DW 0          ; 62.DllCharacteristics
start:                         ; 64.SizeOfStackReserve
 MOV ECX,30H
 MOV EAX,[FS:ECX]              ; access to PEB
 PUSH EDX
 MOV EAX,[EAX+0x0C]
 POP ESI
 MOV EAX,[EAX+0x1C]
 JMP base
                 DW ?          ; 76.
                 DB 0          ; 78.NumberOfRvaAndSizes;
HALF:            DD 0x3F000000

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

libname:         DB 'gdi32',0,'winmm',0,'user32',0

base:
 MOV EBP,[EAX+0x20]
 MOV EBX,[EAX+0x08]
 CMP [EBP+0x18],CH
 MOV EAX,[EAX]
 JNZ base

 LEA EDI,[EDX-start+libname]
scan:
 MOV CL,5CH/4
func:
 PUSHAD
 LEA ESI,[ESI-start+BASE+ECX*4]
 MOV EAX,[EBX+0x3C]            ; EAX = RVA NT Header
 MOV EBP,[EBX+EAX+0x78]        ; EBP = RVA Data Directory
 ADD EBP,EBX                   ; EBP = RVA -> VA

hash:
; EBX = imagebase of dll
; EAX = imagebase + &NT_Hdr
; EBP = imagebase + &DataDirectory
; EDI = &libname
; ESI = &hashed function name

 MOV ECX,[EBP+0x18]            ; ECX = Num Exports
redo:
 JECXZ done                    ; ECX = 0 No More Exports
 DEC ECX                       ; ECX = Num Exports Decreased
 MOV EAX,[EBP+0x20]            ; EAX = RVA Exports Asciiz
 CDQ                           ; EDX = 0 (.PointerToLinenumbers)
 ADD EAX,EBX                   ; EAX = RVA -> VA
 MOV EDI,[EAX+ECX*4]           ; EDI = RVA Export Asciiz Index
 ADD EDI,EBX                   ; EDI = RVA -> VA
 SALC                          ; AL = 0
calc:
 ROL EDX,6                     ; EDX = Hash Preparation
 XOR DL,[EDI]                  ; EDX = Add Char Export Asciiz
 SCASB                         ; AL  = 0 Only For End of Asciiz
 JNZ calc                      ; If Not Zero Keep Hashing
 CMP EDX,[ESI]                 ; Check Hash Against Input
 JNZ redo                      ; If Not Equal Hash Next Function

 MOV EDX,[EBP+0x24]            ; EDX = RVA Function Ordinal
 ADD EDX,EBX                   ; EDX = RVA -> VA
 MOVZX ECX,WORD [EDX+ECX*2]
 MOV EDX,[EBP+0x1C]            ; EDX = Function RVAS List
 ADD EDX,EBX                   ; EDX = RVA -> VA
 ADD EBX,[EDX+ECX*4]           ; EBX = Function RVA
 MOV [ESI],EBX
done:
 POPAD                         ; Restore Registers
 LOOP func

 PUSH EDI
 CALL DWORD [ESI-start+LoadLibraryA]
 XCHG EBX,EAX

 PUSH 6
 POP ECX
@@:
 PUSH EBX
 INC EDI                       ; next dll name
 LOOP @B

 TEST EBX,EBX
 JNZ scan

; EBX = 0
; ESI = start
; EDI = hmo

 MUL EBX       ; EAX = 0, EDX = 0
 MOV AH,RESX/256;EAX = RESX
 MOV DH,RESY/256;EDX = RESY

 PUSH 00200001H; .biPlanes+.biBitCount
 PUSH EDX      ; .biHeight (negative value->vertical flip)
 PUSH EAX      ; .biWidth
 PUSH 40       ; .biSize
 MOV EBP,ESP   ; BITMAPINFOHEADER

 PUSH 00CC0020H; SRCCOPY
 PUSH EBX      ; DIB_RGB_COLORS
 PUSH EBP      ; BITMAPINFOHEADER
 PUSH start+RESX*RESY
 PUSH EDX      ; RESY
 PUSH EAX      ; RESX

 MOV CL,19     ; StretchDIBits:2+midiOutOpen:4+ShowCursor:1+CreateWindowEx:8+RECT:4
@@:
 PUSH EBX      ; fill the stack by zeros
 LOOP @B

;midiOutOpen(&handle, 0, 0, 0, CALLBACK_NULL);
 PUSH EDI      ; lphmo      
 CALL DWORD [ESI-start+midiOutOpen]

;ShowCursor(FALSE);
 CALL DWORD [ESI-start+ShowCursor]

 LEA EAX,[ESI-start+edit]
 PUSH 91000000H; WS_POPUP|WS_MAXIMIZE|WS_VISIBLE
 PUSH EBX
 PUSH EAX
 PUSH EBX

;CreateWindowEx(0,"edit",0,WS_POPUP|WS_MAXIMIZE|WS_VISIBLE,0,0,0,0,0,0,0,0);
 CALL DWORD [ESI-start+CreateWindowExA]

 MOV EDX,ESP
 PUSH EAX      ; hwnd
 PUSH EDX      ; RECT
 PUSH EAX      ; hwnd
 CALL DWORD [ESI-start+GetWindowRect]

;GetDC(hwnd);
 CALL DWORD [ESI-start+GetDC]
 PUSH EAX      ; hdc

music:
 MOV EDX,007F1090H
@@:
 BT [ESI-start+score],EBX
 RCL DH,1
 INC BL
 JNC @B
 ADD DH,[ESI-start+adder]
 TEST BL,BL
 JNZ @F
 XOR WORD [ESI-start+last],7420H
@@:

;midiOutShortMsg(handle, 0x007f4090);
 PUSH EDX      ; send note on channel 0
 PUSH DWORD [ESI-start+libname+6*4]
 CALL DWORD [ESI-start+midiOutShortMsg]

 MOV BH,29     ; tempo of the music

main:
 CALL DWORD [ESI-start+GetTickCount]
 CMP EAX,EBP
 JE main
 XCHG EBP,EAX  ; time counter

 DEC BH
 JZ music

visual:
 MOV ECX,RESX*RESY
 LEA EDI,[ESI+ECX]
@loop:
 LEA EDX,[ECX+(-1*(RESX/2+372*256))] ; center: -1*(RESX/2+RESY/2*256)
 MOV AL,5*2
 IMUL DL
 PUSHAD        ; EDI ESI EBP ESP EBX EDX ECX EAX
 MOV EBP,ESP   ; +00 +04 +08 +12 +16 +20 +24 +28 
 LEA EBX,[ESI-start+color1]
 FILD WORD [EBP+21]
 FMUL DWORD [ESI-start+DIV24]
 FMUL ST0,ST0
 TEST EDX,EDX
 JS @skip

 MOV BL,color2-BASE
 FILD WORD [EBP+28]
;FADD ST0,ST0
 FIDIV WORD [EBP+21]

 FLD DWORD [ESI-start+ZOOMY]
 FIDIV WORD [EBP+21]
 FIADD DWORD [EBP+8]
 FMUL DWORD [ESI-start+DIV1024]
@@:
 FIST DWORD [ESI]
 FISUB DWORD [ESI]
 FADD ST0,ST0
 FMUL ST0,ST0
 FMUL ST0,ST0
;FMUL ST0,ST0
 FXCH
 CMC
 JC @B
 FADDP
 FMUL DWORD [ESI-start+HALF]
 FMULP
@skip:

 FISTP DWORD [ESI]
 LODSD
 CDQ
@bgr:
 PUSH EAX
 MUL BYTE [EBX+EDX]
 MOV [EDI+EDX],AH
 POP EAX
 INC EDX
 JPO @bgr
 POPAD
 SCASD
 LOOP @loop

;StretchDIBits(hdc,rc.left,rc.top,rc.right,rc.bottom,0,0,ResX,ResY,pixels,bmpnfo,0,SRCCOPY);
 CALL DWORD [ESI-start+StretchDIBits]
 SUB ESP,13*4  ; repair the stack frame (preserves StretchDIBits arguments)

 PUSH 1BH      ; VK_ESCAPE
 CALL DWORD [ESI-start+GetAsyncKeyState]
 TEST EAX,EAX
 JZ main

quit:
 JMP DWORD [ESI-start+ExitProcess]
