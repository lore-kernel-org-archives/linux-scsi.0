From: "Bruno Westphal" <b.westphal@biel-net.de>
Subject: Parity error with driver sym53c8xx with kernel version 2.6.5 and 2.6.7
Date: Sat, 3 Jul 2004 12:25:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <001601c460e8$13c6eea0$0101a8c0@ctwdom>
Reply-To: "Bruno Westphal" <b.westphal@biel-net.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [62.72.66.82] ([62.72.66.82]:27120 "EHLO ctwmail.biel-net.de")
	by vger.kernel.org with ESMTP id S263585AbUGCKK3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Jul 2004 06:10:29 -0400
Received: from ctw1 (unknown [192.168.1.1])
	by ctwmail.biel-net.de (Postfix on SuSE Linux 7.3 (i386)) with SMTP id 41654500A0
	for <linux-scsi@vger.kernel.org>; Sat,  3 Jul 2004 10:14:49 +0200 (CEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

1.) Parity error with driver sym53c8xx with kernel version 2.6.5 and 2.6.7

2.) A few days ago I installed SuSE 9.1 on my Compaq PL850r.
During the installation I noticed that the SCSI module sym53x8xx reported a
parity error.
This error also occurs at every system boot since.
The computer worked fine before with SuSE 9.0 (kernel version 2.4.x), so I
don't think the hardware is to blame.
I've already tried updating the kernel to 2.6.7, but the error is still
there.


3.) Keyword:modules

4.) Kernel version:
Linux version 2.6.7 (root@suse91) (gcc version 3.3.3 (SuSE Linux))
#1 SMP Sat Jun 19 18:54:44 CEST 2004

7.1) Software:
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux suse91 2.6.7 #1 SMP Sat Jun 19 18:54:44 CEST 2004 i686 i686 i386
GNU/Linux

Gnu C                  3.3.3
Gnu make               3.80
binutils               2.15.90.0.1.1
util-linux             2.12
mount                  2.12
module-init-tools      3.0-pre10
e2fsprogs              1.34
jfsutils               1.1.5
xfsprogs               2.6.3
PPP                    2.4.2
isdn4k-utils           3.4
nfs-utils              1.0.6
Linux C Library        x  1 root root 1349081 Apr  5 17:31
/lib/tls/libc.so.6
Dynamic linker (ldd)   2.3.3
Linux C++ Library      5.0.5
Procps                 3.2.1
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.2.1
Modules Loaded         edd joydev st sr_mod ide_cd cdrom nvram usbserial
parport_pc lp parport ipv6 speedstep_lib freq_table usbcore evdev tlan
dm_mod ext3 jbd sym53c8xx aic7xxx scsi_transport_spi sd_mod scsi_mod

7.2) Processor:
processor : 0
vendor_id : GenuineIntel
cpu family : 6
model  : 1
model name : Pentium Pro
stepping : 9
cpu MHz  : 199.493
cache size : 256 KB
fdiv_bug : no
hlt_bug  : no
f00f_bug : no
coma_bug : no
fpu  : yes
fpu_exception : yes
cpuid level : 2
wp  : yes
flags  : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov
bogomips : 391.16

7.3) Processor:
edd 11032 0 - Live 0xc68ce000
joydev 10688 0 - Live 0xc68ca000
st 38812 0 - Live 0xc69cb000
sr_mod 17700 0 - Live 0xc699c000
ide_cd 39968 0 - Live 0xc69b4000
cdrom 37020 2 sr_mod,ide_cd, Live 0xc69a9000
nvram 10120 0 - Live 0xc68c6000
usbserial 28144 0 - Live 0xc6994000
parport_pc 38208 1 - Live 0xc68de000
lp 11528 0 - Live 0xc6860000
parport 40008 2 parport_pc,lp, Live 0xc68d3000
ipv6 246496 13 - Live 0xc69dc000
speedstep_lib 4992 0 - Live 0xc685d000
freq_table 5536 0 - Live 0xc685a000
usbcore 106464 2 usbserial, Live 0xc6979000
evdev 9984 0 - Live 0xc6827000
tlan 37148 0 - Live 0xc6878000
dm_mod 42272 0 - Live 0xc684e000
ext3 119912 1 - Live 0xc68e9000
jbd 67364 1 ext3, Live 0xc68b4000
sym53c8xx 74512 0 - Live 0xc6864000
aic7xxx 182712 3 - Live 0xc6886000
scsi_transport_spi 14080 1 sym53c8xx, Live 0xc681b000
sd_mod 21632 4 - Live 0xc6814000
scsi_mod 113604 6 st,sr_mod,sym53c8xx,aic7xxx,scsi_transport_spi,sd_mod,
Live 0xc6831000

