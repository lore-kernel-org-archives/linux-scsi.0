From: "Michael P. Carel" <mikecarel@teamglac.com>
Subject: Re: Address or Write Phase Parity Error in  Adaptec Ultra320(29320)
Date: Mon, 14 Apr 2003 10:43:43 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <001d01c3022f$ab3806c0$8601a8c0@teamglac.com>
References: <005901c30229$735b8c00$8601a8c0@teamglac.com> <2555792704.1050287878@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_001A_01C30272.B7D93AA0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from team5.teamglac.com ([203.87.142.130]:21769 "HELO
	team5.teamglac.com") by vger.kernel.org with SMTP id S262722AbTDNCnP (for <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Apr 2003 22:43:15 -0400
Received: (from root@localhost)
	by team5.teamglac.com (8.9.3/8.9.3) id KAA23210
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2003 10:49:37 +0800
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_001A_01C30272.B7D93AA0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

attached was the dmesg and the lspci output. I'm using EPOX 4G4A with Intel
chipset that have  a 32bit PCI slots.


mike

----- Original Message -----
From: "Justin T. Gibbs" <gibbs@scsiguy.com>
To: "Michael P. Carel" <mikecarel@teamglac.com>;
<linux-scsi@vger.kernel.org>
Sent: Monday, April 14, 2003 10:37 AM
Subject: Re: Address or Write Phase Parity Error in Adaptec Ultra320(29320)


> > Hi,
> >
> > I'm having problem with  my Adaptec Ultra320(29320) in RedHat Linux 7.3
> > with kernel 2.4.18-3 a Address or Write Phase Parity Error always
display on
> > screen and if the system is idle for a long time, the server network
> > crushes. I've already used the driver revision 1.3.6 from the freeBSD
> > website.
> >
> > Can anyone help me please...
>
> Can you send me a full dmesg of your system and the output from
"lspci -vv"?
> Someone is "talking trash" on the PCI bus.  This is a very frequent
problem
> with certain motherboards using VIA chipsets.
>
> --
> Justin
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

------=_NextPart_000_001A_01C30272.B7D93AA0
Content-Type: text/plain;
	name="dmesg.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg.txt"

Linux version 2.4.18-3 (bhcompile@daffy.perf.redhat.com) (gcc version =
2.96 20000731 (Red Hat Linux 7.3 2.96-110)) #1 Thu Apr 18 07:37:53 EDT =
2002
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
On node 0 totalpages: 262128
zone(0): 4096 pages.
zone(1): 225280 pages.
zone(2): 32752 pages.
Kernel command line: auto BOOT_IMAGE=3Dlinux ro root=3D802 =
BOOT_FILE=3D/boot/vmlinuz-2.4.18-3
Initializing CPU#0
Detected 2039.955 MHz processor.
Console: colour VGA+ 80x25
Calibrating delay loop... 4063.23 BogoMIPS
Memory: 1030888k/1048512k available (1119k kernel code, 17236k reserved, =
775k data, 280k init, 131008k highmem)
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
Buffer cache hash table entries: 65536 (order: 6, 262144 bytes)
Page-cache hash table entries: 262144 (order: 8, 1048576 bytes)
CPU: Before vendor init, caps: 3febfbff 00000000 00000000, vendor =3D 0
CPU: L1 I cache: 12K, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: After vendor init, caps: 3febfbff 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU:     After generic, caps: 3febfbff 00000000 00000000 00000000
CPU:             Common caps: 3febfbff 00000000 00000000 00000000
CPU: Intel(R) Pentium(R) 4 CPU 2.00GHz stepping 04
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
mtrr: v1.40 (20010327) Richard Gooch (rgooch@atnf.csiro.au)
mtrr: detected mtrr type: Intel
PCI: PCI BIOS revision 2.10 entry at 0xfae70, last bus=3D2
PCI: Using configuration type 1
PCI: Probing PCI hardware
Unknown bridge resource 0: assuming transparent
Unknown bridge resource 2: assuming transparent
PCI: Using IRQ router PIIX [8086/24c0] at 00:1f.0
PCI: Found IRQ 9 for device 00:1f.1
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux NET4.0 for Linux 2.4
Based upon Swansea University Computer Society NET3.039
Initializing RT netlink socket
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16)
Starting kswapd
allocated 64 pages and 64 bhs reserved for the highmem bounces
VFS: Diskquotas version dquot_6.5.0 initialized
pty: 2048 Unix98 ptys configured
Serial driver version 5.05c (2001-07-08) with MANY_PORTS MULTIPORT =
SHARE_IRQ SERIAL_PCI ISAPNP enabled
ttyS00 at 0x03f8 (irq =3D 4) is a 16550A
ttyS01 at 0x02f8 (irq =3D 3) is a 16550A
Real Time Clock Driver v1.10e
block: 1024 slots per queue, batch=3D256
Uniform Multi-Platform E-IDE driver Revision: 6.31
ide: Assuming 33MHz system bus speed for PIO modes; override with =
idebus=3Dxx
PCI_IDE: unknown IDE controller on PCI bus 00 device f9, VID=3D8086, =
DID=3D24cb
PCI: Device 00:1f.1 not available because of resource collisions
PCI_IDE: (ide_setup_pci_device:) Could not enable device.
hda: CD-540E, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide-floppy driver 0.99.newide
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
ide-floppy driver 0.99.newide
md: md driver 0.90.0 MAX_MD_DEVS=3D256, MD_SB_DISKS=3D27
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP, IGMP
IP: routing cache hash table of 8192 buckets, 64Kbytes
TCP: Hash tables configured (established 262144 bind 65536)
Linux IP multicast router 0.06 plus PIM-SM
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
RAMDISK: Compressed image found at block 0
Freeing initrd memory: 295k freed
VFS: Mounted root (ext2 filesystem).
SCSI subsystem driver Revision: 1.00
kmod: failed to exec /sbin/modprobe -s -k scsi_hostadapter, errno =3D 2
PCI: Found IRQ 11 for device 02:02.0
PCI: Found IRQ 10 for device 02:02.1
scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.6
        <Adaptec 29320 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel A, SCSI Id=3D7, PCI 33 or 66Mhz, =
