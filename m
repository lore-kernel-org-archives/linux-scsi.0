From: Stefan Berder <sbe@oleane.net>
Subject: Re: Problem with megaraid and PERC3/dc on a poweredge 6450
Date: Thu, 6 Jan 2005 18:13:51 +0100
Message-ID: <20050106181351.3d4ddf88@gibson>
References: <0E3FA95632D6D047BA649F95DAB60E57058C01AD@exa-atlanta>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Thu__6_Jan_2005_18_13_51_+0100_PJwY.ZnPPG=4jOx0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postcard.dih.oleane.net ([213.56.0.19]:16908 "EHLO
	postcard.dih.oleane.net") by vger.kernel.org with ESMTP
	id S262915AbVAFRNx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jan 2005 12:13:53 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57058C01AD@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.

--Multipart=_Thu__6_Jan_2005_18_13_51_+0100_PJwY.ZnPPG=4jOx0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On Thu, 6 Jan 2005 09:13:32 -0500=20
"Mukker, Atul" <Atulm@lsil.com> wrote:

> Thanks for the files. Both of these controllers should work with the
> new drivers, megaraid_mbox and megaraid_mm. Now, I am waiting on the
> kernel messages, before suggesting a prognosis. I am sure you know how
> to collect the messages by re-directing them to a serial console?

Done, a weird thing is that the megaraid_mm driver no more panics ...
but it does some timeout things I don't have in 2.4.28 with megaraid2.

Sorry for the noise ...

Stefan

--=20
 #=3D- Stefan Berder                  tel : 6 14 80        -=3D#
 #=3D- Ing=E9nieur syst=E8me et r=E9seau          01 53 95 14 80 -=3D#
 #=3D- TRANSPAC / DO-DAE-ADMG        mail : sbe@oleane.net -=3D#
 #=3D- /(bb|[^b]{2})/      stefan.berder@francetelecom.com -=3D#

--Multipart=_Thu__6_Jan_2005_18_13_51_+0100_PJwY.ZnPPG=4jOx0
Content-Type: text/plain;
 name="2.6.10-megaraid_mm-boot.txt"
Content-Disposition: attachment;
 filename="2.6.10-megaraid_mm-boot.txt"
Content-Transfer-Encoding: 7bit

Linux version 2.6.10-bruce2.6 (root@brucelee) (gcc version 3.3.4 (Debian 1:3.3.5
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 0000000000100000 - 000000003fffe000 (usable)
 BIOS-e820: 000000003fffe000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000fe710
DMI 2.3 present.
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:10 APIC version 17
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x00] enabled)
Processor #0 6:10 APIC version 17
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-15
ACPI: IOAPIC (id[0x03] address[0xfec01000] gsi_base[16])
IOAPIC[1]: apic_id 3, version 17, address 0xfec01000, GSI 16-31
Enabling APIC mode:  Flat.  Using 2 I/O APICs
Using ACPI (MADT) for SMP configuration information
Built 1 zonelists
Kernel command line: BOOT_IMAGE=Linux ro root=802 console=tty0 console=ttyS0,960
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 65536 bytes)
Detected 699.583 MHz processor.
Using tsc for high-res timesource
Console: colour VGA+ 80x50
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1034324k/1048568k available (2595k kernel code, 13668k reserved, 1204k )
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 1024K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
 tbxface-0118 [02] acpi_load_tables      : ACPI Tables successfully acquired
Parsing all Control Methods:....................................................
Table [DSDT](id F004) - 767 Objects with 95 Devices 245 Methods 66 Regions
ACPI Namespace successfully loaded at root c051c680
evxfevnt-0094 [03] acpi_enable           : Transition to ACPI mode successful
CPU0: Intel Pentium III (Cascades) stepping 01
per-CPU timeslice cutoff: 2927.35 usecs.
task migration cache decay timeout: 3 msecs.
Booting processor 1/0 eip 2000
Initializing CPU#1
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 1024K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel Pentium III (Cascades) stepping 01
Total of 2 processors activated (2777.08 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 pin1=0 pin2=-1
checking TSC synchronization across 2 CPUs: passed.
Brought up 2 CPUs
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfc7ee, last bus=16
PCI: Using configuration type 1
mtrr: v2.0 (20020519)
ACPI: Subsystem revision 20041105
evgpeblk-0979 [06] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-0987 [06] ev_create_gpe_block   : Found 1 Wake, Enabled 0 Runtime GPEsk
evgpeblk-0979 [06] ev_create_gpe_block   : GPE 20 to 3F [_GPE] 4 regs on int 0x9
evgpeblk-0987 [06] ev_create_gpe_block   : Found 1 Wake, Enabled 1 Runtime GPEsk
Completing Region/Field/Buffer/Package initialization:..........................
Initialized 66/66 Regions 0/0 Fields 17/17 Buffers 13/15 Packages (776 nodes)
Executing all Device _STA and_INI methods:...................................[A3
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
..[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
..................
101 Devices found containing: 101 _STA, 0 _INI methods
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (00:00)
PCI: Probing PCI hardware (bus 00)
[ACPI Debug] Integer: 0x00000003
ACPI: PCI Root Bridge [PCI1] (00:03)
PCI: Probing PCI hardware (bus 03)
[ACPI Debug] Integer: 0x00000010
ACPI: PCI Root Bridge [PCI2] (00:10)
PCI: Probing PCI hardware (bus 10)
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 9 10 11 12 14) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 9 10 *11 12 14)
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 9 *10 11 12 14)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 6 7 9 10 11 12 14) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 9 10 11 12 14) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 *5 6 7 9 10 11 12 14)
ACPI: PCI Interrupt Link [LNK6] (IRQs 3 4 5 6 7 9 10 11 12 14) *0, disabled.
ACPI: PCI Interrupt Link [LNK7] (IRQs 3 4 5 6 7 9 *10 11 12 14)
ACPI: PCI Interrupt Link [LNK8] (IRQs 3 4 5 6 7 9 10 *11 12 14)
ACPI: PCI Interrupt Link [LNK9] (IRQs 3 4 *5 6 7 9 10 11 12 14)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 12 14)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14) *0, disabled.
ACPI: PCI Interrupt Link [LUSB] (IRQs 3 4 5 6 7 *10 11 12 14)
SCSI subsystem initialized
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
** PCI interrupts are no longer routed automatically.  If this
** causes a device to stop working, it is probably because the
** driver failed to call pci_enable_device().  As a temporary
** workaround, the "pci=routeirq" argument restores the old
** behavior.  If this argument makes the device work again,
** please email the output of "lspci" to bjorn.helgaas@hp.com
** so I can fix the driver.
[ACPI Debug] String: [0x09] "MEM _CRS."
[ACPI Debug] Buffer: [0x4A]highmem bounce pool size: 64 pages
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Initializing Cryptographic API

