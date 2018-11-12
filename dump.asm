; Dump EDX register console application by TomCat/Abaddon

BASE EQU 00400000H
ORG BASE
USE32

FORMAT BINARY AS 'exe'
 DW 'MZ'       ; 00.e_magic
 DW ?          ; 02.e_cblp
 DD 'PE'       ; 04.Signature
 DW 014CH      ; 08.Machine
 DW 0          ; 0A.NumberOfSections
 DD 'EDX:'     ; 0C.TimeDateStamp
 DD ' %x'      ; 10.PointerToSymbolTable
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
 DW 3          ; 60.Subsystem 3->console
 DW 0          ; 62.DllCharacteristics
 DD 0          ; 64.SizeOfStackReserve
 DD ?          ; 68.SizeOfStackCommit
 DD 0          ; 6C.SizeOfHeapReserve

IMPORT:
 DD 'msvc'     ; 70.SizeOfHeapCommit
 DD 'rt'       ; 74.LoaderFlags
 DD 13         ; 78.NumberOfRvaAndSizes
 DD $-12-BASE  ; 7C.Export.RVA
 DD printf-BASE; 80.Export.Size

 DD IMPORT-BASE; 84.Import.RVA
 DD ?          ; 88.Import.Size
 DD 0          ; 8C.Resource.RVA
 DW 0          ; 90.Resource.Size (TERMINATOR)
BYNAME:
 DW 0          ;
 DD 'prin'     ; 94.Exception.RVA

 DD 'tf'       ; 98.Exception.Size
 DD ?          ; 9C.Security.RVA
 DD ?          ; A0.Security.Size
 DD ?          ; A4.Basereloc.RVA
 DD ?          ; A8.Basereloc.Size

 DD ?          ; AC.Debug.RVA
 DD ?          ; B0.Debug.Size =0?
 DD ?          ; B4.Copyright.RVA
 DD ?          ; B8.Copyright.Size
 DD ?          ; BC.Globalptr.RVA

 DD ?          ; C0.Globalptr.Size
 DD ?          ; C4.TLS.RVA =0?
 DD ?          ; C8.TLS.Size
 DD ?          ; CC.LoadConfig.RVA
 DD ?          ; D0.LoadConfig.Size

 DD ?          ; D4.BoundImport.RVA
 DD ?          ; D8.BoundImport.Size
 DD IAT-BASE   ; DC.IAT.RVA
 DD IATend-IAT ; E0.IAT.Size

start:
 PUSH EDX
 MOV DL,0CH
 PUSH EDX
 MOV DL,printf-BASE
 CALL DWORD [EDX]
 POP EAX
 POP EAX
RETN

IAT:
printf:
 DD BYNAME-BASE; .AddressOfData
 DD 0          ; .Terminator
IATend:

; Make sure the file is 268 bytes long at least!
 DB BASE+268-$ DUP 0