7.4) Loaded drivers:

0000-001f : dma1
0020-0021 : pic1
0040-005f : timer
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
01f0-01f7 : ide0
02f8-02ff : serial
03bc-03be : parport0
03c0-03df : vga+
03f6-03f6 : ide0
03f8-03ff : serial
0cf8-0cff : PCI conf1
6000-60ff : 0000:00:09.0
  6000-60ff : sym53c8xx
6400-64ff : 0000:00:0c.0
6800-680f : 0000:00:10.0
  6800-680f : TLAN
f100-f10f : 0000:00:14.1
  f100-f107 : ide0

00000000-0009efff : System RAM
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000c8000-000cd7ff : Adapter ROM
000e0000-000e7fff : Adapter ROM
000e8000-000edfff : Adapter ROM
000f0000-000fffff : System ROM
00100000-05ffffff : System RAM
  00100000-002fe9e7 : Kernel code
  002fe9e8-003c22ff : Kernel data
40000000-40000fff : 0000:00:09.0
  40000000-40000fff : sym53c8xx
40001000-40001fff : 0000:00:0c.0
  40001000-40001fff : aic7xxx
40002000-400020ff : 0000:00:09.0
  40002000-400020ff : sym53c8xx
40002100-4000210f : 0000:00:10.0
  40002100-4000210f : TLAN
41000000-41ffffff : 0000:00:12.0

7.5) PCI information:
0000:00:00.0 Host bridge: Intel Corp. 440FX - 82441FX PMC [Natoma] (rev 02)
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B-
 Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort+ >SERR- <PERR-
 Latency: 32

0000:00:09.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev
04)
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+
Stepping- SERR+ FastB2B-
 Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 Latency: 255 (4250ns min, 16000ns max), cache line size 08
 Interrupt: pin A routed to IRQ 5
 Region 0: I/O ports at 6000
 Region 1: Memory at 40002000 (32-bit, non-prefetchable) [size=256]
 Region 2: Memory at 40000000 (32-bit, non-prefetchable) [size=4K]

0000:00:0c.0 SCSI storage controller: Adaptec AHA-2940U2/U2W
 Subsystem: Adaptec AHA-2940U2 SCSI Controller
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B-
 Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 Latency: 64 (9750ns min, 6250ns max), cache line size 08
 Interrupt: pin A routed to IRQ 10
 BIST result: 00
 Region 0: I/O ports at 6400 [disabled]
 Region 1: Memory at 40001000 (64-bit, non-prefetchable) [size=4K]
 Capabilities: [dc] Power Management version 1
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0000:00:10.0 Network controller: Compaq Computer Corporation Compaq
Integrated NetFlex-3/P ThunderLAN 2.3 (rev 10)
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B-
 Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 Latency: 64, cache line size 08
 Interrupt: pin A routed to IRQ 9
 Region 0: I/O ports at 6800
 Region 1: Memory at 40002100 (32-bit, non-prefetchable) [size=16]

0000:00:12.0 VGA compatible controller: Cirrus Logic GD 5430/40 [Alpine]
(rev 22) (prog-if 00 [VGA])
 Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 Interrupt: pin A routed to IRQ 0
 Region 0: Memory at 41000000 (32-bit, prefetchable)

0000:00:14.0 ISA bridge: Intel Corp. 82371SB PIIX3 ISA [Natoma/Triton II]
(rev 01)
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 Latency: 0

0000:00:14.1 IDE interface: Intel Corp. 82371SB PIIX3 IDE [Natoma/Triton II]
(prog-if 80 [Master])
 Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 Latency: 64
 Region 4: I/O ports at f100 [size=16]

7.6) SCSI information:
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: IBM      Model: DNES-309170W     Rev: SA30
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: SEAGATE  Model: ST32171N         Rev: 0280
  Type:   Direct-Access                    ANSI SCSI revision: 02

7.7) Other:
message form /var/log/message
Jul  2 13:00:07 suse91 kernel: sym0: SCSI parity error detected: SCR1=132
DBC=50000000 SBCL=0
Jul  2 13:00:07 suse91 kernel: NET: Registered protocol family 10
Jul  2 13:01:18 suse91 kernel: sym0: SCSI parity error detected: SCR1=132
DBC=50000000 SBCL=0
Jul  2 13:01:20 suse91 kernel: <6>Non-volatile memory driver v1.2
Jul  2 13:01:20 suse91 kernel: sym0: SCSI parity error detected: SCR1=132
DBC=50000000 SBCL=0
Jul  2 13:01:24 suse91 kernel: sym0: SCSI parity error detected: SCR1=132
DBC=50000000 SBCL=0


can you telly my how can fix this problem.

Thank you
    Bruno Westphal