testing md5
test 1:
d41d8cd98f00b204e9800998ecf8427e
pass
test 2:
0cc175b9c0f1b6a831c399e269772661
pass
test 3:
900150983cd24fb0d6963f7d28e17f72
pass
test 4:
f96b697d7cb7938d525a2f31aaf161d0
pass
test 5:
c3fcd3d76192e4007dfb496cca67e13b
pass
test 6:
d174ab98d277d9f5a5611c2c9f419d9f
pass
test 7:
57edf4a22be3c955ac49da2e2107b67a
pass
testing md5 across pages
test 1:
c3fcd3d76192e4007dfb496cca67e13b
pass

testing sha1
failed to load transform for sha1

testing des ECB encryption 
test 1 (64 bit key):
c95744256a5ed31d
pass
test 2 (64 bit key):
f79c892a338f4a8b
pass
test 3 (64 bit key):
690f5b0d9a26939b
pass
test 4 (64 bit key):
c95744256a5ed31df79c892a338f4a8bb49926f71fe1d490
pass
test 5 (64 bit key):
setkey() failed flags=100100
c95744256a5ed31d
pass

testing des ECB encryption across pages (chunking) 
test 1 (64 bit key):
page 0
c95744256a5ed31d
pass
page 1
f79c892a338f4a8b
pass
test 2 (64 bit key):
page 0
c95744256a5ed31df79c892a338f
pass
page 1
4a8bb49926f71fe1d490
pass
page 2
f79c892a338f4a8b
pass
test 3 (64 bit key):
page 0
c957
pass
page 1
44
pass
page 2
256a5e
pass
page 3
d31df79c892a338f4a8bb49926f71fe1d490
pass
test 4 (64 bit key):
page 0
c957
pass
page 1
4425
pass
page 2
6a5e
pass
page 3
d31d
pass
page 4
f79c892a338f4a8b
pass
test 5 (64 bit key):
page 0
c9
pass
page 1
57
pass
page 2
44
pass
page 3
25
pass
page 4
6a
pass
page 5
5e
pass
page 6
d3
pass
page 7
1d
pass

testing des ECB decryption 
test 1 (64 bit key):
0123456789abcde7
pass
test 2 (64 bit key):
01a1d6d039776742
pass

testing des ECB decryption across pages (chunking) 
test 1 (64 bit key):
page 0
0123456789abcde7
pass
page 1
a3997bcaaf69a0f5
pass
test 2 (64 bit key):
page 0
012345
pass
page 1
6789abcde7a3997bcaaf69a0
pass
page 2
f5
pass

testing des CBC encryption 
test 1 (64 bit key):
ccd173ffab2039f4acd8aefddfd8a1eb468e91157888ba68
pass
test 2 (64 bit key):
e5c7cdde872bf27c
pass
test 3 (64 bit key):
43e934008c389c0f
pass
test 4 (64 bit key):
683788499a7c05f6
pass

testing des CBC encryption across pages (chunking) 
test 1 (64 bit key):
page 0
ccd173ffab2039f4acd8aefddf
pass
page 1
d8a1eb468e91157888ba68
pass

testing des CBC decryption 
test 1 (64 bit key):
4e6f772069732074
pass
test 2 (64 bit key):
68652074696d6520
pass
test 3 (64 bit key):
666f7220616c6c20
pass

testing des CBC decryption across pages (chunking) 
test 1 (64 bit key):
page 0
666f7220
pass
page 1
616c6c20
pass

testing des3_ede ECB encryption 
test 1 (192 bit key):
18d748e563620572
pass
test 2 (192 bit key):
c07d2a0fa566fa30
pass
test 3 (192 bit key):
e1ef62c332fe825b
pass

testing des3_ede ECB encryption across pages (chunking) 

testing des3_ede ECB decryption 
test 1 (192 bit key):
736f6d6564617461
pass
test 2 (192 bit key):
7371756967676c65
pass
test 3 (192 bit key):
0000000000000000
pass

testing des3_ede ECB decryption across pages (chunking) 

testing md4
failed to load transform for md4

testing sha256
failed to load transform for sha256

testing blowfish ECB encryption 
test 1 (64 bit key):
4ef997456198dd78
pass
test 2 (64 bit key):
a790795108ea3cae
pass
test 3 (64 bit key):
e87a244e2cc85e82
pass
test 4 (128 bit key):
93142887ee3be15c
pass
test 5 (168 bit key):
e6f51ed79b9db21f
pass
test 6 (448 bit key):
c04504012e4e1f53
pass

testing blowfish ECB encryption across pages (chunking) 

testing blowfish ECB decryption 
test 1 (64 bit key):
0000000000000000
pass
test 2 (64 bit key):
0123456789abcdef
pass
test 3 (64 bit key):
fedcba9876543210
pass
test 4 (128 bit key):
fedcba9876543210
pass
test 5 (168 bit key):
fedcba9876543210
pass
test 6 (448 bit key):
fedcba9876543210
pass

