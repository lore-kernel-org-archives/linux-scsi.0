From: Federico Petronio <fpetronio@activesec.biz>
Subject: Error in SCSI module for Adaptec 29320A
Date: Fri, 08 Jun 2007 23:04:32 -0300
Message-ID: <466A0AB0.8060308@activesec.biz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avas-mr13.fibertel.com.ar ([24.232.0.197]:52016 "EHLO
	avas-mr13.fibertel.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbXFICNU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jun 2007 22:13:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

Hello James,

I write to you since you appear as the maintainer for the SCSI subsystem
of the 2.6.x kernel. This is a report for a, possible, bug or hardware
error. I would be grateful if you can help me figure out if it's a bug
or a hardware error.

Best regards,
------

Report Information:

Problem:
"Access to SCSI hard drive stoped working"

Full Decription:

"I have a server running Linux Debian 4 full patched that stopped
responding to logins today. It also showed an errors like:

*Warning*: session_start() [function.session-start
<https://mabidp.interservices.com.ar/event_viewer/function.session-start>]:
open(/var/lib/php5/sess_08d15059b3565084c88a2493cccd29bd, O_RDWR)
failed: Read-only file system (30) in
*/usr/local/MABSEM/event_viewer/alerts_session.inc.php* on line *5*

when trying to access to the webserver. There were no way to access to
the system, event the consoles did not responded after typing the
username, so I needed to power off the system. Afterwards in the logs I
found an error related to SCSI (the error continue to appear but the
system is working fine). Could you please tell me what could be the
cause of this error and if it is the cause of the system failure?"

Keywords: SCSI access error RO filesystem

Mother Gigabyte GA-7DPXDW+

Mem: 1Gb DDR266 REG ECC1024M

SCSI Adapter: Adapter 29320A

uname -a:
Linux mabidpconsole 2.6.18-4-k7 #1 SMP Wed May 9 23:42:01 UTC 2007 i686
GNU/Linux

Error Message (from dmesg):

EXT3-fs: mounted filesystem with ordered data mode.
scsi0: Transmission error detected
LQISTAT1[0x8]:(LQICRCI_NLQ) LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE)
SCSISIGI[0xa0]:(P_MESGOUT) PERRDIAG[0x24]:(CRCERR|PREVPHASE)
>>>>>>>>>>>>>>>>>>
Dump Card State Begins
<<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x31 Mode 0x11
Card was paused
INTSTAT[0x8]:(SCSIINT) SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0]
INTCTL[0x80]:(SWTMINTMASK) SEQINTSTAT[0x0] SAVED_MODE[0x11]
DFFSTAT[0x24]:(CURRFIFO_0|FIFO1FREE)
SCSISIGI[0xb6]:(P_MESGOUT|REQI|BSYI|ATNI)
SCSIPHASE[0x4]:(MSG_OUT_PHASE) SCSIBUS[0xf7]
LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE)
SCSISEQ0[0x0] SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI)
SEQCTL0[0x0] SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0]
QFREEZE_COUNT[0x1] KERNEL_QFREEZE_COUNT[0x1] MK_MESSAGE_SCB[0xff00]
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x2]:(SPIORDY)
SSTAT1[0x11]:(REQINIT|PHASEMIS)
SSTAT2[0x20]:(NONPACKREQ) SSTAT3[0x0] PERRDIAG[0x0]
SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0xc0]:(LQIPHASE_OUTPKT|PACKETIZED)
LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0xe1]:(LQOSTOP0|LQOPKT)

SCB Count = 32 CMDS_PENDING = 1 LASTSCB 0xb CURRSCB 0xb NEXTSCB 0xff00
qinstart = 1271 qinfifonext = 1271
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
 11 FIFO_USE[0x1] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7]
Total 1
Kernel Free SCB list: 16 27 29 15 25 17 23 3 10 9 8 13 24 14 2 30 5 1 20
19 26 7 18 0 6 28 31 21 4 22 12
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
Sequencer On QFreeze and Complete list:


