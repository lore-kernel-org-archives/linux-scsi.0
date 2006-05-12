From: Gabriel Gomiz <gomita@cooperativaobrera.com.ar>
Subject: Symbios-NCR 6285-3621 + Adaptec 2944W multilun problem
Date: Fri, 12 May 2006 10:29:00 -0300
Message-ID: <44648D9C.2090602@cooperativaobrera.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 200-26-107-84.advance.com.ar ([200.26.107.84]:11671 "EHLO
	thorin.cooperativaobrera.com.ar") by vger.kernel.org with ESMTP
	id S1751280AbWELN3H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 09:29:07 -0400
Received: from morgoth.srv.sis.cooperativaobrera.com.ar (morgoth.srv.sis.cooperativaobrera.com.ar [192.168.238.8])
	by thorin.cooperativaobrera.com.ar (8.13.1/8.13.1) with ESMTP id k4CDT8h5023310
	for <linux-scsi@vger.kernel.org>; Fri, 12 May 2006 10:29:08 -0300
Received: from [192.168.0.12] (ggomiz.des.sis.cooperativaobrera.com.ar [192.168.0.12])
	by morgoth.srv.sis.cooperativaobrera.com.ar (8.11.6/8.11.6) with ESMTP id k4CDT1t27337
	for <linux-scsi@vger.kernel.org>; Fri, 12 May 2006 10:29:01 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello all people at linux-scsi! I'm writing this report because I've 
exhausted my options with this issue and cannot find any viable solution. :(

[1.] One line summary of the problem:

Problem accessing Symbios-NCR 6285-3621 multilun device via Adaptec 
2944W (aic7xxx) HBA.

[2.] Full description of the problem/report:

When configuring 2.6.16.13 kernel scsi subsystem with multilun support, 
I'm trying to access a Symbios 6285-3621 Array via an Adaptec 2944W HBA 
with aic7xxx module. All scsi "virtual devices" are recognized 
sdc-sdd-sde-sdf-sdg-sdh-sdi but then when the kernel tries to detect the 
partition tables it gets a lot of "Buffer I/O errors".

The same hardware configuration was working on production as our 
database servers until last month with Solaris 7 and Informix IDS 
without any problem for at least 5 years, solid. We're now in the 
process of migration of this servers to Red Hat Enterprise Linux.

The same issue was triggered with RHEL 4 AS stock up-to-date kernel 
(2.6.9-34EL).

[3.] Keywords (i.e., modules, networking, kernel):

SCSI. Symbios. NCR. 6285-3621. Adaptec 2944W. aic7xxx. I/O Errors. 
Multilun. Red Hat EL 4.

[4.] Kernel version (from /proc/version):

Linux version 2.6.16.13 (root@galadriel.cooperativaobrera.com.ar) (gcc 
version 3.4.5 20051201 (Red Hat 3.4.5-2)) #2 SMP Thu May 4 18:35:29 ART 2006

[5.] Output of Oops.. message (if applicable)

Not aplicable.

[6.] A small shell script or example program which triggers the
      problem (if possible)

Booting the system triggers the problem.

[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
[7.2.] Processor information (from /proc/cpuinfo):

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 7
model name      : Pentium III (Katmai)
stepping        : 3
cpu MHz         : 550.250
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 mmx fxsr sse
bogomips        : 1102.51

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 7
model name      : Pentium III (Katmai)
stepping        : 3
cpu MHz         : 550.250
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 mmx fxsr sse
bogomips        : 1100.46

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 7
model name      : Pentium III (Katmai)
stepping        : 3
cpu MHz         : 550.250
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 mmx fxsr sse
bogomips        : 1100.45

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 7
model name      : Pentium III (Katmai)
stepping        : 3
cpu MHz         : 550.250
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 mmx fxsr sse
bogomips        : 1100.48

[7.3.] Module information (from /proc/modules):

nfs 206572 1 - Live 0xf8aaf000
lockd 60296 2 nfs, Live 0xf8a77000
nfs_acl 7808 1 nfs, Live 0xf8904000
ipv6 248544 20 - Live 0xf8a39000
autofs4 23044 1 - Live 0xf8aa8000
sunrpc 142012 4 nfs,lockd,nfs_acl, Live 0xf8c12000
e100 37636 0 - Live 0xf88f3000
mii 9600 1 e100, Live 0xf88ad000
floppy 61124 0 - Live 0xf88e3000
piix 13956 0 [permanent], Live 0xf8869000
sr_mod 20772 0 - Live 0xf88a6000
sg 38044 0 - Live 0xf889b000
dm_snapshot 20524 0 - Live 0xf8894000
dm_zero 6016 0 - Live 0xf8833000
dm_mirror 24784 0 - Live 0xf885a000
ext3 122888 4 - Live 0xf8908000
jbd 57492 1 ext3, Live 0xf88d3000
raid1 24576 2 - Live 0xf8862000
dm_mod 56856 8 dm_snapshot,dm_zero,dm_mirror, Live 0xf8885000
aic7xxx 134580 0 - Live 0xf88b1000
sym53c8xx 75540 4 - Live 0xf8871000
scsi_transport_spi 24960 2 aic7xxx,sym53c8xx, Live 0xf8826000
sd_mod 20608 6 - Live 0xf8816000
scsi_mod 131624 6 sr_mod,sg,aic7xxx,sym53c8xx,scsi_transport_spi,sd_mod, 
Live 0xf8838000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

/proc/ioports

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
0c00-0c3f : 0000:00:0c.3
0cc0-0ccf : 0000:00:0c.3
0cf8-0cff : PCI conf1
2000-20ff : 0000:00:08.0
   2000-20ff : sym53c8xx
2400-243f : 0000:00:06.0
   2400-243f : e100
2440-247f : 0000:00:07.0
   2440-247f : e100
2480-249f : 0000:00:0c.2
24a0-24af : 0000:00:0c.1
   24a0-24a7 : ide0
3000-30ff : 0000:01:03.0
   3000-30ff : sym53c8xx
3400-34ff : 0000:01:03.1
   3400-34ff : sym53c8xx
3800-38ff : 0000:01:05.0

/proc/iomem

00000000-0009d7ff : System RAM
0009d800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000c8000-000c97ff : Adapter ROM
000c9800-000cafff : Adapter ROM
000cb000-000cefff : Adapter ROM
000cf000-000cf7ff : Adapter ROM
000d8000-000dbfff : Adapter ROM
000f0000-000fffff : System ROM
00100000-f9efa7ff : System RAM
   00100000-00292ed7 : Kernel code
   00292ed8-0033cac3 : Kernel data
f9efa800-f9effbff : ACPI Tables
f9effc00-f9efffff : ACPI Non-volatile Storage
fa000000-fa0fffff : 0000:00:06.0
   fa000000-fa0fffff : e100
fa100000-fa1fffff : 0000:00:07.0
   fa100000-fa1fffff : e100
fa200000-fa200fff : 0000:00:06.0
   fa200000-fa200fff : e100
fa201000-fa201fff : 0000:00:07.0
   fa201000-fa201fff : e100
fa202000-fa202fff : 0000:00:0a.0
fa203000-fa2030ff : 0000:00:08.0
   fa203000-fa2030ff : sym53c8xx
fa208000-fa20ffff : 0000:00:0a.0
fa210000-fa21ffff : 0000:01:05.0
fa300000-fa3fffff : 0000:00:06.0
fa400000-fa4fffff : 0000:00:07.0
fc000000-fdffffff : 0000:00:0a.0
fe000000-fe001fff : 0000:01:03.0
   fe000000-fe001fff : sym53c8xx
fe002000-fe003fff : 0000:01:03.1
   fe002000-fe003fff : sym53c8xx
fe004000-fe004fff : 0000:01:05.0
   fe004000-fe004fff : aic7xxx
fe005000-fe0053ff : 0000:01:03.0
   fe005000-fe0053ff : sym53c8xx
fe005400-fe0057ff : 0000:01:03.1
   fe005400-fe0057ff : sym53c8xx
fe300000-ffffffff : reserved

[7.5.] PCI information ('lspci -vvv' as root)

00:06.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 
100] (rev 08)
         Subsystem: Intel Corporation EtherExpress PRO/100+ Server 
Adapter (PILA8470B)
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 128 (2000ns min, 14000ns max), Cache Line Size 08
         Interrupt: pin A routed to IRQ 145
         Region 0: Memory at fa200000 (32-bit, non-prefetchable) [size=4K]
         Region 1: I/O ports at 2400 [size=64]
         Region 2: Memory at fa000000 (32-bit, non-prefetchable) [size=1M]
         [virtual] Expansion ROM at fa300000 [disabled] [size=1M]
         Capabilities: [dc] Power Management version 2
                 Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=2 PME-

00:07.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 
100] (rev 08)
         Subsystem: Intel Corporation EtherExpress PRO/100+ Server 
Adapter (PILA8470B)
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 128 (2000ns min, 14000ns max), Cache Line Size 08
         Interrupt: pin A routed to IRQ 153
         Region 0: Memory at fa201000 (32-bit, non-prefetchable) [size=4K]
         Region 1: I/O ports at 2440 [size=64]
         Region 2: Memory at fa100000 (32-bit, non-prefetchable) [size=1M]
         [virtual] Expansion ROM at fa400000 [disabled] [size=1M]
         Capabilities: [dc] Power Management version 2
                 Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=2 PME-

00:08.0 SCSI storage controller: LSI Logic / Symbios Logic 53c810 (rev 23)
         Subsystem: LSI Logic / Symbios Logic LSI53C810AE PCI to SCSI 
I/O Processor
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 128 (2000ns min, 16000ns max), Cache Line Size 08
         Interrupt: pin A routed to IRQ 193
         Region 0: I/O ports at 2000 [size=256]
         Region 1: Memory at fa203000 (32-bit, non-prefetchable) [size=256]
         Capabilities: [40] Power Management version 1
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0a.0 VGA compatible controller: Cirrus Logic GD 5480 (rev 23) 
(prog-if 00 [VGA])
         Subsystem: Unknown device 3e3e:003e
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (500ns min, 2500ns max)
         Region 0: Memory at fc000000 (32-bit, prefetchable) [size=32M]
         Region 1: Memory at fa202000 (32-bit, non-prefetchable) [size=4K]
         [virtual] Expansion ROM at fa208000 [disabled] [size=32K]

00:0b.0 PIC: Intel Corporation 683053 Programmable Interrupt Device 
(prog-if 03)
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0 (2000ns min, 2000ns max)

00:0c.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0

00:0c.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 
01) (prog-if 80 [Master])
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64
         Region 4: I/O ports at 24a0 [size=16]