testing blowfish ECB decryption across pages (chunking) 

testing blowfish CBC encryption 
test 1 (128 bit key):
6b77b4d63006dee605b156e27403979358deb9e7154616d959f1652bd5ff92cc
pass

testing blowfish CBC encryption across pages (chunking) 

testing blowfish CBC decryption 
test 1 (128 bit key):
37363534333231204e6f77206973207468652074696d6520666f722000000000
pass

testing blowfish CBC decryption across pages (chunking) 

testing twofish ECB encryption 
failed to load transform for twofish ECB

testing twofish ECB decryption 
failed to load transform for twofish ECB

testing twofish CBC encryption 
failed to load transform for twofish CBC

testing twofish CBC decryption 
failed to load transform for twofish CBC

testing serpent ECB encryption 
failed to load transform for serpent ECB

testing serpent ECB decryption 
failed to load transform for serpent ECB

testing tnepres ECB encryption 
failed to load transform for tnepres ECB

testing tnepres ECB decryption 
failed to load transform for tnepres ECB

testing aes ECB encryption 
test 1 (128 bit key):
69c4e0d86a7b0430d8cdb78070b4c55a
pass
test 2 (192 bit key):
dda97ca4864cdfe06eaf70a0ec0d7191
pass
test 3 (256 bit key):
8ea2b7ca516745bfeafc49904b496089
pass

testing aes ECB encryption across pages (chunking) 

testing aes ECB decryption 
test 1 (128 bit key):
00112233445566778899aabbccddeeff
pass
test 2 (192 bit key):
00112233445566778899aabbccddeeff
pass
test 3 (256 bit key):
00112233445566778899aabbccddeeff
pass

testing aes ECB decryption across pages (chunking) 

testing cast5 ECB encryption 
failed to load transform for cast5 ECB

testing cast5 ECB decryption 
failed to load transform for cast5 ECB

testing cast6 ECB encryption 
failed to load transform for cast6 ECB

testing cast6 ECB decryption 
failed to load transform for cast6 ECB

testing arc4 ECB encryption 
failed to load transform for arc4 ECB

testing arc4 ECB decryption 
failed to load transform for arc4 ECB

testing tea ECB encryption 
failed to load transform for tea ECB

testing tea ECB decryption 
failed to load transform for tea ECB

testing xtea ECB encryption 
failed to load transform for xtea ECB

testing xtea ECB decryption 
failed to load transform for xtea ECB

testing khazad ECB encryption 
failed to load transform for khazad ECB

testing khazad ECB decryption 
failed to load transform for khazad ECB

testing anubis ECB encryption 
failed to load transform for anubis ECB

testing anubis ECB decryption 
failed to load transform for anubis ECB

testing anubis CBC encryption 
failed to load transform for anubis CBC

testing anubis CBC decryption 
failed to load transform for anubis CBC

testing sha384
failed to load transform for sha384

testing sha512
failed to load transform for sha512

testing wp512
failed to load transform for wp512

testing wp384
failed to load transform for wp384

testing wp256
failed to load transform for wp256

testing deflate compression
failed to load transform for deflate

testing crc32c
testing crc32c initialized to 00000000: pass
testing crc32c setkey returns 12345678 : pass
testing crc32c using update/final:
 0e2c157f:OK e980ebf6:OK de74bded:OK d579c862:OK ba979ad0:OK 2b29d913:OK
testing crc32c using incremental accumulator:
 24c5d375:OK
testing crc32c using digest:
 24c5d375:OK
pass
crc32c test complete

testing michael_mic
failed to load transform for michael_mic
vesafb: probe of vesafb0 failed with error -6
Real Time Clock Driver v1.12
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
elevator: using anticipatory as default io scheduler
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
e100: Intel(R) PRO/100 Network Driver, 3.2.3-k2-NAPI
e100: Copyright(c) 1999-2004 Intel Corporation
ACPI: PCI interrupt 0000:00:08.0[A] -> GSI 26 (level, low) -> IRQ 26
e100: eth0: e100_probe: addr 0xfbefb000, irq 26, MAC addr 00:B0:D0:EA:24:FE
ACPI: PCI interrupt 0000:03:0b.0[A] -> GSI 25 (level, low) -> IRQ 25
e100: eth1: e100_probe: addr 0xfa5ff000, irq 25, MAC addr 00:02:B3:65:5E:00
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SvrWks OSB4: IDE controller at PCI slot 0000:00:0f.1
SvrWks OSB4: chipset revision 0
SvrWks OSB4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x08b0-0x08b7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x08b8-0x08bf, BIOS settings: hdc:pio, hdd:pio
hda: TEAC CD-ROM CD-224E, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: ATAPI 24X CD-ROM drive, 128kB Cache, (U)DMA
Uniform CD-ROM driver Revision: 3.20
ACPI: PCI interrupt 0000:00:05.0[A] -> GSI 17 (level, low) -> IRQ 17
ACPI: PCI interrupt 0000:00:05.1[B] -> GSI 18 (level, low) -> IRQ 18
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs

qla1280: Skipping AMI SubSys Vendor ID Chip
qla1280: Skipping AMI SubSys Vendor ID Chip
megaraid cmm: 2.20.2.3 (Release Date: Thu Dec  9 19:02:14 EST 2004)
megaraid: 2.20.4.1 (Release Date: Thu Nov  4 17:44:59 EST 2004)
megaraid: probe new device 0x101e:0x1960:0x1028:0x0493: bus 5:slot 0:func 0
ACPI: PCI interrupt 0000:05:00.0[A] -> GSI 23 (level, low) -> IRQ 23
megaraid: fw version:[1.57] bios version:[3.13]
scsi2 : LSI Logic MegaRAID driver
scsi[2]: scanning scsi channel 0 [Phy 0] for non-raid devices
  Vendor: DELL      Model: 1x4 U2W SCSI BP   Rev: 1.27
  Type:   Processor                          ANSI SCSI revision: 02
