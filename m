From: Wolfgang Hahnl <wolfgang.hahnl@gmx.de>
Subject: HL-DT-ST DVDRAM GSA-T20N-(P) not recognized after installation
Date: Sun, 01 Feb 2015 21:07:07 +0100
Message-ID: <54CE876B.9030803@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50212 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018AbbBAUBP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Feb 2015 15:01:15 -0500
Received: from [192.168.178.22] ([84.172.79.39]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0MUZKF-1Y92RQ2ML5-00RJwi for
 <linux-scsi@vger.kernel.org>; Sun, 01 Feb 2015 21:01:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[1.]
summary:     - HL-DT-ST DVDRAM GSA-T20N-(P)
+ HL-DT-ST DVDRAM GSA-T20N-(P) not recognized after installation

[2.]

I installed Ubuntu 14.04 via DVD-iso in the DVD drive. During 
installation procedure the DVD drive worked properly. After installation 
I got no connection to the device. If I insert a video DVD the drive 
starts and stops again. If I execute at a terminal:

sudo lshw -C disk

I got only information about the hard drive and no information about DVDRAM.

As per the BIOS:
IDE Slave
HL-DT-ST DVDRAM GSA-T20N-(P)
Transfer Mode: 8FPIO4/DMA2]
Ultra DMA Mode: Mode 2

kernel-bug-exists-upstream
kernel-bug-exists-upstream-3.19-rc6

[3]
Keywords: DVDRAM, kernel, bios