00:0c.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 
01) (prog-if 00 [UHCI])
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64
         Interrupt: pin D routed to IRQ 169
         Region 4: I/O ports at 2480 [size=32]

00:0c.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Interrupt: pin ? routed to IRQ 9

00:10.0 Host bridge: Intel Corporation 450NX - 82451NX Memory & I/O 
Controller (rev 03)
         Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-

00:12.0 Host bridge: Intel Corporation 450NX - 82454NX/84460GX PCI 
Expander Bridge (rev 04)
         Subsystem: Intel Corporation 450NX - 82454NX/84460GX PCI 
Expander Bridge
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
         Latency: 128, Cache Line Size 08

00:13.0 Host bridge: Intel Corporation 450NX - 82454NX/84460GX PCI 
Expander Bridge (rev 04)
         Subsystem: Intel Corporation 450NX - 82454NX/84460GX PCI 
Expander Bridge
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
         Latency: 128, Cache Line Size 08

01:03.0 SCSI storage controller: LSI Logic / Symbios Logic 53C896/897 
(rev 01)
         Subsystem: LSI Logic / Symbios Logic LSI53C896/7 PCI to Dual 
Channel Ultra2 SCSI Multifunction Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 128 (4250ns min, 16000ns max), Cache Line Size 08
         Interrupt: pin A routed to IRQ 185
         Region 0: I/O ports at 3000 [size=256]
         Region 1: Memory at fe005000 (64-bit, non-prefetchable) [size=1K]
         Region 3: Memory at fe000000 (64-bit, non-prefetchable) [size=8K]
         Capabilities: [40] Power Management version 1
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:03.1 SCSI storage controller: LSI Logic / Symbios Logic 53C896/897 
(rev 01)
         Subsystem: LSI Logic / Symbios Logic LSI53C896/7 PCI to Dual 