scsi[2]: scanning scsi channel 1 [Phy 1] for non-raid devices
  Vendor: Dell      Model: 12 BAY U2W CU     Rev: 0209
  Type:   Processor                          ANSI SCSI revision: 03
megaraid: aborting-90 cmd=a0 <c=1 t=15 l=0>
megaraid abort: 90:0[1:15], fw owner
megaraid: reseting the host...
megaraid: 1 outstanding commands. Max wait 180 sec
megaraid mbox: Wait for 1 commands to complete:180
megaraid mbox: Wait for 1 commands to complete:175
megaraid mbox: Wait for 1 commands to complete:170
megaraid mbox: Wait for 1 commands to complete:165
megaraid mbox: Wait for 1 commands to complete:160
megaraid mbox: Wait for 1 commands to complete:155
megaraid mbox: Wait for 1 commands to complete:150
megaraid mbox: Wait for 1 commands to complete:145
megaraid mbox: Wait for 1 commands to complete:140
megaraid mbox: Wait for 1 commands to complete:135
megaraid mbox: Wait for 1 commands to complete:130
megaraid mbox: Wait for 1 commands to complete:125
megaraid mbox: Wait for 1 commands to complete:120
megaraid mbox: reset sequence completed sucessfully
megaraid: aborting-91 cmd=a0 <c=1 t=15 l=0>
megaraid abort: 91:0[1:15], fw owner
megaraid: reseting the host...
megaraid: 1 outstanding commands. Max wait 180 sec
megaraid mbox: Wait for 1 commands to complete:180
megaraid mbox: Wait for 1 commands to complete:175
megaraid mbox: Wait for 1 commands to complete:170
megaraid mbox: Wait for 1 commands to complete:165
megaraid mbox: Wait for 1 commands to complete:160
megaraid mbox: Wait for 1 commands to complete:155
megaraid mbox: Wait for 1 commands to complete:150
megaraid mbox: reset sequence completed sucessfully
megaraid: aborting-92 cmd=a0 <c=1 t=15 l=0>
megaraid abort: 92:0[1:15], fw owner
megaraid: reseting the host...
megaraid: 1 outstanding commands. Max wait 180 sec
megaraid mbox: Wait for 1 commands to complete:180
megaraid mbox: reset sequence completed sucessfully
  Vendor: Dell      Model: 12 BAY U2W CU     Rev: 0209
  Type:   Processor                          ANSI SCSI revision: 03
  Vendor: Dell      Model: 12 BAY U2W CU     Rev: 0209
  Type:   Processor                          ANSI SCSI revision: 03
  Vendor: Dell      Model: 12 BAY U2W CU     Rev: 0209
  Type:   Processor                          ANSI SCSI revision: 03
  Vendor: Dell      Model: 12 BAY U2W CU     Rev: 0209
  Type:   Processor                          ANSI SCSI revision: 03
  Vendor: Dell      Model: 12 BAY U2W CU     Rev: 0209
  Type:   Processor                          ANSI SCSI revision: 03
  Vendor: Dell      Model: 12 BAY U2W CU     Rev: 0209
  Type:   Processor                          ANSI SCSI revision: 03
  Vendor: Dell      Model: 12 BAY U2W CU     Rev: 0209
  Type:   Processor                          ANSI SCSI revision: 03
scsi[2]: scanning scsi channel 2 [virtual] for logical drives
  Vendor: MegaRAID  Model: LD0 RAID1 34678R  Rev: 1.57
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: MegaRAID  Model: LD1 RAID5 46780R  Rev: 1.57
  Type:   Direct-Access                      ANSI SCSI revision: 02