512 SCBs

scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.6
        <Adaptec 29320 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel B, SCSI Id=3D7, PCI 33 or 66Mhz, =
512 SCBs

blk: queue f7e61a18, I/O limit 4095Mb (mask 0xffffffff)
(scsi1:A:0): 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
(scsi1:A:1): 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
  Vendor: SEAGATE   Model: ST336607LW        Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue f7865a18, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: SEAGATE   Model: ST336607LW        Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue f7865c18, I/O limit 4095Mb (mask 0xffffffff)
scsi1:A:0:0: Tagged Queuing enabled.  Depth 32
scsi1:A:1:0: Tagged Queuing enabled.  Depth 32
Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi1, channel 0, id 1, lun 0
SCSI device sda: 71687372 512-byte hdwr sectors (36704 MB)
Partition check:
 sda: sda1 sda2 sda3 sda4 < sda5 >
SCSI device sdb: 71687372 512-byte hdwr sectors (36704 MB)
 sdb: sdb1 sdb2 sdb3
Journalled Block Device driver loaded
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Freeing unused kernel memory: 280k freed
Adding Swap: 2048276k swap-space (priority -1)
Adding Swap: 2048248k swap-space (priority -2)
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on sd(8,2), internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on sd(8,1), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on sd(8,3), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on sd(8,18), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on sd(8,17), internal journal
EXT3-fs: mounted filesystem with ordered data mode.

------=_NextPart_000_001A_01C30272.B7D93AA0
Content-Type: application/octet-stream;
	name="lspci.out"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="lspci.out"

00:00.0 Host bridge: Intel Corp.: Unknown device 2560 (rev 01)
	Subsystem: Unknown device 1695:4002
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Region 0: Memory at d8000000 (32-bit, prefetchable) [size=3D64M]
	Capabilities: [e4] #09 [0105]
	Capabilities: [a0] AGP version 2.0
		Status: RQ=3D31 SBA+ 64bit- FW+ Rate=3Dx1,x2
		Command: RQ=3D0 SBA- AGP- 64bit- FW- Rate=3D<none>

