From: "Cristiano Duarte" <cunha17@uol.com.br>
Subject: PROBLEM: aic7xxx and Adaptec AHA2940UW - protocol violation
Date: Mon, 16 Feb 2004 14:49:09 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <HT6UTX$IsLcwhK92wRHCu4l8JXKeq1t2clsaJAF2Ml@uol.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrek2.uol.com.br ([200.221.29.15]:46275 "EHLO
	shrek2.uol.com.br") by vger.kernel.org with ESMTP id S265713AbUBPRsJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Feb 2004 12:48:09 -0500
Received: from uol.com.br (unknown [172.26.5.197])
	by shrek2.uol.com.br (Postfix) with ESMTP id C9B6743D53
	for <linux-scsi@vger.kernel.org>; Mon, 16 Feb 2004 14:48:02 -0300 (BRT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[1.] One line summary of the problem:
I'm experiencing some problem with my
Sceptre S1200(scsi) scanner, my
Adaptec AHA-2940UW and kernels above
2.4.18.

[2.] Full description of the
problem/report:
With RedHat 9, kernel 2.4.20, my
scanner is recognized by the kernel,
but the sane-find-scanner and
scanimage utility get garbage when
talking to it.
So I installed Fedora Core 1, and
tested with kernel 2.4.22(Fedora) and
"vanilla" 2.4.24. I got these error
messages on boot:

=46eb 13 17:53:15 thor kernel: SCSI
subsystem driver Revision: 1.00
=46eb 13 17:53:15 thor kernel: scsi0 :
Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA
DRIVER, Rev 6.2.36
=46eb 13 17:53:15 thor kernel:       =20
<Adaptec 2940 Ultra SCSI adapter>
=46eb 13 17:53:15 thor kernel:       =20
aic7880: Ultra Wide Channel A, SCSI
Id=3D15, 16/253 SCBs
=46eb 13 17:53:15 thor kernel:=20
=46eb 13 17:53:15 thor kernel: blk:
queue c130d574, I/O limit 4095Mb (mask
0xffffffff)
=46eb 13 17:53:15 thor kernel:
(scsi0:A:3:0): Unexpected busfree
while idle
=46eb 13 17:53:15 thor kernel: SEQADDR
=3D=3D 0x156
=46eb 13 17:53:15 thor kernel:
(scsi0:A:3:0): No or incomplete CDB
sent to device.
=46eb 13 17:53:15 thor kernel: scsi0:
Issued Channel A Bus Reset. 1 SCBs aborted
=46eb 13 17:53:15 thor kernel:
(scsi0:A:6:0): No or incomplete CDB
sent to device.
=46eb 13 17:53:15 thor kernel:
(scsi0:A:6:0): Protocol violation in
Message-in phase.  Attempting to abort.
=46eb 13 17:53:15 thor kernel:
(scsi0:A:6:0): Abort Message Sent
=46eb 13 17:53:15 thor kernel:   Vendor:
KINPO     Model: Vivi(scsi0:A:3:0):
Unexpected busfree while idle
=46eb 13 17:53:15 thor kernel: SEQADDR
=3D=3D 0x156
=46eb 13 17:53:15 thor kernel: dscan
S120    Rev: S13=20
=46eb 13 17:53:15 thor kernel:   Type:=20
 Scanner                          =20
ANSI SCSI revision: 02
=46eb 13 17:53:15 thor kernel: blk:
queue c130d674, I/O limit 4095Mb (mask
0xffffffff)
=46eb 13 17:53:15 thor kernel:
(scsi0:A:3:0): No or incomplete CDB
sent to device.
=46eb 13 17:53:15 thor kernel: scsi0:
Issued Channel A Bus Reset. 1 SCBs aborted
=46eb 13 17:53:15 thor kernel:   Vendor:
IOMEGA    Model: ZIP 100         =20
Rev: J.02
=46eb 13 17:53:15 thor kernel:   Type:=20
 Direct-Access                    =20
ANSI SCSI revision: 02
=46eb 13 17:53:15 thor kernel: blk:
queue c130da74, I/O limit 4095Mb (mask
0xffffffff)
=46eb 13 17:53:15 thor kernel: Attached
scsi removable disk sda at scsi0,
channel 0, id 6, lun 0
=46eb 13 17:53:15 thor kernel:
scsi0:0:6:0: Attempting to queue an
ABORT message
=46eb 13 17:53:15 thor kernel: CDB: 0x0
0x0 0x0 0x0 0x0 0x0
=46eb 13 17:53:15 thor kernel: scsi0: At
time of recovery, card was not paused
=46eb 13 17:53:15 thor kernel:
>>>>>>>>>>>>>>>>>> Dump Card State
Begins <<<<<<<<<<<<<<<<<
=46eb 13 17:53:15 thor kernel: scsi0:
Dumping Card State in Message-out
phase, at SEQADDR 0x156
=46eb 13 17:53:15 thor kernel: Card was
paused
=46eb 13 17:53:15 thor kernel: ACCUM =3D
0xa0, SINDEX =3D 0xc0, DINDEX =3D 0xc0,
ARG_2 =3D 0x1
=46eb 13 17:53:15 thor kernel: HCNT =3D
0x0 SCBPTR =3D 0x0
=46eb 13 17:53:15 thor kernel:
SCSISIGI[0xa6] ERROR[0x0]
SCSIBUSL[0xc0] LASTPHASE[0xa0]=20
=46eb 13 17:53:15 thor kernel:
SCSISEQ[0x12] SBLKCTL[0x2]
SCSIRATE[0x0] SEQCTL[0x10]=20
=46eb 13 17:53:15 thor kernel:
SEQ_FLAGS[0x40] SSTAT0[0x5]
SSTAT1[0x2] SSTAT2[0x0]=20
=46eb 13 17:53:15 thor kernel:
SSTAT3[0x0] SIMODE0[0x0] SIMODE1[0xac]
SXFRCTL0[0x88]=20
=46eb 13 17:53:15 thor kernel:
DFCNTRL[0x4] DFSTATUS[0x6d]=20
=46eb 13 17:53:15 thor kernel: STACK:
0xbc 0x52 0x150 0x191
=46eb 13 17:53:15 thor kernel: SCB count =3D 5
=46eb 13 17:53:15 thor kernel: Kernel
NEXTQSCB =3D 3
=46eb 13 17:53:15 thor kernel: Card
NEXTQSCB =3D 3
=46eb 13 17:53:15 thor kernel: QINFIFO
entries:=20
=46eb 13 17:53:15 thor kernel: Waiting
Queue entries:=20
=46eb 13 17:53:15 thor kernel:
Disconnected Queue entries:=20
=46eb 13 17:53:15 thor kernel: QOUTFIFO
entries:=20
=46eb 13 17:53:15 thor kernel: Sequencer
=46ree SCB List: 1 2 3 4 5 6 7 8 9 10 11
12 13 14 15=20
=46eb 13 17:53:15 thor kernel: Sequencer
SCB Info:=20
=46eb 13 17:53:15 thor kernel:   0
SCB_CONTROL[0x40] SCB_SCSIID[0x6f]
SCB_LUN[0x0] SCB_TAG[0x4]=20
=46eb 13 17:53:15 thor kernel:   1
SCB_CONTROL[0x0] SCB_SCSIID[0xff]
SCB_LUN[0xff] SCB_TAG[0xff]=20
=46eb 13 17:53:15 thor kernel:   2
SCB_CONTROL[0x0] SCB_SCSIID[0xff]
SCB_LUN[0xff] SCB_TAG[0xff]=20
=46eb 13 17:53:15 thor kernel:   3
SCB_CONTROL[0x0] SCB_SCSIID[0xff]
SCB_LUN[0xff] SCB_TAG[0xff]=20
=46eb 13 17:53:11 thor sysctl:
kernel.core_uses_pid =3D 1=20
=46eb 13 17:53:15 thor kernel:   4
SCB_CONTROL[0x0] SCB_SCSIID[0xff]
SCB_LUN[0xff] SCB_TAG[0xff]=20
=46eb 13 17:53:11 thor network:
Configurando par=E2metros de rede:=20
succeeded=20
=46eb 13 17:53:15 thor kernel:   5
SCB_CONTROL[0x0] SCB_SCSIID[0xff]
SCB_LUN[0xff] SCB_TAG[0xff]=20
=46eb 13 17:53:11 thor network:
Iniciando a interface 'loopback':=20
succeeded=20
=46eb 13 17:53:15 thor kernel:   6
SCB_CONTROL[0x0] SCB_SCSIID[0xff]
SCB_LUN[0xff] SCB_TAG[0xff]=20
=46eb 13 17:53:15 thor kernel:   7
SCB_CONTROL[0x0] SCB_SCSIID[0xff]
SCB_LUN[0xff] SCB_TAG[0xff]=20
=46eb 13 17:53:15 thor kernel:   8
SCB_CONTROL[0x0] SCB_SCSIID[0xff]
SCB_LUN[0xff] SCB_TAG[0xff]=20
=46eb 13 17:53:15 thor kernel:   9
SCB_CONTROL[0x0] SCB_SCSIID[0xff]
SCB_LUN[0xff] SCB_TAG[0xff]=20
=46eb 13 17:53:15 thor kernel:  10
SCB_CONTROL[0x0] SCB_SCSIID[0xff]
SCB_LUN[0xff] SCB_TAG[0xff]=20
=46eb 13 17:53:15 thor kernel:  11
SCB_CONTROL[0x0] SCB_SCSIID[0xff]
SCB_LUN[0xff] SCB_TAG[0xff]=20
=46eb 13 17:53:15 thor kernel:  12
SCB_CONTROL[0x0] SCB_SCSIID[0xff]
SCB_LUN[0xff] SCB_TAG[0xff]=20
=46eb 13 17:53:15 thor kernel:  13
SCB_CONTROL[0x0] SCB_SCSIID[0xff]
SCB_LUN[0xff] SCB_TAG[0xff]=20
=46eb 13 17:53:15 thor kernel:  14
SCB_CONTROL[0x0] SCB_SCSIID[0xff]
SCB_LUN[0xff] SCB_TAG[0xff]=20
=46eb 13 17:53:15 thor kernel:  15
SCB_CONTROL[0x0] SCB_SCSIID[0xff]
SCB_LUN[0xff] SCB_TAG[0xff]=20
=46eb 13 17:53:15 thor kernel: Pending
list:=20
=46eb 13 17:53:15 thor kernel:   4
SCB_CONTROL[0x40] SCB_SCSIID[0x6f]
SCB_LUN[0x0]=20
=46eb 13 17:53:15 thor kernel: Kernel
=46ree SCB list: 2 1 0=20
=46eb 13 17:53:15 thor kernel: Untagged
Q(6): 4=20
=46eb 13 17:53:15 thor kernel:
DevQ(0:3:0): 0 waiting
=46eb 13 17:53:15 thor kernel:
DevQ(0:6:0): 0 waiting
=46eb 13 17:53:15 thor kernel:=20
=46eb 13 17:53:15 thor kernel:
<<<<<<<<<<<<<<<<< Dump Card State Ends
>>>>>>>>>>>>>>>>>>
=46eb 13 17:53:15 thor kernel:
scsi0:0:6:0: Device is active,
asserting ATN
=46eb 13 17:53:15 thor kernel: Recovery
code sleeping
=46eb 13 17:53:15 thor kernel: Recovery
code awake
=46eb 13 17:53:15 thor kernel: Timer Expired
=46eb 13 17:53:15 thor kernel:
aic7xxx_abort returns 0x2003
=46eb 13 17:53:15 thor kernel:
scsi0:0:6:0: Attempting to queue a
TARGET RESET message
=46eb 13 17:53:15 thor kernel: CDB: 0x0
0x0 0x0 0x0 0x0 0x0
=46eb 13 17:53:15 thor kernel:
aic7xxx_dev_reset returns 0x2003
=46eb 13 17:53:15 thor kernel: Recovery
SCB completes
=46eb 13 17:53:15 thor kernel: Device
not ready.  Make sure there is a disc
in the drive.
=46eb 13 17:53:15 thor kernel: sda: Unit
Not Ready, sense:
=46eb 13 17:53:15 thor kernel: Current
00:00: sense key Not Ready
=46eb 13 17:53:15 thor kernel:
Additional sense indicates Medium not
present
=46eb 13 17:53:15 thor kernel: sda :
READ CAPACITY failed.
=46eb 13 17:53:16 thor kernel: sda :
status =3D 1, message =3D 00, host =3D 0,
driver =3D 08=20
=46eb 13 17:53:16 thor kernel: Current
sd00:00: sense key Not Ready
=46eb 13 17:53:16 thor kernel:
Additional sense indicates Medium not
present
=46eb 13 17:53:16 thor kernel: sda :
block size assumed to be 512 bytes,
disk size 1GB. =20
=46eb 13 17:53:16 thor kernel:  sda: I/O
error: dev 08:00, sector 0
=46eb 13 17:53:16 thor kernel:  I/O
error: dev 08:00, sector 0
=46eb 13 17:53:16 thor kernel:  unable
to read partition table

The sane-find-scanner reports protocol
violations on syslog and can't find
the scanner. The scanner isn't
recognized, and gets missing in
/proc/scsi/scsi.

So I tried downgrading just the kernel
to version 2.4.18(Redhat 7.3 kernel)
and everything works! The kernel
recognizes the scanner without
complaining(it appears in
/proc/scsi/scsi) and the
sane-find-scanner and scanimage
utilities find and recognizes my scanner.

After that, I downloaded two BIOS
updates from Adaptec and applied them
to my Adaptec card. But, even with
these updates, everything is the same
for kernels above 2.4.18.

That said, IMHO there's something
wrong in aic7xxx module(or scsi
subsystem) in kernel versions above
2.4.18.

[3.] Keywords
aic7xxx, aha2940uw, scsi, protocol
violation

[4.] Kernel version (from /proc/version):
Linux version 2.4.24savage
(root@thor.home) (gcc version 3.3.2
20031022 (Red Hat Linux 3.3.2-1)) #3
Sex Fev 13 13:23:47 BRST 2004
Also happended with 2.4.22(Fedora
Core) and 2.4.20(RedHat 9) kernels.

[5.] Output of Oops.. message (if
applicable) with symbolic information=20
     resolved (see
Documentation/oops-tracing.txt)
Not applicable

[6.] A small shell script or example
program which triggers the
     problem (if possible)
Boot problem and "sane-find-scanner -v
-v -v" problem.

[7.] Environment
[7.1.] Software (add the output of the
ver_linux script here)

OS: Fedora Core 1 - "vanilla" kernel
2.4.24/2.4.22(Fedora)/2.4.20(RedHat9)/2.4.18(RedHat7.3)

Scanner: Sceptre S1200 scanner (KINPO
VIVIDSCAN)


If some fields are empty or look
unusual you may have an old version.
Compare to the current minimal
requirements in Documentation/Changes.
 =20
Linux thor.home 2.4.24savage #3 Sex
=46ev 13 13:23:47 BRST 2004 i686 i686
i386 GNU/Linux
 =20
Gnu C                  3.3.2
Gnu make               3.79.1
util-linux             2.11y
mount                  2.11y
modutils               2.4.25
e2fsprogs              1.34
jfsutils               1.1.3
reiserfsprogs          3.6.8
quota-tools            3.06.
PPP                    2.4.1
isdn4k-utils           3.3
Linux C Library        2.3.2
Dynamic linker (ldd)   2.3.2
Procps                 2.0.17
Net-tools              1.60
Kbd                    1.08
Sh-utils               5.0
Modules Loaded         nls_cp437 vfat
fat nls_iso8859-1 udf snd-emu10k1
snd-rawmidi snd-util-mem snd-hwdep
snd-ac97-codec snd-pcm-oss snd-pcm
snd-page-alloc snd-timer snd-mixer-oss
snd-seq-device snd soundcore ide-cd
cdrom parport_pc lp parport autofs
8139too mii floppy sg microcode
keybdev mousedev input hid usb-uhci
usbcore thermal processor fan button
battery asus_acpi ac ext3 jbd aic7xxx
sd_mod scsi_mod

[7.2.] Processor information (from
/proc/cpuinfo):
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 8
model name      : Pentium III (Coppermine)
stepping        : 10
cpu MHz         : 938.046
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc
msr pae mce cx8 sep mtrr pge mca cmov
pat pse36 mmx fxsr sse
bogomips        : 1874.32

[7.3.] Module information (from
/proc/modules):
nls_cp437               5148   1
(autoclean)
vfat                   13068   1
(autoclean)
fat                    38200   0
(autoclean) [vfat]
nls_iso8859-1           3516   2
(autoclean)
udf                    98336   0
(autoclean)
snd-emu10k1            86212   0
(autoclean)
snd-rawmidi            18784   0
(autoclean) [snd-emu10k1]
snd-util-mem            3096   0
(autoclean) [snd-emu10k1]
snd-hwdep               7008   0
(autoclean) [snd-emu10k1]
snd-ac97-codec         58796   0
(autoclean) [snd-emu10k1]
snd-pcm-oss            45028   0
(autoclean)
snd-pcm                85700   0
(autoclean) [snd-emu10k1 snd-pcm-oss]
snd-page-alloc         10196   0
(autoclean) [snd-emu10k1 snd-pcm]
snd-timer              19876   0
(autoclean) [snd-pcm]
snd-mixer-oss          16496   0
(autoclean) [snd-pcm-oss]
snd-seq-device          6300   0
(autoclean) [snd-emu10k1 snd-rawmidi]
snd                    46244   0
(autoclean) [snd-emu10k1 snd-rawmidi
snd-util-mem snd-hwdep snd-ac97-codec
snd-pcm-oss snd-pcm snd-timer
snd-mixer-oss snd-seq-device]
soundcore               6468   6
(autoclean) [snd]
ide-cd                 35648   1
(autoclean)
cdrom                  33280   0
(autoclean) [ide-cd]
parport_pc             19108   1
(autoclean)
lp                      9124   0
(autoclean)
parport                37128   1
(autoclean) [parport_pc lp]
autofs                 13076   0
(autoclean) (unused)
8139too                16360   1
mii                     3880   0 [8139too]
floppy                 57692   0
(autoclean)
sg                     36412   0
(autoclean)
microcode               4700   0
(autoclean)
keybdev                 2948   0 (unused)
mousedev                5524   1
input                   5760   0
[keybdev mousedev]
hid                    12344   0 (unused)
usb-uhci               26480   0 (unused)
usbcore                78700   1 [hid
usb-uhci]
thermal                 8068   0 (unused)
processor              10712   0 [thermal]
fan                     2496   0 (unused)
button                  3628   0 (unused)
battery                 6976   0 (unused)
asus_acpi               9580   0 (unused)
ac                      2752   0 (unused)
ext3                   70340   1
jbd                    52056   1 [ext3]
aic7xxx               162096   0
sd_mod                 13484   0
scsi_mod              107424   3 [sg
aic7xxx sd_mod]

[7.4.] Loaded driver and hardware
information (/proc/ioports, /proc/iomem)
/proc/ioports
0000-001f : dma1
0020-003f : pic1
0040-005f : timer
0060-006f : keyboard
0070-007f : rtc
0080-008f : dma page reg
00a0-00bf : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : ide1
01f0-01f7 : ide0
02f8-02ff : serial(auto)
0376-0376 : ide1
0378-037a : parport0
03c0-03df : vga+
03f6-03f6 : ide0
0cf8-0cff : PCI conf1
a000-a01f : Intel Corp. 82801BA/BAM
USB (Hub #2)
  a000-a01f : usb-uhci
a400-a41f : Intel Corp. 82801BA/BAM
USB (Hub #1)
  a400-a41f : usb-uhci
a800-a80f : Intel Corp. 82801BA IDE U100
  a800-a807 : ide0
  a808-a80f : ide1
b800-b8ff : Adaptec AHA-2940U/UW/D /
AIC-7881U
d000-d007 : Creative Labs SB Live!
MIDI/Game Port
d400-d41f : Creative Labs SB Live! EMU10k1
  d400-d41f : EMU10K1
d800-d8ff : Realtek Semiconductor Co.,
Ltd. RTL-8139/8139C/8139C+
  d800-d8ff : 8139too
e800-e80f : Intel Corp. 82801BA/BAM SMBus

/proc/iomem
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cc000-000cc7ff : Extension ROM
000f0000-000fffff : System ROM
00100000-0ffeafff : System RAM
  00100000-0026b9b1 : Kernel code
  0026b9b2-002eec43 : Kernel data
0ffeb000-0ffeefff : ACPI Tables
0ffef000-0fffefff : reserved
0ffff000-0fffffff : ACPI Non-volatile
Storage
e2800000-e2800fff : Adaptec
AHA-2940U/UW/D / AIC-7881U
  e2800000-e2800fff : aic7xxx
e3000000-e30000ff : Realtek
Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+
  e3000000-e30000ff : 8139too
e3800000-e3800fff : Zoran Corporation
ZR36057PQC Video cutting chipset
e4000000-f3dfffff : PCI Bus #01
  e4000000-e7ffffff : S3 Inc. 86C410
Savage 2000
  e8000000-ebffffff : S3 Inc. 86C410
Savage 2000
  ec000000-efffffff : S3 Inc. 86C410
Savage 2000
  f3000000-f307ffff : S3 Inc. 86C410
Savage 2000
f3f00000-f7ffffff : PCI Bus #01
  f4000000-f7ffffff : S3 Inc. 86C410
Savage 2000
f8000000-fbffffff : Intel Corp. 82815
815 Chipset Host Bridge and Memory
Controller Hub
fff80000-ffffffff : reserved

[7.5.] PCI information ('lspci -vvv'
as root)
00:00.0 Host bridge: Intel Corp. 82815
815 Chipset Host Bridge and Memory
Controller Hub (rev 02)
        Subsystem: Asustek Computer,
Inc. TUSL2-C Mainboard
        Control: I/O- Mem+ BusMaster+
SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF-
=46astB2B+ ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Region 0: Memory at f8000000
(32-bit, prefetchable) [size=3D64M]
        Capabilities: [88] #09 [f104]
        Capabilities: [a0] AGP version 2.0
                Status: RQ=3D31 SBA+
64bit- FW- Rate=3Dx1,x2
                Command: RQ=3D0 SBA-
AGP- 64bit- FW- Rate=3D<none>
=20
00:01.0 PCI bridge: Intel Corp. 82815
815 Chipset AGP Bridge (rev 02)
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+
SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz+ UDF-
=46astB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=3D00, secondary=3D01,
subordinate=3D01, sec-latency=3D0
        I/O behind bridge:
0000e000-0000dfff
        Memory behind bridge:
e4000000-f3dfffff
        Prefetchable memory behind
bridge: f3f00000-f7ffffff
        BridgeCtl: Parity- SERR-
NoISA- VGA+ MAbort- >Reset- FastB2B-
=20
00:1e.0 PCI bridge: Intel Corp.
82801BA/CA/DB/EB PCI Bridge (rev 02)
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+
SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF-
=46astB2B+ ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=3D00, secondary=3D02,
subordinate=3D02, sec-latency=3D32
        I/O behind bridge:
0000b000-0000dfff
        Memory behind bridge:
e2800000-e3ffffff
        Prefetchable memory behind
bridge: f3e00000-f3efffff
        BridgeCtl: Parity- SERR+
NoISA+ VGA- MAbort- >Reset- FastB2B-
=20
00:1f.0 ISA bridge: Intel Corp.
82801BA ISA Bridge (LPC) (rev 02)
        Control: I/O+ Mem+ BusMaster+
SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF-
=46astB2B+ ParErr- DEVSEL=3Dmedium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
=20
00:1f.1 IDE interface: Intel Corp.
82801BA IDE U100 (rev 02) (prog-if 80
[Master])
        Subsystem: Asustek Computer,
Inc. TUSL2-C Mainboard
        Control: I/O+ Mem- BusMaster+
SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF-
=46astB2B+ ParErr- DEVSEL=3Dmedium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 4: I/O ports at a800
[size=3D16]
=20
00:1f.2 USB Controller: Intel Corp.
82801BA/BAM USB (Hub #1) (rev 02)
(prog-if 00 [UHCI])
        Subsystem: Asustek Computer,
Inc.: Unknown device 8027
        Control: I/O+ Mem- BusMaster+
SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF-
=46astB2B+ ParErr- DEVSEL=3Dmedium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 9
        Region 4: I/O ports at a400
[size=3D32]
=20
00:1f.3 SMBus: Intel Corp. 82801BA/BAM
SMBus (rev 02)
        Subsystem: Asustek Computer,
Inc. TUSL2-C Mainboard
        Control: I/O+ Mem- BusMaster-
SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF-
=46astB2B+ ParErr- DEVSEL=3Dmedium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 9
        Region 4: I/O ports at e800
[size=3D16]
=20
00:1f.4 USB Controller: Intel Corp.
82801BA/BAM USB (Hub #2) (rev 02)
(prog-if 00 [UHCI])
        Subsystem: Asustek Computer,
Inc.: Unknown device 8027
        Control: I/O+ Mem- BusMaster+
SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF-
=46astB2B+ ParErr- DEVSEL=3Dmedium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 4
        Region 4: I/O ports at a000
[size=3D32]
=20
01:00.0 VGA compatible controller: S3
Inc. 86C410 Savage 2000 (rev 02)
(prog-if 00 [VGA])
        Subsystem: Diamond Multimedia
Systems Viper II Z200
        Control: I/O+ Mem+ BusMaster+
SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz+ UDF-
=46astB2B- ParErr- DEVSEL=3Dmedium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (3000ns min,
4000ns max), cache line size 08
        Interrupt: pin A routed to IRQ 9
        Region 0: Memory at f3000000
(32-bit, non-prefetchable) [size=3D512K]
        Region 1: Memory at f4000000
(32-bit, prefetchable) [size=3D64M]
        Region 2: Memory at ec000000
(32-bit, non-prefetchable) [size=3D64M]
        Region 3: Memory at e8000000
(32-bit, non-prefetchable) [size=3D64M]
        Region 4: Memory at e4000000
(32-bit, non-prefetchable) [size=3D64M]
        Expansion ROM at f3ff0000
[disabled] [size=3D64K]
        Capabilities: [dc] Power
Management version 1
                Flags: PMEClk- DSI+
D1+ D2+ AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable-
DSel=3D0 DScale=3D0 PME-
        Capabilities: [80] AGP version 2.0
                Status: RQ=3D31 SBA+
64bit- FW- Rate=3Dx1,x2,x4
                Command: RQ=3D0 SBA-
AGP- 64bit- FW- Rate=3D<none>
=20
02:0a.0 Multimedia video controller:
Zoran Corporation ZR36057PQC Video
cutting chipset (rev 01)
        Control: I/O- Mem+ BusMaster+
SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF-
=46astB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (500ns min, 4000ns
max)
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at e3800000
(32-bit, non-prefetchable) [size=3D4K]
=20
02:0b.0 Ethernet controller: Realtek
Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ (rev 10)
        Subsystem: Realtek
Semiconductor Co., Ltd. RT8139
        Control: I/O+ Mem+ BusMaster+
SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF-
=46astB2B+ ParErr- DEVSEL=3Dmedium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (8000ns min,
16000ns max)
        Interrupt: pin A routed to IRQ 4
        Region 0: I/O ports at d800
[size=3D256]
        Region 1: Memory at e3000000
(32-bit, non-prefetchable) [size=3D256]
=20
02:0c.0 Multimedia audio controller:
Creative Labs SB Live! EMU10k1 (rev 07)
        Subsystem: Creative Labs SB
Live! 5.1 Model SB0100
        Control: I/O+ Mem- BusMaster+
SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF-
=46astB2B+ ParErr- DEVSEL=3Dmedium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (500ns min, 5000ns
max)
        Interrupt: pin A routed to IRQ 5
        Region 0: I/O ports at d400
[size=3D32]
        Capabilities: [dc] Power
Management version 1
                Flags: PMEClk- DSI-
D1+ D2+ AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable-
DSel=3D0 DScale=3D0 PME-
=20
02:0c.1 Input device controller:
Creative Labs SB Live! MIDI/Game Port
(rev 07)
        Subsystem: Creative Labs
Gameport Joystick
        Control: I/O+ Mem- BusMaster+
SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF-
=46astB2B+ ParErr- DEVSEL=3Dmedium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32
        Region 0: I/O ports at d000
[size=3D8]
        Capabilities: [dc] Power
Management version 1
                Flags: PMEClk- DSI-
D1+ D2+ AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable-
DSel=3D0 DScale=3D0 PME-
=20
02:0e.0 SCSI storage controller:
Adaptec AHA-2940U/UW/D / AIC-7881U
(rev 01)
        Subsystem: Adaptec AHA-2940UW
SCSI Host Adapter
        Control: I/O- Mem+ BusMaster+
SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF-
=46astB2B+ ParErr- DEVSEL=3Dmedium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min,
2000ns max), cache line size 08
        Interrupt: pin A routed to IRQ 10
        Region 0: I/O ports at b800
[disabled] [size=3D256]
        Region 1: Memory at e2800000
(32-bit, non-prefetchable) [size=3D4K]
        Expansion ROM at <unassigned>
[disabled] [size=3D64K]
        Capabilities: [dc] Power
Management version 1
                Flags: PMEClk- DSI+
D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable-
DSel=3D0 DScale=3D0 PME-
=20

[7.6.] SCSI information (from
/proc/scsi/scsi)
Host: scsi0 Channel: 00 Id: 06 Lun: 00
  Vendor: IOMEGA   Model: ZIP 100   =20
     Rev: J.02
  Type:   Direct-Access             =20
     ANSI SCSI revision: 02

[7.7.] Other information that might be
relevant to the problem
       (please look in /proc and
include all information that you
       think to be relevant):

[X.] Other notes, patches, fixes,
workarounds:.=20
No workaround except kernel
downgrading to 2.4.18.

Best Regards,

Cristiano Duarte


=20
---
Acabe com aquelas janelinhas que pulam na sua tela.
AntiPop-up UOL - =C9 gr=E1tis!=20
http://antipopup.uol.com.br

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