megaraid: probe new device 0x101e:0x1960:0x1028:0x0493: bus 7:slot 0:func 0
ACPI: PCI interrupt 0000:07:00.0[A] -> GSI 24 (level, low) -> IRQ 24
megaraid: fw version:[161J] bios version:[3.17]
megaraid: cluster firmware, initiator ID: 14
scsi3 : LSI Logic MegaRAID driver
scsi[3]: scanning scsi channel 0 [Phy 0] for non-raid devices
scsi[3]: scanning scsi channel 1 [Phy 1] for non-raid devices
scsi[3]: scanning scsi channel 2 [virtual] for logical drives
SCSI device sda: 71020544 512-byte hdwr sectors (36363 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
SCSI device sda: 71020544 512-byte hdwr sectors (36363 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
 sda: sda1 sda2
Attached scsi disk sda at scsi2, channel 2, id 0, lun 0
SCSI device sdb: 710205440 512-byte hdwr sectors (363625 MB)
sdb: asking for cache data failed
sdb: assuming drive cache: write through
SCSI device sdb: 710205440 512-byte hdwr sectors (363625 MB)
sdb: asking for cache data failed
sdb: assuming drive cache: write through
 sdb: sdb1
Attached scsi disk sdb at scsi2, channel 2, id 1, lun 0
ACPI: PCI Interrupt Link [LUSB] enabled at IRQ 10
ACPI: PCI interrupt 0000:00:0f.2[A] -> GSI 10 (level, low) -> IRQ 10
ohci_hcd 0000:00:0f.2: ServerWorks OSB4/CSB5 OHCI USB Controller
ohci_hcd 0000:00:0f.2: irq 10, pci mem 0xfbefa000
ohci_hcd 0000:00:0f.2: new USB bus registered, assigned bus number 1
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard on isa0060/serio0
input: ImPS/2 Logitech Wheel Mouse on isa0060/serio1
device-mapper: 4.3.0-ioctl (2004-09-30) initialised: dm-devel@redhat.com
NET: Registered protocol family 2
IP: routing cache hash table of 8192 buckets, 64Kbytes
TCP: Hash tables configured (established 262144 bind 65536)
ip_conntrack version 2.1 (8191 buckets, 65528 max) - 180 bytes per conntrack
ip_tables: (C) 2000-2002 Netfilter core team
arp_tables: (C) 2002 David S. Miller
NET: Registered protocol family 1
NET: Registered protocol family 17
Starting balanced_irq
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 240k freed
INIT: version 2.86 booting
mount: wrong fs type, bad option, bad superblock on tmpfs,
       or too many mounted file systems
Setting disc parameters: done.
Activating swap.Adding 1000424k swap on /dev/sda1.  Priority:-1 extents:1

Checking root file system...
fsck 1.35 (28-Feb-2004)
/dev/sda2: cleanEXT3 FS on sda2, , 57469/4316928 internal journal
files, 379442/8627456 blocks
mount: wrong fs type, bad option, bad superblock on tmpfs,
       or too many mounted file systems
System time was Thu Jan  6 18:08:35 UTC 2005.
Setting the System Clock using the Hardware Clock as reference...
System Clock set. System local time is now Thu Jan  6 18:08:37 UTC 2005.
Calculating module dependencies... done.
Loading modules...
    e100
FATAL: Module e100 not found.
All modules loaded.
Creating device-mapper devices...done.
Checking all file systems...
fsck 1.35 (28-Feb-2004)
Setting kernel variables ...
... done.
Mounting local filesystems...
Cleaning /tmp /var/run /var/lock.
mount: wrong fs type, bad option, bad superblock on tmpfs,
       or too many mounted file systems
Running 0dns-down to make sure resolv.conf is ok...done.
Cleaning: /etc/network/ifstate.
Setting up IP spoofing protection: rp_filter.
Configuring network interfaces...e100: eth0: e100_watchdog: link up, 100Mbps, fx
done.
Loading the saved-state of the serial devices... 
/dev/ttyS0 at 0x03f8 (irq = 4) is a 16550A
/dev/ttyS1 at 0x02f8 (irq = 3) is a 16550A

Setting the System Clock using the Hardware Clock as reference...
...

--Multipart=_Thu__6_Jan_2005_18_13_51_+0100_PJwY.ZnPPG=4jOx0
Content-Type: text/plain;
 name="2.6.10-megaraid-boot.txt"
Content-Disposition: attachment;
 filename="2.6.10-megaraid-boot.txt"
Content-Transfer-Encoding: 7bit

Linux version 2.6.10-bruce2.6 (root@brucelee) (gcc version 3.3.4 (Debian 1:3.3.5
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 0000000000100000 - 000000003fffe000 (usable)
 BIOS-e820: 000000003fffe000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000fe710
DMI 2.3 present.
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:10 APIC version 17
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x00] enabled)
Processor #0 6:10 APIC version 17
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-15
ACPI: IOAPIC (id[0x03] address[0xfec01000] gsi_base[16])
IOAPIC[1]: apic_id 3, version 17, address 0xfec01000, GSI 16-31
Enabling APIC mode:  Flat.  Using 2 I/O APICs
Using ACPI (MADT) for SMP configuration information
Built 1 zonelists
Kernel command line: BOOT_IMAGE=Linux ro root=802 console=ttyS0,9600
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 65536 bytes)
Detected 699.574 MHz processor.
Using tsc for high-res timesource
Console: colour VGA+ 80x50
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1034324k/1048568k available (2597k kernel code, 13668k reserved, 1202k )
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 1024K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
 tbxface-0118 [02] acpi_load_tables      : ACPI Tables successfully acquired
Parsing all Control Methods:....................................................
Table [DSDT](id F004) - 767 Objects with 95 Devices 245 Methods 66 Regions
ACPI Namespace successfully loaded at root c051c680
evxfevnt-0094 [03] acpi_enable           : Transition to ACPI mode successful
CPU0: Intel Pentium III (Cascades) stepping 01
per-CPU timeslice cutoff: 2927.35 usecs.
task migration cache decay timeout: 3 msecs.
Booting processor 1/0 eip 2000
Initializing CPU#1
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 1024K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel Pentium III (Cascades) stepping 01
Total of 2 processors activated (2777.08 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 pin1=0 pin2=-1
checking TSC synchronization across 2 CPUs: passed.
Brought up 2 CPUs
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfc7ee, last bus=16
PCI: Using configuration type 1
mtrr: v2.0 (20020519)
ACPI: Subsystem revision 20041105
evgpeblk-0979 [06] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-0987 [06] ev_create_gpe_block   : Found 1 Wake, Enabled 0 Runtime GPEsk
evgpeblk-0979 [06] ev_create_gpe_block   : GPE 20 to 3F [_GPE] 4 regs on int 0x9
evgpeblk-0987 [06] ev_create_gpe_block   : Found 1 Wake, Enabled 1 Runtime GPEsk
Completing Region/Field/Buffer/Package initialization:..........................
Initialized 66/66 Regions 0/0 Fields 17/17 Buffers 13/15 Packages (776 nodes)
Executing all Device _STA and_INI methods:...................................[A3
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
.[ACPI Debug] Integer: 0x00000003
..[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
.[ACPI Debug] Integer: 0x00000010
..................
101 Devices found containing: 101 _STA, 0 _INI methods
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (00:00)
PCI: Probing PCI hardware (bus 00)
[ACPI Debug] Integer: 0x00000003
ACPI: PCI Root Bridge [PCI1] (00:03)
PCI: Probing PCI hardware (bus 03)
[ACPI Debug] Integer: 0x00000010
ACPI: PCI Root Bridge [PCI2] (00:10)
PCI: Probing PCI hardware (bus 10)
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 9 10 11 12 14) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 9 10 *11 12 14)
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 9 *10 11 12 14)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 6 7 9 10 11 12 14) *0, disabled.
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 9 10 11 12 14) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 *5 6 7 9 10 11 12 14)
ACPI: PCI Interrupt Link [LNK6] (IRQs 3 4 5 6 7 9 10 11 12 14) *0, disabled.
ACPI: PCI Interrupt Link [LNK7] (IRQs 3 4 5 6 7 9 *10 11 12 14)
ACPI: PCI Interrupt Link [LNK8] (IRQs 3 4 5 6 7 9 10 *11 12 14)
ACPI: PCI Interrupt Link [LNK9] (IRQs 3 4 *5 6 7 9 10 11 12 14)
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 12 14)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14) *0, disabled.
ACPI: PCI Interrupt Link [LUSB] (IRQs 3 4 5 6 7 *10 11 12 14)
SCSI subsystem initialized
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
** PCI interrupts are no longer routed automatically.  If this
** causes a device to stop working, it is probably because the
** driver failed to call pci_enable_device().  As a temporary
** workaround, the "pci=routeirq" argument restores the old
** behavior.  If this argument makes the device work again,
** please email the output of "lspci" to bjorn.helgaas@hp.com
** so I can fix the driver.
[ACPI Debug] String: [0x09] "MEM _CRS."
[ACPI Debug] Buffer: [0x4A]highmem bounce pool size: 64 pages
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Initializing Cryptographic API