scsi0: FIFO0 Active, LONGJMP == 0x24c, SCB 0xb
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS)
SEQINTSRC[0x0] DFCNTRL[0x8]:(HDMAEN)
DFSTATUS[0xc8]:(HDONE|PKT_PRELOAD_AVAIL|PRELOAD_AVAIL)
SG_CACHE_SHADOW[0x30] SG_STATE[0x3]:(SEGS_AVAIL|LOADING_NEEDED)
DFFSXFRCTL[0x0] SOFFCNT[0x0]
MDFFSTAT[0x46]:(DATAINFIFO|DLZERO|SHCNTNEGATIVE)
SHADDR = 0x03f32c200, SHCNT = 0xfffe00 HADDR = 0x03f32c000, HCNT = 0x0
CCSGCTL[0x10]:(SG_CACHE_AVAIL)

scsi0: FIFO1 Free, LONGJMP == 0x8063, SCB 0x3
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEPTRS)
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x0]
LQIN: 0x5 0x0 0x0 0xb 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x72 0x0
0x0 0x0 0x2 0x0
scsi0: LQISTATE = 0x2b, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc]:(ENOVERRUN|ENIOERR)
CCSCBCTL[0x4]:(CCSCBDIR)
scsi0: REG0 == 0x3, SINDEX = 0x130, DINDEX = 0x102
scsi0: SCBPTR == 0x3, SCB_NEXT == 0xffc0, SCB_NEXT2 == 0xfff1
CDB 0 14 0 80 10 c
STACK: 0x1f 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<<
Dump Card State Ends
>>>>>>>>>>>>>>>>>>
LQICRC_NLQ
LQIRETRY for LQIPHASE_OUTPKT
scsi0: Returning to Idle Loop
scsi0: device overrun (status a) on 0:0:0

cat /proc/modules:
xt_state 2560 46 - Live 0xf8b67000
xt_tcpudp 3456 52 - Live 0xf8b54000
ipt_LOG 6464 3 - Live 0xf8b80000
iptable_nat 7428 1 - Live 0xf8b7d000
ip_nat 17260 1 iptable_nat, Live 0xf8b77000
ip_conntrack 49504 3 xt_state,iptable_nat,ip_nat, Live 0xf8b87000
nfnetlink 7128 2 ip_nat,ip_conntrack, Live 0xf8b74000
iptable_filter 3392 1 - Live 0xf899c000
ip_tables 13476 2 iptable_nat,iptable_filter, Live 0xf8b6f000
x_tables 13636 5 xt_state,xt_tcpudp,ipt_LOG,iptable_nat,ip_tables, Live
0xf8b6a000
button 6928 0 - Live 0xf8b45000
ac 5508 0 - Live 0xf8b48000
battery 9924 0 - Live 0xf8b50000
ipv6 228064 24 - Live 0xf8ba9000
dm_snapshot 15904 0 - Live 0xf8b4b000
dm_mirror 19600 0 - Live 0xf89bf000
dm_mod 50776 2 dm_snapshot,dm_mirror, Live 0xf8b56000
loop 15496 0 - Live 0xf89c5000
amd_rng 3268 0 - Live 0xf8845000
psmouse 35336 0 - Live 0xf89cb000
i2c_amd756 6596 0 - Live 0xf8996000
amd76x_edac 4224 0 - Live 0xf8999000
shpchp 33312 0 - Live 0xf89ab000
pci_hotplug 29056 1 shpchp, Live 0xf89b6000
i2c_core 20096 1 i2c_amd756, Live 0xf89a5000
edac_mc 21008 1 amd76x_edac, Live 0xf899e000
serio_raw 6980 0 - Live 0xf8840000
amd_k7_agp 8908 1 - Live 0xf88f0000
agpgart 30216 1 amd_k7_agp, Live 0xf88d9000
evdev 9408 0 - Live 0xf88d5000
rtc 12788 0 - Live 0xf88d0000
pcspkr 3392 0 - Live 0xf8843000
ext3 120584 2 - Live 0xf8962000
jbd 52968 1 ext3, Live 0xf88e2000
mbcache 8644 1 ext3, Live 0xf8880000
sd_mod 19456 4 - Live 0xf8887000
3c59x 40808 0 - Live 0xf886b000
e100 32904 0 - Live 0xf8876000
ohci_hcd 18564 0 - Live 0xf8847000
mii 5696 2 3c59x,e100, Live 0xf883d000
usbcore 113412 2 ohci_hcd, Live 0xf88b3000
aic79xx 241748 3 - Live 0xf8901000
scsi_transport_spi 22656 1 aic79xx, Live 0xf8836000
scsi_mod 124872 3 sd_mod,aic79xx,scsi_transport_spi, Live 0xf8893000
amd74xx 13340 0 [permanent], Live 0xf8831000
generic 5764 0 [permanent], Live 0xf8802000
ide_core 110984 2 amd74xx,generic, Live 0xf884e000
thermal 13896 0 - Live 0xf882c000
processor 29128 1 thermal, Live 0xf8823000
fan 5124 0 - Live 0xf8805000