[4]
cat /proc/version
Linux version 3.19.0-031900rc6-generic (kernel@gomeisa) (gcc version 
4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201501261152 SMP Mon Jan 26 
17:14:44 UTC 2015

[7]
sudo lsb_release -rd
[sudo] password for lilly:
Description:    Ubuntu 14.04.1 LTS
Release:        14.04


[7.1]

lilly@lilly-ECO4511IW:/usr/src/linux-headers-3.19.0-031900rc6-generic/scripts$ 
sh ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux lilly-ECO4511IW 3.19.0-031900rc6-generic #201501261152 SMP Mon Jan 
26 17:14:44 UTC 2015 i686 i686 i686 GNU/Linux

Gnu C                  ver_linux:
Gnu make               3.81
binutils               2.24
util-linux             2.20.1
mount                  support
module-init-tools      15
e2fsprogs              1.42.9
pcmciautils            018
PPP 2.4.5
Linux C Library 2.19
Dynamic linker (ldd) 2.19
Procps 3.3.9
Net-tools 1.60
Kbd                    1.15.5
Sh-utils               8.21
wireless-tools         30
Modules Loaded         arc4 rfcomm bnep snd_hda_codec_realtek 
snd_hda_codec_generic snd_hda_codec_si3054 snd_hda_intel 
snd_hda_controller iwl4965 iwlegacy snd_hda_codec mac80211 snd_hwdep 
snd_pcm coretemp snd_seq_midi snd_seq_midi_event kvm_intel snd_rawmidi 
binfmt_misc kvm cfg80211 joydev snd_seq serio_raw snd_seq_device 
snd_timer snd soundcore parport_pc ppdev lp btusb bluetooth lpc_ich 
mac_hid parport hid_generic usbhid hid i915 psmouse ahci libahci r8169 
i2c_algo_bit drm_kms_helper video mii drm

[7.2]
cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     T7100  @ 1.80GHz
stepping        : 13
microcode       : 0xa1
cpu MHz         : 800.000
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl 
vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dtherm tpr_shadow vnmi 
flexpriority
bugs            :
bogomips        : 3591.11
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     T7100  @ 1.80GHz
stepping        : 13
microcode       : 0xa1
cpu MHz         : 800.000
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fdiv_bug        : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc arch_perfmon pebs bts aperfmperf pni dtes64 monitor ds_cpl 
vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dtherm tpr_shadow vnmi 
flexpriority
bugs            :
bogomips        : 3591.11
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:




[7.3]
cat /proc/modules
arc4 12509 2 - Live 0x00000000
rfcomm 59314 12 - Live 0x00000000
bnep 19107 2 - Live 0x00000000
snd_hda_codec_realtek 68841 1 - Live 0x00000000
snd_hda_codec_generic 63667 1 snd_hda_codec_realtek, Live 0x00000000
snd_hda_codec_si3054 12928 1 - Live 0x00000000
snd_hda_intel 29576 3 - Live 0x00000000
snd_hda_controller 30930 1 snd_hda_intel, Live 0x00000000
iwl4965 112529 0 - Live 0x00000000
iwlegacy 88297 1 iwl4965, Live 0x00000000
snd_hda_codec 121018 5 
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_si3054,snd_hda_intel,snd_hda_controller, 
Live 0x00000000
mac80211 643092 2 iwl4965,iwlegacy, Live 0x00000000
snd_hwdep 13276 1 snd_hda_codec, Live 0x00000000
snd_pcm 89214 6 
snd_hda_codec_si3054,snd_hda_intel,snd_hda_controller,snd_hda_codec, 
Live 0x00000000
coretemp 13358 0 - Live 0x00000000
snd_seq_midi 13324 0 - Live 0x00000000
snd_seq_midi_event 14475 1 snd_seq_midi, Live 0x00000000
kvm_intel 143334 0 - Live 0x00000000
snd_rawmidi 25786 1 snd_seq_midi, Live 0x00000000
binfmt_misc 17795 1 - Live 0x00000000
kvm 416745 1 kvm_intel, Live 0x00000000
cfg80211 462008 3 iwl4965,iwlegacy,mac80211, Live 0x00000000
joydev 17311 0 - Live 0x00000000
snd_seq 56978 2 snd_seq_midi,snd_seq_midi_event, Live 0x00000000
serio_raw 13251 0 - Live 0x00000000
snd_seq_device 14451 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0x00000000
snd_timer 29036 2 snd_pcm,snd_seq, Live 0x00000000
snd 67102 15 
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_si3054,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer, 
Live 0x00000000
soundcore 14635 2 snd_hda_codec,snd, Live 0x00000000
parport_pc 32154 0 - Live 0x00000000
ppdev 17423 0 - Live 0x00000000
lp 13359 0 - Live 0x00000000
btusb 31907 0 - Live 0x00000000
bluetooth 444619 22 rfcomm,bnep,btusb, Live 0x00000000
lpc_ich 17000 0 - Live 0x00000000
mac_hid 13099 0 - Live 0x00000000
parport 40945 3 parport_pc,ppdev,lp, Live 0x00000000
hid_generic 12503 0 - Live 0x00000000
usbhid 47478 0 - Live 0x00000000
hid 96347 3 hid_generic,usbhid, Live 0x00000000
i915 956578 3 - Live 0x00000000
psmouse 106642 0 - Live 0x00000000
ahci 25756 2 - Live 0x00000000
libahci 31003 1 ahci, Live 0x00000000
r8169 76265 0 - Live 0x00000000
i2c_algo_bit 13316 1 i915, Live 0x00000000
drm_kms_helper 106489 1 i915, Live 0x00000000
video 20019 1 i915, Live 0x00000000
mii 13693 1 r8169, Live 0x00000000
drm 276577 5 i915,drm_kms_helper, Live 0x00000000

[7.4]
cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0062-0062 : PNP0C09:00
   0062-0062 : EC data
0064-0064 : keyboard
0066-0066 : PNP0C09:00
   0066-0066 : EC cmd
0070-0077 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
   00f0-00f0 : PNP0C04:00
0170-0177 : 0000:00:1f.1
   0170-0177 : ata_piix
01f0-01f7 : 0000:00:1f.1
   01f0-01f7 : ata_piix
0200-020f : pnp 00:02
0260-026f : pnp 00:02
0300-030f : pnp 00:02
0376-0376 : 0000:00:1f.1
   0376-0376 : ata_piix
0378-0387 : pnp 00:02
03c0-03df : vesafb
03f6-03f6 : 0000:00:1f.1
   03f6-03f6 : ata_piix
0680-069f : pnp 00:02
0800-080f : pnp 00:02
0cf8-0cff : PCI conf1
1000-1003 : ACPI PM1a_EVT_BLK
1004-1005 : ACPI PM1a_CNT_BLK
1008-100b : ACPI PM_TMR
1010-1015 : ACPI CPU throttle
1020-1020 : ACPI PM2_CNT_BLK
1028-102f : ACPI GPE0_BLK
1030-1033 : iTCO_wdt
1060-107f : iTCO_wdt
1180-11bf : 0000:00:1f.0
   1180-11bf : pnp 00:02
1640-164f : pnp 00:02
1800-1807 : 0000:00:02.0
1810-181f : 0000:00:1f.1
   1810-181f : ata_piix
1820-183f : 0000:00:1a.0
   1820-183f : uhci_hcd
1840-185f : 0000:00:1a.1
   1840-185f : uhci_hcd
1860-187f : 0000:00:1d.0
   1860-187f : uhci_hcd
1880-189f : 0000:00:1d.1
   1880-189f : uhci_hcd
18a0-18bf : 0000:00:1d.2
   18a0-18bf : uhci_hcd
18d0-18d3 : 0000:00:1f.2
   18d0-18d3 : ahci
18d4-18d7 : 0000:00:1f.2
   18d4-18d7 : ahci
18d8-18df : 0000:00:1f.2
   18d8-18df : ahci
18e0-18ff : 0000:00:1f.2
   18e0-18ff : ahci
1c00-1c07 : 0000:00:1f.2
   1c00-1c07 : ahci
1c20-1c3f : 0000:00:1f.3
2000-2fff : PCI Bus 0000:02
3000-3fff : PCI Bus 0000:04
4000-4fff : PCI Bus 0000:06
   4000-40ff : 0000:06:00.0
     4000-40ff : r8169
fe00-fe00 : pnp 00:02


cat /proc/iomem
00000000-00000fff : reserved
00001000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cf000-000cffff : Adapter ROM
000e0000-000fffff : reserved
   000f0000-000fffff : System ROM
00100000-7f6cffff : System RAM
   01000000-016ef692 : Kernel code
   016ef693-01a9c6ff : Kernel data
   01b8e000-01c52fff : Kernel bss
7f6d0000-7f6defff : ACPI Non-volatile Storage
7f6df000-7fffffff : reserved
   7f800000-7ff7ffff : Graphics Stolen Memory
80000000-800000ff : 0000:00:1f.3
80001000-80001fff : Intel Flush Page
d0000000-dfffffff : 0000:00:02.0
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
   e0000000-efffffff : reserved
     e0000000-efffffff : pnp 00:00
f0000000-f1ffffff : PCI Bus 0000:02
f2000000-f3ffffff : PCI Bus 0000:04
f4000000-f5ffffff : PCI Bus 0000:06
f6000000-f7ffffff : PCI Bus 0000:02
f8000000-f9ffffff : PCI Bus 0000:04
   f8000000-f8001fff : 0000:04:00.0
     f8000000-f8001fff : iwl4965
fa000000-fbffffff : PCI Bus 0000:06
   fa000000-fa000fff : 0000:06:00.0
     fa000000-fa000fff : r8169
   fa020000-fa03ffff : 0000:06:00.0
fc000000-fc0fffff : 0000:00:02.0
fc100000-fc1fffff : 0000:00:02.1
fc400000-fc403fff : 0000:00:1b.0
   fc400000-fc403fff : ICH HD audio
fc404000-fc4047ff : 0000:00:1f.2
   fc404000-fc4047ff : ahci
fc404800-fc404bff : 0000:00:1a.7
   fc404800-fc404bff : ehci_hcd
fc404c00-fc404fff : 0000:00:1d.7
   fc404c00-fc404fff : ehci_hcd
fec00000-fec0ffff : reserved
   fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
   fed00000-fed003ff : reserved
     fed00000-fed003ff : pnp 00:01
fed14000-fed19fff : reserved
   fed14000-fed17fff : pnp 00:00
   fed18000-fed18fff : pnp 00:00
   fed19000-fed19fff : pnp 00:00
fed1c000-fed8ffff : reserved
   fed1c000-fed1ffff : pnp 00:00
     fed1f410-fed1f414 : iTCO_wdt
   fed20000-fed3ffff : pnp 00:00
   fed40000-fed44fff : pnp 00:00
   fed45000-fed8ffff : pnp 00:00
fee00000-fee00fff : Local APIC
   fee00000-fee00fff : reserved
ff000000-ffffffff : reserved
   ff000000-ffffffff : INT0800:00

[7.5]
sudo lspci -vvv
[sudo] password for lilly:
00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory 
Controller Hub (rev 03)
         Subsystem: Elitegroup Computer Systems Device 9037
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR- INTx-
         Latency: 0
         Capabilities: [e0] Vendor Specific Information: Len=0a <?>
         Kernel driver in use: agpgart-intel

00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 
Integrated Graphics Controller (primary) (rev 03) (prog-if 00 [VGA 
controller])
         Subsystem: Elitegroup Computer Systems Device 9037
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 29
         Region 0: Memory at fc000000 (64-bit, non-prefetchable) [size=1M]
         Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
         Region 4: I/O ports at 1800 [size=8]
         Expansion ROM at <unassigned> [disabled]
         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
                 Address: fee0300c  Data: 41a2
         Capabilities: [d0] Power Management version 3
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
                 Bridge: PM- B3+
         Kernel driver in use: i915

00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 
Integrated Graphics Controller (secondary) (rev 03)
         Subsystem: Elitegroup Computer Systems Device 9037
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Region 0: Memory at fc100000 (64-bit, non-prefetchable) [size=1M]
         Capabilities: [d0] Power Management version 3
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
                 Bridge: PM- B3+

00:1a.0 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #4 (rev 03) (prog-if 00 [UHCI])
         Subsystem: Elitegroup Computer Systems Device 90a6
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 16
         Region 4: I/O ports at 1820 [size=32]
         Kernel driver in use: uhci_hcd

00:1a.1 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #5 (rev 03) (prog-if 00 [UHCI])
         Subsystem: Elitegroup Computer Systems Device 90a6
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin B routed to IRQ 21
         Region 4: I/O ports at 1840 [size=32]
         Kernel driver in use: uhci_hcd

00:1a.7 USB controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
Controller #2 (rev 03) (prog-if 20 [EHCI])
         Subsystem: Elitegroup Computer Systems Device 90a6
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin C routed to IRQ 18
         Region 0: Memory at fc404800 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] Debug port: BAR=1 offset=00a0
         Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio 