testing md5
test 1:
d41d8cd98f00b204e9800998ecf8427e
pass
test 2:
0cc175b9c0f1b6a831c399e269772661
pass
test 3:
900150983cd24fb0d6963f7d28e17f72
pass
test 4:
f96b697d7cb7938d525a2f31aaf161d0
pass
test 5:
c3fcd3d76192e4007dfb496cca67e13b
pass
test 6:
d174ab98d277d9f5a5611c2c9f419d9f
pass
test 7:
57edf4a22be3c955ac49da2e2107b67a
pass
testing md5 across pages
test 1:
c3fcd3d76192e4007dfb496cca67e13b
pass

testing sha1
failed to load transform for sha1

testing des ECB encryption 
test 1 (64 bit key):
c95744256a5ed31d
pass
test 2 (64 bit key):
f79c892a338f4a8b
pass
test 3 (64 bit key):
690f5b0d9a26939b
pass
test 4 (64 bit key):
c95744256a5ed31df79c892a338f4a8bb49926f71fe1d490
pass
test 5 (64 bit key):
setkey() failed flags=100100
c95744256a5ed31d
pass

testing des ECB encryption across pages (chunking) 
test 1 (64 bit key):
page 0
c95744256a5ed31d
pass
page 1
f79c892a338f4a8b
pass
test 2 (64 bit key):
page 0
c95744256a5ed31df79c892a338f
pass
page 1
4a8bb49926f71fe1d490
pass
page 2
f79c892a338f4a8b
pass
test 3 (64 bit key):
page 0
c957
pass
page 1
44
pass
page 2
256a5e
pass
page 3
d31df79c892a338f4a8bb49926f71fe1d490
pass
test 4 (64 bit key):
page 0
c957
pass
page 1
4425
pass
page 2
6a5e
pass
page 3
d31d
pass
page 4
f79c892a338f4a8b
pass
test 5 (64 bit key):
page 0
c9
pass
page 1
57
pass
page 2
44
pass
page 3
25
pass
page 4
6a
pass
page 5
5e
pass
page 6
d3
pass
page 7
1d
pass

testing des ECB decryption 
test 1 (64 bit key):
0123456789abcde7
pass
test 2 (64 bit key):
01a1d6d039776742
pass

testing des ECB decryption across pages (chunking) 
test 1 (64 bit key):
page 0
0123456789abcde7
pass
page 1
a3997bcaaf69a0f5
pass
test 2 (64 bit key):
page 0
012345
pass
page 1
6789abcde7a3997bcaaf69a0
pass
page 2
f5
pass

testing des CBC encryption 
test 1 (64 bit key):
ccd173ffab2039f4acd8aefddfd8a1eb468e91157888ba68
pass
test 2 (64 bit key):
e5c7cdde872bf27c
pass
test 3 (64 bit key):
43e934008c389c0f
pass
test 4 (64 bit key):
683788499a7c05f6
pass

testing des CBC encryption across pages (chunking) 
test 1 (64 bit key):
page 0
ccd173ffab2039f4acd8aefddf
pass
page 1
d8a1eb468e91157888ba68
pass

testing des CBC decryption 
test 1 (64 bit key):
4e6f772069732074
pass
test 2 (64 bit key):
68652074696d6520
pass
test 3 (64 bit key):
666f7220616c6c20
pass

testing des CBC decryption across pages (chunking) 
test 1 (64 bit key):
page 0
666f7220
pass
page 1
616c6c20
pass

testing des3_ede ECB encryption 
test 1 (192 bit key):
18d748e563620572
pass
test 2 (192 bit key):
c07d2a0fa566fa30
pass
test 3 (192 bit key):
e1ef62c332fe825b
pass

testing des3_ede ECB encryption across pages (chunking) 

testing des3_ede ECB decryption 
test 1 (192 bit key):
736f6d6564617461
pass
test 2 (192 bit key):
7371756967676c65
pass
test 3 (192 bit key):
0000000000000000
pass

testing des3_ede ECB decryption across pages (chunking) 

testing md4
failed to load transform for md4

testing sha256
failed to load transform for sha256

testing blowfish ECB encryption 
test 1 (64 bit key):
4ef997456198dd78
pass
test 2 (64 bit key):
a790795108ea3cae
pass
test 3 (64 bit key):
e87a244e2cc85e82
pass
test 4 (128 bit key):
93142887ee3be15c
pass
test 5 (168 bit key):
e6f51ed79b9db21f
pass
test 6 (448 bit key):
c04504012e4e1f53
pass

testing blowfish ECB encryption across pages (chunking) 