cat /proc/cpuinfo:
processor : 0
vendor_id : AuthenticAMD
cpu family : 6
model : 10
model name : AMD Athlon(tm) MP 2600+
stepping : 0
cpu MHz : 2000.120
cache size : 512 KB
fdiv_bug : no
hlt_bug : no
f00f_bug : no
coma_bug : no
fpu : yes
fpu_exception : yes
cpuid level : 1
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow ts
bogomips : 4004.21

processor : 1
vendor_id : AuthenticAMD
cpu family : 6
model : 10
model name : AMD Athlon(tm) MP
stepping : 0
cpu MHz : 2000.120
cache size : 512 KB
fdiv_bug : no
hlt_bug : no
f00f_bug : no
coma_bug : no
fpu : yes
fpu_exception : yes
cpuid level : 1
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow ts
bogomips : 4000.53

cat /proc/ioports /proc/iomem:
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
03c0-03df : vga+
03f8-03ff : serial
0cf8-0cff : PCI conf1
5000-5003 : ACPI PM1a_EVT_BLK
5004-5005 : ACPI PM1a_CNT_BLK
5008-500b : ACPI PM_TMR
5020-5023 : ACPI GPE0_BLK
50e0-50ef : amd756_smbus
c000-cfff : PCI Bus #02
c000-c0ff : 0000:02:04.0
c400-c47f : 0000:02:06.0
c800-c83f : 0000:02:07.0
c800-c83f : e100
e000-e0ff : 0000:00:09.0
e400-e4ff : 0000:00:09.0
e800-e803 : 0000:00:00.0
f000-f00f : 0000:00:07.1
00000000-0009fbff : System RAM
00000000-00000000 : Crash kernel
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cbfff : Video ROM
000cc000-000d5bff : Adapter ROM
000f0000-000fffff : System ROM
00100000-3ffeffff : System RAM
00100000-00285675 : Kernel code
00285676-00316b53 : Kernel data
3fff0000-3fff2fff : ACPI Non-volatile Storage
3fff3000-3fffffff : ACPI Tables
50000000-500fffff : PCI Bus #02
50000000-5001ffff : 0000:02:04.0
50020000-5003ffff : 0000:02:06.0
50040000-5004ffff : 0000:02:07.0
50100000-5017ffff : 0000:00:09.0
f0000000-f7ffffff : 0000:00:00.0
f9000000-fbffffff : PCI Bus #02
f9000000-f9ffffff : 0000:02:04.0
fb000000-fb01ffff : 0000:02:07.0
fb000000-fb01ffff : e100
fb020000-fb020fff : 0000:02:00.0
fb020000-fb020fff : ohci_hcd
fb021000-fb02107f : 0000:02:06.0
fb022000-fb022fff : 0000:02:07.0
fb022000-fb022fff : e100
fb023000-fb023fff : 0000:02:04.0
fc000000-fc001fff : 0000:00:09.0
fc000000-fc000fff : aic79xx
fc002000-fc002fff : 0000:00:00.0
fec00000-ffffffff : reserved

lspci -vvv:
00:00.0 Host bridge: Advanced Micro Devices [AMD] AMD-760 MP [IGD4-2P]
System Controller (rev 20)
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- SERR-
Latency: 32
Region 0: Memory at f0000000 (32-bit, prefetchable) [size=128M]
Region 1: Memory at fc002000 (32-bit, prefetchable) [size=4K]
Region 2: I/O ports at e800 [disabled] [size=4]
Capabilities: [a0] AGP version 2.0
Status: RQ=16 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW-
AGP3- Rate=x1,x2
Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP- GART64- 64bit- FW- Rate=