00:01.0 PCI bridge: Intel Corp.: Unknown device 2561 (rev 01) (prog-if =
00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D32
	Memory behind bridge: dc000000-ddffffff
	Prefetchable memory behind bridge: d0000000-d7ffffff
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-

00:1e.0 PCI bridge: Intel Corp. 82801BA/CA PCI Bridge (rev 81) (prog-if =
00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR+
	Latency: 0
	Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D32
	I/O behind bridge: 00009000-0000afff
	Memory behind bridge: de000000-dfffffff
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corp.: Unknown device 24c0 (rev 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR+
	Latency: 0

00:1f.1 IDE interface: Intel Corp.: Unknown device 24cb (rev 01) =
(prog-if 8a [Master SecP PriP])
	Subsystem: Unknown device 1695:4002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 9
	Region 0: I/O ports at <unassigned> [size=3D8]
	Region 1: I/O ports at <unassigned> [size=3D4]
	Region 2: I/O ports at <unassigned> [size=3D8]
	Region 3: I/O ports at <unassigned> [size=3D4]
	Region 4: I/O ports at f000 [size=3D16]
	Region 5: Memory at 40000000 (32-bit, non-prefetchable) [size=3D1K]

00:1f.3 SMBus: Intel Corp.: Unknown device 24c3 (rev 01)
	Subsystem: Unknown device 1695:4002
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 5
	Region 4: I/O ports at 0500 [size=3D32]

01:00.0 VGA compatible controller: nVidia Corporation NV11 [GeForce2 MX] =
(rev b2) (prog-if 00 [VGA])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (1250ns min, 250ns max)
	Interrupt: pin A routed to IRQ 9
	Region 0: Memory at dc000000 (32-bit, non-prefetchable) [size=3D16M]
	Region 1: Memory at d0000000 (32-bit, prefetchable) [size=3D128M]
	Expansion ROM at <unassigned> [disabled] [size=3D64K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [44] AGP version 2.0
		Status: RQ=3D31 SBA- 64bit- FW- Rate=3Dx1,x2
		Command: RQ=3D0 SBA- AGP- 64bit- FW- Rate=3D<none>

02:00.0 Ethernet controller: Davicom Semiconductor, Inc. Ethernet 100/10 =
MBit (rev 31)
	Subsystem: Unknown device 3030:5032
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR+
	Latency: 32 (5000ns min, 10000ns max)
	Interrupt: pin A routed to IRQ 5
	Region 0: I/O ports at 9000 [size=3D256]
	Region 1: Memory at df004000 (32-bit, non-prefetchable) [size=3D256]
	Expansion ROM at <unassigned> [disabled] [size=3D256K]
	Capabilities: [50] Power Management version 1
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

02:02.0 SCSI storage controller: Adaptec: Unknown device 8012 (rev 03)
	Subsystem: Adaptec: Unknown device 0042
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (10000ns min, 6250ns max), cache line size 08
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 9400 [disabled] [size=3D256]
	Region 1: Memory at df000000 (64-bit, non-prefetchable) [size=3D8K]
	Region 3: I/O ports at 9800 [disabled] [size=3D256]
	Expansion ROM at <unassigned> [disabled] [size=3D512K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=3D0/1 =
Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [94] PCI-X non-bridge device.
		Command: DPERE- ERO+ RBC=3D0 OST=3D4
		Status: Bus=3D0 Dev=3D0 Func=3D0 64bit- 133MHz- SCD- USC-, =
DC=3Dsimple, DMMRBC=3D0, DMOST=3D0, DMCRS=3D0, RSCEM-

02:02.1 SCSI storage controller: Adaptec: Unknown device 8012 (rev 03)
	Subsystem: Adaptec: Unknown device 0042
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- =
Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (10000ns min, 6250ns max), cache line size 08
	Interrupt: pin B routed to IRQ 10
	Region 0: I/O ports at 9c00 [disabled] [size=3D256]
	Region 1: Memory at df002000 (64-bit, non-prefetchable) [size=3D8K]
	Region 3: I/O ports at a000 [disabled] [size=3D256]
	Expansion ROM at <unassigned> [disabled] [size=3D512K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA =
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=3D0/1 =
Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [94] PCI-X non-bridge device.
		Command: DPERE- ERO+ RBC=3D0 OST=3D4
		Status: Bus=3D0 Dev=3D0 Func=3D0 64bit- 133MHz- SCD- USC-, =
DC=3Dsimple, DMMRBC=3D0, DMOST=3D0, DMCRS=3D0, RSCEM-


------=_NextPart_000_001A_01C30272.B7D93AA0--