testing blowfish ECB decryption 
test 1 (64 bit key):
0000000000000000
pass
test 2 (64 bit key):
0123456789abcdef
pass
test 3 (64 bit key):
fedcba9876543210
pass
test 4 (128 bit key):
fedcba9876543210
pass
test 5 (168 bit key):
fedcba9876543210
pass
test 6 (448 bit key):
fedcba9876543210
pass

testing blowfish ECB decryption across pages (chunking) 

testing blowfish CBC encryption 
test 1 (128 bit key):
6b77b4d63006dee605b156e27403979358deb9e7154616d959f1652bd5ff92cc
pass

testing blowfish CBC encryption across pages (chunking) 

testing blowfish CBC decryption 
test 1 (128 bit key):
37363534333231204e6f77206973207468652074696d6520666f722000000000
pass

testing blowfish CBC decryption across pages (chunking) 

testing twofish ECB encryption 
failed to load transform for twofish ECB

testing twofish ECB decryption 
failed to load transform for twofish ECB

testing twofish CBC encryption 
failed to load transform for twofish CBC

testing twofish CBC decryption 
failed to load transform for twofish CBC

testing serpent ECB encryption 
failed to load transform for serpent ECB

testing serpent ECB decryption 
failed to load transform for serpent ECB

testing tnepres ECB encryption 
failed to load transform for tnepres ECB

testing tnepres ECB decryption 
failed to load transform for tnepres ECB

testing aes ECB encryption 
test 1 (128 bit key):
69c4e0d86a7b0430d8cdb78070b4c55a
pass
test 2 (192 bit key):
dda97ca4864cdfe06eaf70a0ec0d7191
pass
test 3 (256 bit key):
8ea2b7ca516745bfeafc49904b496089
pass

testing aes ECB encryption across pages (chunking) 

testing aes ECB decryption 
test 1 (128 bit key):
00112233445566778899aabbccddeeff
pass
test 2 (192 bit key):
00112233445566778899aabbccddeeff
pass
test 3 (256 bit key):
00112233445566778899aabbccddeeff
pass

testing aes ECB decryption across pages (chunking) 

testing cast5 ECB encryption 
failed to load transform for cast5 ECB

testing cast5 ECB decryption 
failed to load transform for cast5 ECB

testing cast6 ECB encryption 
failed to load transform for cast6 ECB

testing cast6 ECB decryption 
failed to load transform for cast6 ECB

testing arc4 ECB encryption 
failed to load transform for arc4 ECB

testing arc4 ECB decryption 
failed to load transform for arc4 ECB

testing tea ECB encryption 
failed to load transform for tea ECB

testing tea ECB decryption 
failed to load transform for tea ECB

testing xtea ECB encryption 
failed to load transform for xtea ECB

testing xtea ECB decryption 
failed to load transform for xtea ECB

testing khazad ECB encryption 
failed to load transform for khazad ECB

testing khazad ECB decryption 
failed to load transform for khazad ECB

testing anubis ECB encryption 
failed to load transform for anubis ECB

testing anubis ECB decryption 
failed to load transform for anubis ECB

testing anubis CBC encryption 
failed to load transform for anubis CBC

testing anubis CBC decryption 
failed to load transform for anubis CBC

testing sha384
failed to load transform for sha384

testing sha512
failed to load transform for sha512

testing wp512
failed to load transform for wp512

testing wp384
failed to load transform for wp384

testing wp256
failed to load transform for wp256

testing deflate compression
failed to load transform for deflate

testing crc32c
testing crc32c initialized to 00000000: pass
testing crc32c setkey returns 12345678 : pass
testing crc32c using update/final:
 0e2c157f:OK e980ebf6:OK de74bded:OK d579c862:OK ba979ad0:OK 2b29d913:OK
testing crc32c using incremental accumulator:
 24c5d375:OK
testing crc32c using digest:
 24c5d375:OK
pass
crc32c test complete

testing michael_mic
failed to load transform for michael_mic
vesafb: probe of vesafb0 failed with error -6
Real Time Clock Driver v1.12
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
elevator: using anticipatory as default io scheduler
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
e100: Intel(R) PRO/100 Network Driver, 3.2.3-k2-NAPI
e100: Copyright(c) 1999-2004 Intel Corporation
ACPI: PCI interrupt 0000:00:08.0[A] -> GSI 26 (level, low) -> IRQ 26
e100: eth0: e100_probe: addr 0xfbefb000, irq 26, MAC addr 00:B0:D0:EA:24:FE
ACPI: PCI interrupt 0000:03:0b.0[A] -> GSI 25 (level, low) -> IRQ 25
e100: eth1: e100_probe: addr 0xfa5ff000, irq 25, MAC addr 00:02:B3:65:5E:00
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SvrWks OSB4: IDE controller at PCI slot 0000:00:0f.1
SvrWks OSB4: chipset revision 0
SvrWks OSB4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x08b0-0x08b7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x08b8-0x08bf, BIOS settings: hdc:pio, hdd:pio
hda: TEAC CD-ROM CD-224E, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: ATAPI 24X CD-ROM drive, 128kB Cache, (U)DMA
Uniform CD-ROM driver Revision: 3.20
ACPI: PCI interrupt 0000:00:05.0[A] -> GSI 17 (level, low) -> IRQ 17
ACPI: PCI interrupt 0000:00:05.1[B] -> GSI 18 (level, low) -> IRQ 18
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs

qla1280: Skipping AMI SubSys Vendor ID Chip
qla1280: Skipping AMI SubSys Vendor ID Chip
ACPI: PCI interrupt 0000:05:00.0[A] -> GSI 23 (level, low) -> IRQ 23
megaraid: found 0x101e:0x1960:bus 5:slot 0:func 0
scsi2:Found MegaRAID controller at 0xf8810000, IRQ:23
megaraid: [1.57:3.13] detected 2 logical drives.
megaraid: channel[0] is raid.
megaraid: channel[1] is raid.
scsi2 : LSI Logic MegaRAID 1.57 254 commands 16 targs 5 chans 7 luns
scsi2: scanning scsi channel 0 for logical drives.
  Vendor: MegaRAID  Model: LD0 RAID1 34678R  Rev: 1.57
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: MegaRAID  Model: LD1 RAID5 46780R  Rev: 1.57
  Type:   Direct-Access                      ANSI SCSI revision: 02