00:01.0 PCI bridge: Advanced Micro Devices [AMD] AMD-760 MP [IGD4-2P]
AGP Bridge (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- SERR-
Latency: 32
Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fff00000-000fffff
Prefetchable memory behind bridge: fff00000-000fffff
Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort-
BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-

00:07.0 ISA bridge: Advanced Micro Devices [AMD] AMD-768 [Opus] ISA (rev 05)
Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- SERR-
Latency: 0

00:07.1 IDE interface: Advanced Micro Devices [AMD] AMD-768 [Opus] IDE
(rev 04) (prog-if 8a [Master SecP PriP])
Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- SERR-
Latency: 32
Region 4: I/O ports at f000 [size=16]

00:07.3 Bridge: Advanced Micro Devices [AMD] AMD-768 [Opus] ACPI (rev 03)
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- SERR-

00:09.0 SCSI storage controller: Adaptec ASC-29320A U320 (rev 10)
Subsystem: Adaptec Unknown device 0060
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- SERR-
Latency: 32 (10000ns min, 6250ns max), Cache Line Size: 32 bytes
Interrupt: pin A routed to IRQ 169
Region 0: I/O ports at e000 [disabled] [size=256]
Region 1: Memory at fc000000 (64-bit, non-prefetchable) [size=8K]
Region 3: I/O ports at e400 [disabled] [size=256]
[virtual] Expansion ROM at 50100000 [disabled] [size=512K]
Capabilities: [dc] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1
Enable-
Address: 0000000000000000 Data: 0000
Capabilities: [94] PCI-X non-bridge device
Command: DPERE- ERO+ RBC=512 OST=8
Status: Dev=00:00.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=512
DMOST=8 DMCRS=16 RSCEM- 266MHz- 533MHz-

00:10.0 PCI bridge: Advanced Micro Devices [AMD] AMD-768 [Opus] PCI (rev
05) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- SERR-
Latency: 32
Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
I/O behind bridge: 0000c000-0000cfff
Memory behind bridge: f9000000-fbffffff
Prefetchable memory behind bridge: 50000000-500fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort-
BridgeCtl: Parity- SERR+ NoISA+ VGA+ MAbort- >Reset- FastB2B-

02:00.0 USB Controller: Advanced Micro Devices [AMD] AMD-768 [Opus] USB
(rev 07) (prog-if 10 [OHCI])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- SERR-
Latency: 32 (20000ns max), Cache Line Size: 32 bytes
Interrupt: pin D routed to IRQ 177
Region 0: Memory at fb020000 (32-bit, non-prefetchable) [size=4K]

02:04.0 VGA compatible controller: ATI Technologies Inc 3D Rage I/II
215GT [Mach64 GT] (rev 41) (prog-if 00 [VGA])
Subsystem: ATI Technologies Inc 3D Rage I/II 215GT [Mach64 GT]
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping+ SERR- FastB2B-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- SERR-
Latency: 32 (2000ns min), Cache Line Size: 32 bytes
Region 0: Memory at f9000000 (32-bit, non-prefetchable) [size=16M]
Region 1: I/O ports at c000 [size=256]
Region 2: Memory at fb023000 (32-bit, non-prefetchable) [size=4K]
[virtual] Expansion ROM at 50000000 [disabled] [size=128K]

02:06.0 Ethernet controller: 3Com Corporation 3cSOHO100-TX Hurricane
(rev 30)
Subsystem: 3Com Corporation 3cSOHO100-TX Hurricane
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- SERR-
Latency: 32 (2500ns min, 2500ns max), Cache Line Size: 32 bytes
Interrupt: pin A routed to IRQ 193
Region 0: I/O ports at c400 [size=128]
Region 1: Memory at fb021000 (32-bit, non-prefetchable) [size=128]
[virtual] Expansion ROM at 50020000 [disabled] [size=128K]
Capabilities: [dc] Power Management version 1
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:07.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro
100] (rev 0d)
Subsystem: Intel Corporation EtherExpress PRO/100 Server Adapter
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- SERR-
Latency: 32 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
Interrupt: pin A routed to IRQ 185
Region 0: Memory at fb022000 (32-bit, non-prefetchable) [size=4K]
Region 1: I/O ports at c800 [size=64]
Region 2: Memory at fb000000 (32-bit, non-prefetchable) [size=128K]
[virtual] Expansion ROM at 50040000 [disabled] [size=64K]
Capabilities: [dc] Power Management version 2
Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 PME-Enable- DSel=0 DScale=2 PME-

cat /proc/scsi/scsi:
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
Vendor: SEAGATE Model: ST373207LW Rev: 0005
Type: Direct-Access ANSI SCSI revision: 03

-- 
                                        Federico Petronio
                                        fpetronio@activesec.biz
                                        Linux User #129974

---
There are only 10 types of people in the world:
              Those who understand binary and those who don't.