Controller (rev 03)
         Subsystem: Elitegroup Computer Systems Device 90a6
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 31
         Region 0: Memory at fc400000 (64-bit, non-prefetchable) [size=16K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000fee0300c  Data: 41d2
         Capabilities: [70] Express (v1) Root Complex Integrated 
Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0
                         ExtTag- RBE-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
         Capabilities: [100 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                         Status: NegoPending- InProgress-
                 VC1:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=1 ArbSelect=Fixed TC/VC=80
                         Status: NegoPending- InProgress-
         Capabilities: [130 v1] Root Complex Link
                 Desc:   PortNumber=0f ComponentID=02 EltType=Config
                 Link0:  Desc:   TargetPort=00 TargetComponent=02 
AssocRCRB- LinkType=MemMapped LinkValid+
                         Addr:   00000000fed1c000
         Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express 
Port 1 (rev 03) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=02, subordinate=03, sec-latency=0
         I/O behind bridge: 00002000-00002fff
         Memory behind bridge: f6000000-f7ffffff
         Prefetchable memory behind bridge: 
00000000f0000000-00000000f1ffffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0
                         ExtTag- RBE+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Exit Latency L0s <1us, L1 <4us
                         ClockPM- Surprise- LLActRep+ BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk-
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug+ Surprise+
                         Slot #2, PowerLimit 6.500W; Interlock- NoCompl-
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
                         Changed: MRL- PresDet- LinkState-
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
                 RootCap: CRSVisible-
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                 Address: fee0300c  Data: 41c1
         Capabilities: [90] Subsystem: Elitegroup Computer Systems 
Device 90a6
         Capabilities: [a0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [100 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed+ WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                         Status: NegoPending- InProgress-
         Capabilities: [180 v1] Root Complex Link
                 Desc:   PortNumber=01 ComponentID=02 EltType=Config
                 Link0:  Desc:   TargetPort=00 TargetComponent=02 
AssocRCRB- LinkType=MemMapped LinkValid+
                         Addr:   00000000fed1c001
         Kernel driver in use: pcieport

00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express 
Port 3 (rev 03) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=04, subordinate=05, sec-latency=0
         I/O behind bridge: 00003000-00003fff
         Memory behind bridge: f8000000-f9ffffff
         Prefetchable memory behind bridge: 
00000000f2000000-00000000f3ffffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR+ <PERR-
         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0
                         ExtTag- RBE+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Exit Latency L0s <256ns, L1 <4us
                         ClockPM- Surprise- LLActRep+ BwNot-
                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- 
CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug+ Surprise+
                         Slot #4, PowerLimit 6.500W; Interlock- NoCompl-
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
                         Changed: MRL- PresDet- LinkState-
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
                 RootCap: CRSVisible-
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                 Address: fee0300c  Data: 41e1
         Capabilities: [90] Subsystem: Elitegroup Computer Systems 
Device 90a6
         Capabilities: [a0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [100 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed+ WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                         Status: NegoPending- InProgress-
         Capabilities: [180 v1] Root Complex Link
                 Desc:   PortNumber=03 ComponentID=02 EltType=Config
                 Link0:  Desc:   TargetPort=00 TargetComponent=02 
AssocRCRB- LinkType=MemMapped LinkValid+
                         Addr:   00000000fed1c001
         Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express 
Port 4 (rev 03) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Bus: primary=00, secondary=06, subordinate=07, sec-latency=0
         I/O behind bridge: 00004000-00004fff
         Memory behind bridge: fa000000-fbffffff
         Prefetchable memory behind bridge: 
00000000f4000000-00000000f5ffffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR+ <PERR-
         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0
                         ExtTag- RBE+
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- 
AuxPwr+ TransPend-
                 LnkCap: Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Exit Latency L0s <256ns, L1 <4us
                         ClockPM- Surprise- LLActRep+ BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt- ABWMgmt-
                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- 
HotPlug+ Surprise+
                         Slot #5, PowerLimit 6.500W; Interlock- NoCompl-
                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- 
HPIrq- LinkChg-
                         Control: AttnInd Unknown, PwrInd Unknown, 
Power- Interlock-
                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
                         Changed: MRL- PresDet- LinkState-
                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- 
PMEIntEna- CRSVisible-
                 RootCap: CRSVisible-
                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
         Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
                 Address: fee0300c  Data: 4142
         Capabilities: [90] Subsystem: Elitegroup Computer Systems 
Device 90a6
         Capabilities: [a0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [100 v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed+ WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed+ WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                         Status: NegoPending- InProgress-
         Capabilities: [180 v1] Root Complex Link
                 Desc:   PortNumber=04 ComponentID=02 EltType=Config
                 Link0:  Desc:   TargetPort=00 TargetComponent=02 
AssocRCRB- LinkType=MemMapped LinkValid+
                         Addr:   00000000fed1c001
         Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #1 (rev 03) (prog-if 00 [UHCI])
         Subsystem: Elitegroup Computer Systems Device 90a6
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 23
         Region 4: I/O ports at 1860 [size=32]
         Kernel driver in use: uhci_hcd

00:1d.1 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #2 (rev 03) (prog-if 00 [UHCI])
         Subsystem: Elitegroup Computer Systems Device 90a6
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin B routed to IRQ 19
         Region 4: I/O ports at 1880 [size=32]
         Kernel driver in use: uhci_hcd

00:1d.2 USB controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #3 (rev 03) (prog-if 00 [UHCI])
         Subsystem: Elitegroup Computer Systems Device 90a6
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin C routed to IRQ 18
         Region 4: I/O ports at 18a0 [size=32]
         Kernel driver in use: uhci_hcd

00:1d.7 USB controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
Controller #1 (rev 03) (prog-if 20 [EHCI])
         Subsystem: Elitegroup Computer Systems Device 90a6
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin A routed to IRQ 23
         Region 0: Memory at fc404c00 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] Debug port: BAR=1 offset=00a0
         Kernel driver in use: ehci-pci

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3) 
(prog-if 01 [Subtractive decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: fff00000-000fffff
         Prefetchable memory behind bridge: 
00000000fff00000-00000000000fffff
         Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
         Capabilities: [50] Subsystem: Device 0000:0000

00:1f.0 ISA bridge: Intel Corporation 82801HM (ICH8M) LPC Interface 
Controller (rev 03)
         Subsystem: Elitegroup Computer Systems Device 90a6
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Capabilities: [e0] Vendor Specific Information: Len=0c <?>
         Kernel driver in use: lpc_ich

00:1f.1 IDE interface: Intel Corporation 82801HM/HEM (ICH8M/ICH8M-E) IDE 
Controller (rev 03) (prog-if 8a [Master SecP PriP])
         Subsystem: Elitegroup Computer Systems Device 90a6
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
         Latency: 0
         Interrupt: pin A routed to IRQ 19
         Region 0: I/O ports at 01f0 [size=8]
         Region 1: I/O ports at 03f4
         Region 2: I/O ports at 0170 [size=8]
         Region 3: I/O ports at 0374
         Region 4: I/O ports at 1810 [size=16]
         Kernel driver in use: ata_piix

00:1f.2 SATA controller: Intel Corporation 82801HM/HEM (ICH8M/ICH8M-E) 
SATA Controller [AHCI mode] (rev 03) (prog-if 01 [AHCI 1.0])
         Subsystem: Elitegroup Computer Systems Device 90a6
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Interrupt: pin B routed to IRQ 28
         Region 0: I/O ports at 1c00 [size=8]
         Region 1: I/O ports at 18d4 [size=4]
         Region 2: I/O ports at 18d8 [size=8]
         Region 3: I/O ports at 18d0 [size=4]
         Region 4: I/O ports at 18e0 [size=32]
         Region 5: Memory at fc404000 (32-bit, non-prefetchable) [size=2K]
         Capabilities: [80] MSI: Enable+ Count=1/4 Maskable- 64bit-
                 Address: fee0300c  Data: 4192
         Capabilities: [70] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                 Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
         Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller 
(rev 03)
         Subsystem: Elitegroup Computer Systems Device 90a6
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Interrupt: pin C routed to IRQ 10
         Region 0: Memory at 80000000 (32-bit, non-prefetchable) [size=256]
         Region 4: I/O ports at 1c20 [size=32]

04:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or 
AGN [Kedron] Network Connection (rev 61)
         Subsystem: Intel Corporation Device 1001
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR+ <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 30
         Region 0: Memory at f8000000 (64-bit, non-prefetchable) [size=8K]
         Capabilities: [c8] Power Management version 3
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
                 Address: 00000000fee0300c  Data: 41b2
         Capabilities: [e0] Express (v1) Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<512ns, L1 unlimited
                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 128 bytes
                 DevSta: CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ 
AuxPwr+ TransPend-
                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Exit Latency L0s <128ns, L1 <64us
                         ClockPM+ Surprise- LLActRep- BwNot-
                 LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- 
CommClk+
                         ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr+ BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr+
                 AERCap: First Error Pointer: 14, GenCap- CGenEn- 
ChkCap- ChkEn-
         Capabilities: [140 v1] Device Serial Number 00-13-e8-ff-ff-a3-17-97
         Kernel driver in use: iwl4965

06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 01)
         Subsystem: Elitegroup Computer Systems Device 90a0
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR+ <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 27
         Region 0: I/O ports at 4000 [size=256]
         Region 2: Memory at fa000000 (64-bit, non-prefetchable) [size=4K]
         [virtual] Expansion ROM at fa020000 [disabled] [size=128K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
         Capabilities: [48] Vital Product Data
                 Unknown small resource type 05, will not decode more.
         Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
                 Address: 00000000fee0100c  Data: 4182
         Capabilities: [60] Express (v1) Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<128ns, L1 unlimited
                         ExtTag+ AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                         MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ 
AuxPwr+ TransPend-
                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, 
Exit Latency L0s unlimited, L1 unlimited
                         ClockPM- Surprise- LLActRep- BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
         Capabilities: [84] Vendor Specific Information: Len=4c <?>
         Capabilities: [100 v1] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 AERCap: First Error Pointer: 14, GenCap- CGenEn- 
ChkCap- ChkEn-
         Capabilities: [12c v1] Virtual Channel
                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                 Arb:    Fixed- WRR32- WRR64- WRR128-
                 Ctrl:   ArbSelect=Fixed
                 Status: InProgress-
                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- 
WRR256-
                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
                         Status: NegoPending- InProgress-
         Capabilities: [148 v1] Device Serial Number ad-00-00-00-10-ec-81-36
         Capabilities: [154 v1] Power Budgeting <?>
         Kernel driver in use: r8169

[7.6]
  cat /proc/scsi/scsi
Attached devices:
Host: scsi2 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: TOSHIBA MK2035GS Rev: 2A
   Type:   Direct-Access                    ANSI  SCSI revision: 05


[7.7]
  ls /proc
1     1207  13    1447  1599  1791  1858  1967  2     2094  2622 32   48 
   556  75   824  993        devices      ioports locks sched_debug 
sysvipc
10    1212  130   1479  16    18    1895  1971  20    21    27 322  49 
56   76   862  acpi       diskstats    irq mdstat        schedstat 
thread-self
1012  122   1343  15    17    1812  1897  1972  2006  2131  2721 34   5 
    657  769  887  asound     dma          kallsyms meminfo       scsi 
         timer_list
1018  1221  1350  1516  1725  1820  19    1973  2023  22    29 35   50 
663  771  889  buddyinfo  driver       kcore misc          self 
timer_stats
1036  123   1359  1561  177   1837  1919  1974  2029  2262  3 36   51 
667  78   9    bus        execdomains  keys modules       slabinfo       tty
1047  124   1368  1574  178   1841  1921  1983  2031  23    30 374  52 
674  784  903  cgroups    fb           key-users mounts softirqs 
uptime
1061  125   1370  1579  1781  1846  1922  1984  2032  24    300 375  53 
   675  8    922  cmdline    filesystems  kmsg mtrr          stat 
version
1064  126   1372  1589  1786  1848  1930  1990  2053  25    307 376  546 
  678  808  930  consoles   fs           kpagecount net           swaps 
          vmallocinfo
11    127   1388  1593  1787  1853  1965  1991  2056  26    31 378  550 
  682  816  947  cpuinfo    interrupts   kpageflags pagetypeinfo  sys 
        vmstat
12    128   14    1595  1789  1855  1966  1992  2059  2619  312 4    552 
  7    819  958  crypto     iomem        loadavg partitions 
sysrq-trigger  zoneinfo

[8]
Other notes: Link to the Launchpad bug report:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1412470

Thanks

Wolfgang