scsi2: scanning scsi channel 1 for logical drives.
scsi2: scanning scsi channel 2 for logical drives.
scsi2: scanning scsi channel 4 [P0] for physical devices.
  Vendor: DELL      Model: 1x4 U2W SCSI BP   Rev: 1.27
  Type:   Processor                          ANSI SCSI revision: 02
scsi2: scanning scsi channel 5 [P1] for physical devices.
  Vendor: Dell      Model: 12 BAY U2W CU     Rev: 0209
  Type:   Processor                          ANSI SCSI revision: 03
megaraid: ABORTING-81 cmd=a0 <c=5 t=15 l=0>
megaraid: ABORTING-81[7d], fw owner.
megaraid: reservation reset failed.
megaraid: RESET-81 cmd=a0 <c=5 t=15 l=0>
megaraid: RESET-81[7d], fw owner.
megaraid: reservation reset failed.
megaraid: RESET-81 cmd=a0 <c=5 t=15 l=0>
megaraid: RESET-81[7d], fw owner.
megaraid: reservation reset failed.
megaraid: RESET-81 cmd=a0 <c=5 t=15 l=0>
megaraid: RESET-81[7d], fw owner.
scsi: Device offlined - not ready after error recovery: host 2 channel 5 id 15 0
megaraid: ABORTING-82 cmd=12 <c=5 t=15 l=1>
megaraid: ABORTING-82[7d], fw owner.
megaraid: reservation reset failed.
megaraid: RESET-82 cmd=12 <c=5 t=15 l=1>
megaraid: RESET-82[7d], fw owner.
megaraid: reservation reset failed.
megaraid: RESET-82 cmd=12 <c=5 t=15 l=1>
megaraid: RESET-82[7d], fw owner.
megaraid: reservation reset failed.
megaraid: RESET-82 cmd=12 <c=5 t=15 l=1>
megaraid: RESET-82[7d], fw owner.
scsi: Device offlined - not ready after error recovery: host 2 channel 5 id 15 1
ACPI: PCI interrupt 0000:07:00.0[A] -> GSI 24 (level, low) -> IRQ 24
megaraid: found 0x101e:0x1960:bus 7:slot 0:func 0
scsi3:Found MegaRAID controller at 0xf8812000, IRQ:24
megaraid: [161J:3.17] detected 0 logical drives.
megaraid: channel[0] is raid.
megaraid: channel[1] is raid.
megaraid: Cluster driver, initiator id:14
scsi3 : LSI Logic MegaRAID 161J 254 commands 16 targs 5 chans 7 luns
scsi3: scanning scsi channel 0 for logical drives.
scsi3: scanning scsi channel 1 for logical drives.
scsi3: scanning scsi channel 2 for logical drives.
scsi3: scanning scsi channel 4 [P0] for physical devices.
scsi3: scanning scsi channel 5 [P1] for physical devices.
SCSI device sda: 71020544 512-byte hdwr sectors (36363 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
SCSI device sda: 71020544 512-byte hdwr sectors (36363 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
 sda: sda1 sda2
Attached scsi disk sda at scsi2, channel 0, id 0, lun 0
SCSI device sdb: 710205440 512-byte hdwr sectors (363625 MB)
sdb: asking for cache data failed
sdb: assuming drive cache: write through
SCSI device sdb: 710205440 512-byte hdwr sectors (363625 MB)
sdb: asking for cache data failed
sdb: assuming drive cache: write through
 sdb:<4>megaraid: aborted cmd 82[7d] complete.
Unable to handle kernel paging request at virtual address 3d15fa49
 printing eip:
c02d3ace
*pde = 00000000
Oops: 0000 [#1]
SMP 
Modules linked in:
CPU:    1
EIP:    0060:[<c02d3ace>]    Not tainted VLI
EFLAGS: 00010046   (2.6.10-bruce2.6) 
EIP is at mega_cmd_done+0xee/0x3a0
eax: 45445359   ebx: c199bff0   ecx: f7d1a228   edx: f7c4f400
esi: f7d07b40   edi: 0000007c   ebp: f7d1a25c   esp: c1973ea4
ds: 007b   es: 007b   ss: 0068
Process swapper (pid: 0, threadinfo=c1972000 task=c1945520)
Stack: c0500c0c c0500c0c 00000000 c18178c0 00000000 c18178c0 c199c000 f7eaa000 
       c18178c0 f7eab000 f7d1a228 00000001 c1973ef5 00000282 c02d396a f7d1a228 
       c1973ef4 00000001 00000000 0001ab50 0000007c 000005b8 00000000 bdf77930 
Call Trace:
 [<c02d396a>] megaraid_isr_memmapped+0xca/0x140
 [<c0117c13>] scheduler_tick+0x123/0x480
 [<c0136a50>] handle_IRQ_event+0x30/0x70
 [<c0136b70>] __do_IRQ+0xe0/0x140
 [<c0120e7a>] __do_softirq+0xba/0xd0
 [<c0104b89>] do_IRQ+0x19/0x30
 [<c01030b2>] common_interrupt+0x1a/0x20
 [<c0100710>] default_idle+0x0/0x40
 [<c010073c>] default_idle+0x2c/0x40
 [<c01007cb>] cpu_idle+0x3b/0x50
Code: 4c 24 1c 8b 43 7c 89 54 24 18 89 44 24 24 eb 0d 90 90 90 90 90 90 90 90 9 
 <0>Kernel panic - not syncing: Fatal exception in interrupt

--Multipart=_Thu__6_Jan_2005_18_13_51_+0100_PJwY.ZnPPG=4jOx0--
