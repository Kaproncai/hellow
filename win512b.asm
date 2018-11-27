; Windows 512 bytes intro skeleton by TomCat/Abaddon
; Flashdance/MIDI music by ern0

RESX EQU 256
RESY EQU 160

BASE EQU 00400000H
ORG BASE
USE32

FORMAT BINARY AS 'exe'
                 DW 'MZ'       ; 00.e_magic
                 DW 'TC'       ; 02.e_cblp
                 DD 'PE'       ; 04.Signature
                 DW 014CH      ; 08.Machine
                 DW 0          ; 0A.NumberOfSections
LoadLibraryA:    DD 0xE9826FC6 ; 0C.TimeDateStamp
GetWindowRect:   DD 0xF9AC1F38 ; 10.PointerToSymbolTable
ShowCursor:      DD 0x19A434A8 ; 14.NumberOfSymbols
                 DW 8          ; 18.SizeOfOptionalHeader
                 DW 2          ; 1A.Characteristics IMAGE_FILE_EXECUTABLE_IMAGE
                 DW 010BH      ; 1C.Magic
                 DW 0          ; 1E.Major+MinorLinkerVersion
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
                 DW 4          ; 4C.MajorSubsystemVersion
                 DW 0          ; 4E.MinorSubsystemVersion
midiOutOpen:     DD 0xC7AE717F ; 50.Win32VersionValue
                 DD 100000H    ; 54.SizeOfImage
                 DD 30H        ; 58.SizeOfHeaders
midiOutShortMsg: DD 0x0AE8E716 ; 5C.CheckSum
                 DW 2          ; 60.Subsystem 2->gui
                 DW 0          ; 62.DllCharacteristics
start:                         ; 64.SizeOfStackReserve
 MOV ECX,30H
 MOV EAX,[FS:ECX]              ; access to PEB
 PUSH EDX
 MOV EAX,[EAX+0x0C]
 POP EDI
 MOV EAX,[EAX+0x1C]
 MOV DL,libname-BASE
 JMP base
                 DD 0          ; 78.NumberOfRvaAndSizes
libname:         DB 'gdi32',0,'winmm',0,'user32',0

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

base:
 MOV EBP,[EAX+0x20]
 MOV EBX,[EAX+0x08]
 CMP [EBP+0x18],CH
 MOV EAX,[EAX]
 JNZ base

 MOV ESI,EDX
scan:
 PUSH ESI
 PUSH 5CH/4
 POP ECX                       ; LoadLibrary trashes ecx
func:
 PUSHAD
 LEA EDI,[EDI-start+BASE+ECX*4]
 MOV EAX,[EBX+0x3C]            ; EAX = RVA NT Header
 MOV EBP,[EBX+EAX+0x78]        ; EBP = RVA Data Directory
 ADD EBP,EBX                   ; EBP = RVA -> VA

hash:
; EBX = imagebase of dll
; EAX = imagebase + &NT_Hdr
; EBP = imagebase + &DataDirectory
; ESI = &libname
; EDI = &hashed function name

 MOV ECX,[EBP+0x18]            ; ECX = Num Exports
redo:
 JECXZ done                    ; ECX = 0 No More Exports
 DEC ECX                       ; ECX = Num Exports Decreased
 MOV ESI,[EBP+0x20]            ; ESI = RVA Exports Asciiz
 ADD ESI,EBX                   ; ESI = RVA -> VA
 MOV ESI,[ESI+ECX*4]           ; ESI = RVA Export Asciiz Index
 ADD ESI,EBX                   ; ESI = RVA -> VA
 SUB EDX,EDX                   ; .PointerToLinenumbers
calc:
 LODSB                         ; AL  = Char Export Asciiz
 ROL EDX,6                     ; EDX = Hash Preparation
 XOR DL,AL                     ; EDX = Hash Complete
 TEST AL,AL                    ; AL  = 0 Only For End of Asciiz
 JNZ calc                      ; If Not Zero Keep Hashing
 CMP EDX,[EDI]                 ; Check Hash Against Input
 JNZ redo                      ; If Not Equal Hash Next Function

 MOV EDX,[EBP+0x24]            ; EDX = RVA Function Ordinal
 ADD EDX,EBX                   ; EDX = RVA -> VA
 MOVZX ECX,WORD [EDX+ECX*2]
 MOV EDX,[EBP+0x1C]            ; EDX = Function RVAS List
 ADD EDX,EBX                   ; EDX = RVA -> VA
 ADD EBX,[EDX+ECX*4]           ; EBX = Function RVA
 MOV [EDI],EBX
done:
 POPAD                         ; Restore Registers
 LOOP func

 CALL DWORD [EDI-start+LoadLibraryA]
 ADD ESI,6                     ; next dll name
 XCHG EBX,EAX
 TEST EBX,EBX
 JNZ scan

; EBX = 0
; EDI = start

 MUL EBX       ; EAX = 0, EDX = 0
 MOV AH,RESX/256;EAX = RESX
 MOV DL,RESY   ; EDX = RESY

 LEA ECX,[EBX+6]
@@:
 PUSH EBX
 LOOP @B
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
 CALL DWORD [EDI-start+midiOutOpen]

;ShowCursor(FALSE);
 CALL DWORD [EDI-start+ShowCursor]

 LEA EAX,[EDI-start+edit]
 PUSH 91000000H; WS_POPUP|WS_MAXIMIZE|WS_VISIBLE
 PUSH EBX
 PUSH EAX
 PUSH EBX

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

 PUSH 29       ; tempo of the music
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
 SUB ECX,ECX
 MOV CH,RESX*RESY/256
 ADD EDI,ECX   ; virtual screen
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