Channel Ultra2 SCSI Multifunction Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 128 (4250ns min, 16000ns max), Cache Line Size 08
         Interrupt: pin B routed to IRQ 177
         Region 0: I/O ports at 3400 [size=256]
         Region 1: Memory at fe005400 (64-bit, non-prefetchable) [size=1K]
         Region 3: Memory at fe002000 (64-bit, non-prefetchable) [size=8K]
         Capabilities: [40] Power Management version 1
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:05.0 SCSI storage controller: Adaptec AHA-2944/2944W / AIC-7874 (rev 03)
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 128 (2000ns min, 2000ns max), Cache Line Size 08
         Interrupt: pin A routed to IRQ 161
         Region 0: I/O ports at 3800 [disabled] [size=256]
         Region 1: Memory at fe004000 (32-bit, non-prefetchable) [size=4K]
         [virtual] Expansion ROM at fa210000 [disabled] [size=64K]

[7.6.] SCSI information (from /proc/scsi/scsi)

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: SEAGATE  Model: ST318203LC       Rev: 0002
   Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 01 Lun: 00
   Vendor: SEAGATE  Model: ST318405LC       Rev: 5063
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 06 Lun: 00
   Vendor: ESG-SHV  Model: SCA HSBP M6      Rev: 0.61
   Type:   Processor                        ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 05 Lun: 00
   Vendor: TOSHIBA  Model: CD-ROM XM-6401TA Rev: 1012
   Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi3 Channel: 00 Id: 01 Lun: 00
   Vendor: SYMBIOS  Model: INF-01-00        Rev: 0205
   Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi3 Channel: 00 Id: 01 Lun: 01
   Vendor: SYMBIOS  Model: INF-01-00        Rev: 0205
   Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi3 Channel: 00 Id: 01 Lun: 02
   Vendor: SYMBIOS  Model: INF-01-00        Rev: 0205
   Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi3 Channel: 00 Id: 01 Lun: 03
   Vendor: SYMBIOS  Model: INF-01-00        Rev: 0205
   Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi3 Channel: 00 Id: 01 Lun: 04
   Vendor: SYMBIOS  Model: INF-01-00        Rev: 0205
   Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi3 Channel: 00 Id: 01 Lun: 05
   Vendor: SYMBIOS  Model: INF-01-00        Rev: 0205
   Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi3 Channel: 00 Id: 01 Lun: 06
   Vendor: SYMBIOS  Model: INF-01-00        Rev: 0205
   Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi3 Channel: 00 Id: 01 Lun: 07
   Vendor: SYMBIOS  Model: INF-01-00        Rev: 0205
   Type:   Direct-Access                    ANSI SCSI revision: 02

[7.7.] Other information that might be relevant to the problem
        (please look in /proc and include all information that you
        think to be relevant):

[X.] Other notes, patches, fixes, workarounds:

No workaround until now.

Please note that I'm willing to test any solution that you want me to. 
Patches, other kernel versions, re-compilations, scsi HBA settings, etc. 
I'm totally in charge of this hardware and it is 100% available for testing.

Many, many thanks in advance!

-- 
       .^.    Lic. Gabriel Gomiz - Red Hat Certified Engineer (RHCE)
       /V\    Administrador Red/Sistemas - Desarrollo Sistema POSEIDON
      // \\   Gerencia de Sistemas - Cooperativa Obrera Ltda.
     /(   )\  Tel (0291) 456-0084
      ^^-^^   s/Window[$s]/LINUX!!/g or die;

