From: eof <eof@free.fr>
Subject: PROBLEM LOADING scsi module aic7xxx with ATI RADEON card
Date: Tue, 13 Jan 2004 00:23:42 +0100
Sender: cooker-owner@linux-mandrake.com
Message-ID: <40032C7E.3070200@free.fr>
Reply-To: cooker@linux-mandrake.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <cooker-owner@linux-mandrake.com>
To: linux-scsi@vger.kernel.org
Cc: submit@bugs.debian.org, cooker@linux-mandrake.com
List-Id: linux-scsi@vger.kernel.org

Hello,

On boot the SCSI module aic7xxx won't load and the system freezes with 
my new ATI Radeon 9700Pro card.  There were no conflicts with my old 
Nvidia GeForce 4 card.

I haved tried with the following kernels :

        * Mandrake kernel-2.4.22-21mdk
        * Mandrake kernel-2.4.21-0.18mdk
        * Debian kernel-2.4.22-1-386 (testing)

Even Mandrake's installation CD (9.2) will freeze while loading this 
module (which makes installation impossible with the Adaptec card in the 
PC).

The only way to have everything working is to have the driver compiled 
in the kernel, not as a module, then everything is fine :

Jan 12 19:46:30 hds kernel: SCSI subsystem driver Revision: 1.00
Jan 12 19:46:30 hds kernel: scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI 
HBA DRIVER, Rev 6.2.36
Jan 12 19:46:30 hds kernel:         <Adaptec 19160B Ultra160 SCSI adapter>
Jan 12 19:46:30 hds kernel:         aic7892: Ultra160 Wide Channel A, 
SCSI Id=7, 32/253 SCBs
Jan 12 19:46:30 hds kernel:
Jan 12 19:46:30 hds kernel: (scsi0:A:3): 5.000MB/s transfers (5.000MHz, 
offset 7)
Jan 12 19:46:30 hds kernel:   Vendor: YAMAHA    Model: CRW2100S          
Rev: 1.0H
Jan 12 19:46:30 hds kernel:   Type:   CD-ROM                             
ANSI SCSI revision: 02

My hardware :

        * Asus AZN8X Deluxe Rev 1.6 motherboard - nforce2 - bios updated
          to 'D1007'.
        * Athlon XP 2200+
        * ATI Radeon 9700Pro (Chip RN300 ND - Rev A13) (card made by ATI
          - "PowerColor")
        * Adaptec 19160B Ultra160 SCSI (Adaptec AIC-7892B U160/m (rev 02))

Other system stuff :
[root@hds root]# lspci -vvv
00:00.0 Host bridge: nVidia Corporation nForce2 AGP (different version?) 
(rev a2)
    Subsystem: Asustek Computer, Inc.: Unknown device 80ac
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Region 0: Memory at e0000000 (32-bit, prefetchable) [size=64M]
    Capabilities: [40] AGP version 3.0
        Status: RQ=32 Iso- ArqSz=2 Cal=0 SBA+ ITACoh- GART64- HTrans- 
64bit- FW+ AGP3+ Rate=x4,x8
        Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW+ Rate=x8
    Capabilities: [60] #08 [2001]

00:00.1 RAM memory: nVidia Corporation nForce2 Memory Controller 1 (rev a2)
    Subsystem: Asustek Computer, Inc.: Unknown device 80ac
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-

00:00.2 RAM memory: nVidia Corporation nForce2 Memory Controller 4 (rev a2)
    Subsystem: Asustek Computer, Inc.: Unknown device 80ac
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-

00:00.3 RAM memory: nVidia Corporation nForce2 Memory Controller 3 (rev a2)
    Subsystem: Asustek Computer, Inc.: Unknown device 80ac
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-

00:00.4 RAM memory: nVidia Corporation nForce2 Memory Controller 2 (rev a2)
    Subsystem: Asustek Computer, Inc.: Unknown device 80ac
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-

00:00.5 RAM memory: nVidia Corporation nForce2 Memory Controller 5 (rev a2)
    Subsystem: Asustek Computer, Inc.: Unknown device 80ac
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-

