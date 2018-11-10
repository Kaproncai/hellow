; Hello world! windows console application by TomCat/Abaddon

FORMAT BINARY AS 'exe'
 DW 'MZ'       ; 00.e_magic
 DW ?          ; 02.e_cblp
 DD 'PE'       ; 04.Signature
 DW 014CH      ; 08.Machine
 DW 0          ; 0A.NumberOfSections
 DD ?          ; 0C.TimeDateStamp
 DD ?          ; 10.PointerToSymbolTable
 DD ?          ; 14.NumberOfSymbols
 DW 8          ; 18.SizeOfOptionalHeader
 DW 2          ; 1A.Characteristics IMAGE_FILE_EXECUTABLE_IMAGE&!IMAGE_FILE_DLL
 DW 010BH      ; 1C.Magic
 DB ?          ; 1E.MajorLinkerVersion
 DB ?          ; 1F.MinorLinkerVersion
 DD ?          ; 20.SizeOfCode
 DD ?          ; 24.SizeOfInitializedData
 DD ?          ; 28.SizeOfUninitializedData
 DD start      ; 2C.AddressOfEntryPoint
 DD ?          ; 30.BaseOfCode
 DD ?          ; 34.BaseOfData
 DD 00400000H  ; 38.ImageBase
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
 DD 30H        ; 58.SizeOfHeaders
 DD ?          ; 5C.CheckSum
 DW 3          ; 60.Subsystem 3->console 2->gui
 DW 0          ; 62.DllCharacteristics
 DD ?          ; 64.SizeOfStackReserve
 DD ?          ; 68.SizeOfStackCommit
 DD ?          ; 6C.SizeOfHeapReserve
 DD ?          ; 70.SizeOfHeapCommit
 DD ?          ; 74.LoaderFlags
 DD 0          ; 78.NumberOfRvaAndSizes
 DQ ?,?,?,?,?,?; 7C.DataDirectory
 DD ?          ; AC.Debug.RVA
 DD 0          ; B0.Debug.Size

start:
RETN

ALIGN 256
 DD ?,?,0