00:01.0 ISA bridge: nVidia Corporation nForce2 ISA Bridge (rev a3)
    Subsystem: Asustek Computer, Inc. A7N8X Mainboard
    Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Capabilities: [48] #08 [01e1]

00:01.1 SMBus: nVidia Corporation nForce2 SMBus (MCP) (rev a2)
    Subsystem: Asustek Computer, Inc.: Unknown device 0c11
    Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Interrupt: pin A routed to IRQ 12
    Region 0: I/O ports at d800 [size=32]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.0 USB Controller: nVidia Corporation nForce2 USB Controller (rev 
a3) (prog-if 10 [OHCI])
    Subsystem: Asustek Computer, Inc. A7N8X Mainboard
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0 (750ns min, 250ns max)
    Interrupt: pin A routed to IRQ 10
    Region 0: Memory at ea085000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 USB Controller: nVidia Corporation nForce2 USB Controller (rev 
a3) (prog-if 10 [OHCI])
    Subsystem: Asustek Computer, Inc. A7N8X Mainboard
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0 (750ns min, 250ns max)
    Interrupt: pin B routed to IRQ 10
    Region 0: Memory at ea081000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.2 USB Controller: nVidia Corporation nForce2 USB Controller (rev 
a3) (prog-if 20 [EHCI])
    Subsystem: Asustek Computer, Inc. A7N8X Mainboard
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0 (750ns min, 250ns max)
    Interrupt: pin C routed to IRQ 11
    Region 0: Memory at ea082000 (32-bit, non-prefetchable) [size=256]
    Capabilities: [44] #0a [2080]
    Capabilities: [80] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:05.0 Multimedia audio controller: nVidia Corporation nForce 
MultiMedia audio [Via VT82C686B] (rev a2)
    Subsystem: Asustek Computer, Inc.: Unknown device 0c11
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0 (250ns min, 3000ns max)
    Interrupt: pin A routed to IRQ 10
    Region 0: Memory at ea000000 (32-bit, non-prefetchable) [size=512K]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:06.0 Multimedia audio controller: nVidia Corporation nForce2 AC97 
Audio Controler (MCP) (rev a1)
    Subsystem: Asustek Computer, Inc.: Unknown device 8095
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0 (500ns min, 1250ns max)
    Interrupt: pin A routed to IRQ 11
    Region 0: I/O ports at dc00 [size=256]
    Region 1: I/O ports at e000 [size=128]
    Region 2: Memory at ea086000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:08.0 PCI bridge: nVidia Corporation nForce2 External PCI Bridge (rev 
a3) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
    Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
    I/O behind bridge: 0000a000-0000afff
    Memory behind bridge: e8000000-e9ffffff
    Prefetchable memory behind bridge: fff00000-000fffff
    BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:09.0 IDE interface: nVidia Corporation nForce2 IDE (rev a2) (prog-if 
8a [Master SecP PriP])
    Subsystem: Asustek Computer, Inc.: Unknown device 0c11
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0 (750ns min, 250ns max)
    Region 4: I/O ports at f000 [size=16]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0c.0 PCI bridge: nVidia Corporation nForce2 PCI Bridge (rev a3) 
(prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
    Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
    I/O behind bridge: 0000b000-0000bfff
    Memory behind bridge: e4000000-e5ffffff
    Prefetchable memory behind bridge: fff00000-000fffff
    BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:0d.0 FireWire (IEEE 1394): nVidia Corporation nForce2 FireWire (IEEE 
1394) Controller (rev a3) (prog-if 10 [OHCI])
    Subsystem: Asustek Computer, Inc.: Unknown device 809a
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0 (750ns min, 250ns max)
    Interrupt: pin A routed to IRQ 12
    Region 0: Memory at ea083000 (32-bit, non-prefetchable) [size=2K]
    Region 1: Memory at ea084000 (32-bit, non-prefetchable) [size=64]
    Capabilities: [44] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1e.0 PCI bridge: nVidia Corporation nForce2 AGP (rev a2) (prog-if 00 
[Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
    Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 32
    Bus: primary=00, secondary=03, subordinate=03, sec-latency=32
    I/O behind bridge: 0000c000-0000cfff
    Memory behind bridge: e6000000-e7ffffff
    Prefetchable memory behind bridge: d0000000-dfffffff
    BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-

01:0a.0 SCSI storage controller: Adaptec AIC-7892B U160/m (rev 02)
    Subsystem: Adaptec 19160 Ultra160 SCSI Controller
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 32 (10000ns min, 6250ns max), cache line size 08
    Interrupt: pin A routed to IRQ 11
    BIST result: 00
    Region 0: I/O ports at a000 [disabled] [size=256]
    Region 1: Memory at e9000000 (64-bit, non-prefetchable) [size=4K]
    Expansion ROM at <unassigned> [disabled] [size=128K]
    Capabilities: [dc] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:01.0 Ethernet controller: 3Com Corporation 3C920B-EMB Integrated Fast 
Ethernet Controller (rev 40)
    Subsystem: Asustek Computer, Inc.: Unknown device 80ab
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 32 (2500ns min, 2500ns max), cache line size 08
    Interrupt: pin A routed to IRQ 10
    Region 0: I/O ports at b000 [size=128]
    Region 1: Memory at e5000000 (32-bit, non-prefetchable) [size=128]
    Expansion ROM at <unassigned> [disabled] [size=128K]
    Capabilities: [dc] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=2 PME-

03:00.0 VGA compatible controller: ATI Technologies Inc Radeon R300 ND 
[Radeon 9700 Pro] (prog-if 00 [VGA])
    Subsystem: ATI Technologies Inc: Unknown device 0002
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping+ SERR- FastB2B-
    Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 255 (2000ns min), cache line size 08
    Interrupt: pin A routed to IRQ 12
    Region 0: Memory at d0000000 (32-bit, prefetchable) [size=128M]
    Region 1: I/O ports at c000 [size=256]
    Region 2: Memory at e7000000 (32-bit, non-prefetchable) [size=64K]
    Expansion ROM at <unassigned> [disabled] [size=128K]
    Capabilities: [58] AGP version 3.0
        Status: RQ=256 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 
64bit- FW+ AGP3+ Rate=x4,x8
        Command: RQ=32 ArqSz=2 Cal=0 SBA+ AGP+ GART64- 64bit- FW+ Rate=x8
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

03:00.1 Display controller: ATI Technologies Inc Radeon R300 [Radeon 
9700 Pro] (Secondary)
    Subsystem: ATI Technologies Inc: Unknown device 0003
    Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping+ SERR- FastB2B-
    Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Region 0: Memory at d8000000 (32-bit, prefetchable) [disabled] 
[size=128M]
    Region 1: Memory at e7010000 (32-bit, non-prefetchable) [disabled] 
[size=64K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-

[root@hds root]# cat /proc/scsi/aic7xxx/0 
Adaptec AIC7xxx driver version: 6.2.36
Adaptec 19160B Ultra160 SCSI adapter
aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
Allocated SCBs: 5, SG List Length: 102

Serial EEPROM:
0xc3bd 0xc33a 0xc33a 0xc3f8 0xc33a 0xc33a 0xc33a 0xc33a 
0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 
0xb8f4 0x6c5d 0x2807 0x0010 0xffff 0xffff 0xffff 0xffff 
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0250 0x8493 

Target 0 Negotiation Settings
        User: 40.000MB/s transfers (20.000MHz DT, offset 127, 16bit)
Target 1 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 2 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 3 Negotiation Settings
        User: 10.000MB/s transfers (5.000MHz, offset 127, 16bit)
        Goal: 5.000MB/s transfers (5.000MHz, offset 7)
        Curr: 5.000MB/s transfers (5.000MHz, offset 7)
        Channel A Target 3 Lun 0 Settings
                Commands Queued 23
                Commands Active 0
                Command Openings 1
                Max Tagged Openings 0
                Device Queue Frozen Count 0
Target 4 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 5 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 6 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 7 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 8 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 9 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 10 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 11 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 12 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 13 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 14 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 15 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)

[root@hds root]# cat /proc/cpuinfo       
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 8
model name      : AMD Athlon(tm) XP 2200+
stepping        : 0
cpu MHz         : 1797.280
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow
bogomips        : 3578.26

If I can be of any help in doing other tests, please let me know.


Hermon DAVIS

P.S I'm in Southern France, just in case you should wonder... :-)
