From: David ROBERT <DROBERT@GENERIX.FR>
Subject: RE: HP LH & Adaptec aic7xxx Linux problem
Date: Tue, 29 Oct 2002 12:19:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <63645EA132F6D211AE29009027303EFF0244F03D@postman>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C27F3D.110BBDF0"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Jeff Chua' <jchua@fedex.com>
Cc: 'Linux SCSI' <linux-scsi@vger.kernel.org>, 'Alan Cox' <alan@lxorguk.ukuu.org.uk>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C27F3D.110BBDF0
Content-Type: text/plain

Gentlemen,

Here are my latest tests with that Hewlett-Packard LH4 server and its SCSI
controllers (onboard "Megaraid" & sym53c895, additional AHA 2940U2W with HP
C1537A Tape drive attached)

I just installed (or tried to) RedHat Linux 6.2, 7.1, 7.3 and 8.0 and then
used the "dmesg" command. You'll notice in the resulting files that I added
comments (noted with a line of *) where I tried to unload/load some modules.

I did try the NCR & SYM53Cxx drivers too because I have the feeling that
there may be a link between all those controlers drivers problem...

With RH7.1, I got a Kernel panic while the installation process tried to
load the aic7xxx driver ("Unrecoverable BRKADRINT. In interruot handler -
not syncing") and thus I did to make any further installation attempt.

I hope this can help...

Here are the files (named after the release and kernel version)


	David ROBERT (DROBERT / ROD)
	Responsable Informatique Interne
	drobert@generix.fr
	+33 (0)3 20 41 48 35


-----Message d'origine-----
De : Jeff Chua [mailto:jchua@fedex.com]
Envoye : mardi 29 octobre 2002 04:46
A : David ROBERT
Cc : Linux SCSI; Alan Cox
Objet : RE: HP LH & Adaptec aic7xxx Linux problem


On Mon, 28 Oct 2002, David ROBERT wrote:

> Our latest try was to install a RedHat 6.2
> And all our SCSI controlers work then properly, as well as the DAT drive.

That's interesting.

> The problem is that we do need  RedHat 7.x for our Oracle database.
>
> So here is the question we are thinking about : can we get the 6.2 drivers
> for Sym / NCR controler and/or adaptec cards to compile correctly under
7.x?
> (I know... that's unorthodox, but deseperate situations call for
desesperate
> solutions)

You can try compiling the module. But I won't count highly on that.

Alan, I was having problem with HP LH with the Adaptec aic7xxx driver, and
David got aic7xxx working on RedHat 6.2 but not 7.x on the HP LH. I had
given up hope of ever getting the aic7xxx to work on the LH.


Here's the dmesg again ...

	aic7xxx: PCI Device 1:2:0 failed memory mapped test
	ahc_pci:1:2:0: No SCB space found


David, could you please send the "dmesg" for the working system...

Thanks,
Jeff.

>
> 	David ROBERT (DROBERT / ROD)
> 	Responsable Informatique Interne
> 	drobert@generix.fr
> 	+33 (0)3 20 41 48 35
>


------_=_NextPart_000_01C27F3D.110BBDF0
Content-Type: text/plain;
	name="RH62-krnl-2.2.14-5.0smp.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="RH62-krnl-2.2.14-5.0smp.txt"

 #2......
.... register #00: 02000000
.......    : physical APIC id: 02
.... register #01: 00170011
.......     : max redirection entries: 0017
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:  =20
 00 001 01  0    0    0   0   0    0    7    51
 01 000 00  0    0    0   0   0    1    1    59
 02 000 00  0    0    0   0   0    1    1    51
 03 000 00  0    0    0   0   0    1    1    61
 04 000 00  0    0    0   0   0    1    1    69
 05 0FF 0F  1    1    0   0   0    1    1    71
 06 000 00  0    0    0   0   0    1    1    79
 07 000 00  0    0    0   0   0    1    1    81
 08 000 00  0    0    0   0   0    1    1    89
 09 000 00  0    0    0   0   0    1    1    91
 0a 0FF 0F  1    1    0   0   0    1    1    99
 0b 0FF 0F  1    1    0   0   0    1    1    A1
 0c 000 00  0    0    0   0   0    1    1    A9
 0d 000 00  1    0    0   0   0    0    0    00
 0e 000 00  0    0    0   0   0    1    1    B1
 0f 0FF 0F  1    1    0   0   0    1    1    B9
 10 000 00  1    0    0   0   0    0    0    00
 11 000 00  1    0    0   0   0    0    0    00
 12 000 00  1    0    0   0   0    0    0    00
 13 000 00  1    0    0   0   0    0    0    00
 14 000 00  1    0    0   0   0    0    0    00
 15 000 00  1    0    0   0   0    0    0    00
 16 000 00  1    0    0   0   0    0    0    00
 17 000 00  1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 2
IRQ1 -> 1
IRQ3 -> 3
IRQ4 -> 4
IRQ5 -> 5
IRQ6 -> 6
IRQ7 -> 7
IRQ8 -> 8
IRQ9 -> 9
IRQ10 -> 10
IRQ11 -> 11
IRQ12 -> 12
IRQ13 -> 13
IRQ14 -> 14
IRQ15 -> 15
.................................... done.
checking TSC synchronization across CPUs: passed.
PCI: PCI BIOS revision 2.10 entry at 0xfdab2
PCI: Using configuration type 1
PCI: Probing PCI hardware
PCI: 00:80 [8086/84ca]: Scanning peer host bridges
PCI->APIC IRQ transform: (B0,I2,P0) -> 10
PCI->APIC IRQ transform: (B1,I3,P0) -> 11
PCI->APIC IRQ transform: (B1,I7,P0) -> 15
PCI->APIC IRQ transform: (B2,I2,P0) -> 5
Linux NET4.0 for Linux 2.2
Based upon Swansea University Computer Society NET3.039
NET4: Unix domain sockets 1.0 for Linux NET4.0.
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP, IGMP
TCP: Hash tables configured (ehash 262144 bhash 65536)
Initializing RT netlink socket
Starting kswapd v 1.5=20
Detected PS/2 Mouse Port.
Serial driver version 4.27 with MANY_PORTS MULTIPORT SHARE_IRQ enabled
ttyS00 at 0x03f8 (irq =3D 4) is a 16550A
ttyS01 at 0x02f8 (irq =3D 3) is a 16550A
pty: 256 Unix98 ptys configured
Real Time Clock Driver v1.09
RAM disk driver initialized:  16 RAM disks of 4096K size
PIIX4: IDE controller on PCI bus 00 dev 79
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x9020-0x9027, BIOS settings: hda:DMA, hdb:DMA
hda: CD-540E, ATAPI CDROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: ATAPI 40X CD-ROM drive, 128kB Cache
Uniform CDROM driver Revision: 2.56
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
md driver 0.90.0 MAX_MD_DEVS=3D256, MAX_REAL=3D12
raid5: measuring checksumming speed
raid5: KNI detected, trying cache-avoiding KNI checksum routine
   pIII_kni  :  1259.205 MB/sec
raid5: MMX detected, trying high-speed MMX checksum routines
   pII_mmx   :  1526.667 MB/sec
   p5_mmx    :  1615.440 MB/sec
   8regs     :  1204.722 MB/sec
   32regs    :   659.892 MB/sec
using fastest function: pIII_kni (1259.205 MB/sec)
scsi : 0 hosts.
scsi : detected total.
md.c: sizeof(mdp_super_t) =3D 4096
Partition check:
RAMDISK: Compressed image found at block 0
autodetecting RAID arrays
autorun ...
... autorun DONE.
VFS: Mounted root (ext2 filesystem).
megaraid: v107 (December 22, 1999)
megaraid: found 0x8086:0x1960:idx 0:bus 0:slot 2:func 1
scsi0 : Found a MegaRAID controller at 0xd000d000, IRQ: 10
megaraid: [=02=03D :=01=02B ] detected 3 logical drives
scsi0 : AMI MegaRAID =02=03D  254 commands 16 targs 1 chans 8 luns
scsi : 1 host.
scsi0: scanning channel 1 for devices.
scsi0: scanning virtual channel for logical drives.
  Vendor: MegaRAID  Model: LD0 RAID0  8677R  Rev:   D=20
  Type:   Direct-Access                      ANSI SCSI revision: 02
Detected scsi disk sda at scsi0, channel 1, id 0, lun 0
  Vendor: MegaRAID  Model: LD1 RAID1 17365R  Rev:   D=20
  Type:   Direct-Access                      ANSI SCSI revision: 02
Detected scsi disk sdb at scsi0, channel 1, id 0, lun 1
  Vendor: MegaRAID  Model: LD2 RAID0 17365R  Rev:   D=20
  Type:   Direct-Access                      ANSI SCSI revision: 02
Detected scsi disk sdc at scsi0, channel 1, id 0, lun 2
SCSI device sda: hdwr sector=3D 512 bytes. Sectors=3D 17770496 [8677 =
MB] [8.7 GB]
 sda: sda1 sda2 < sda5 sda6 sda7 >
SCSI device sdb: hdwr sector=3D 512 bytes. Sectors=3D 35563520 [17365 =
MB] [17.4 GB]
 sdb: sdb1
SCSI device sdc: hdwr sector=3D 512 bytes. Sectors=3D 35563520 [17365 =
MB] [17.4 GB]
 sdc: sdc1 sdc2 < sdc5 sdc6 >
(scsi1) <Adaptec AHA-294X Ultra2 SCSI host adapter> found at PCI 1/3/0
(scsi1) Wide Channel, SCSI ID=3D7, 32/255 SCBs
(scsi1) Downloading sequencer code... 396 instructions downloaded
enable_irq() unbalanced from d0021401
scsi1 : Adaptec AHA274x/284x/294x (EISA/VLB/PCI-Fast SCSI) 5.1.28/3.2.4
       <Adaptec AHA-294X Ultra2 SCSI host adapter>
scsi : 2 hosts.
(scsi1:0:1:0) Synchronous at 10.0 Mbyte/sec, offset 32.
  Vendor: HP        Model: C1537A            Rev: L111
  Type:   Sequential-Access                  ANSI SCSI revision: 02
ncr53c8xx: at PCI bus 1, device 7, function 0
ncr53c8xx: 53c895 detected with Symbios NVRAM
ncr53c895-0: rev=3D0x01, base=3D0xe8102000, io_port=3D0xa400, irq=3D15
ncr53c895-0: NCR clock is 40218KHz, 40218KHz
ncr53c895-0: Symbios format NVRAM, ID 7, Fast-40, Parity Checking
ncr53c895-0: initial SCNTL3/DMODE/DCNTL/CTEST3/4/5 =3D (hex) =
00/00/00/00/00/00
ncr53c895-0: final   SCNTL3/DMODE/DCNTL/CTEST3/4/5 =3D (hex) =
07/4e/a0/00/08/24
ncr53c895-0: on-chip RAM at 0xe8101000
ncr53c895-0: resetting, command processing suspended for 2 seconds
ncr53c895-0: restart (scsi reset).
ncr53c895-0: enabling clock multiplier
ncr53c895-0: Downloading SCSI SCRIPTS.
scsi2 : ncr53c8xx - version 3.2a-2
scsi : 3 hosts.
ncr53c895-0: command processing resumed
autodetecting RAID arrays
autorun ...
... autorun DONE.
VFS: Mounted root (ext2 filesystem) readonly.
change_root: old root has d_count=3D1
Trying to unmount old root ... okay
Freeing unused kernel memory: 72k freed
Adding Swap: 514040k swap-space (priority -1)
Adding Swap: 1028120k swap-space (priority -2)
st: bufsize 32768, wrt 30720, max buffers 4, s/g segs 16.
Detected scsi tape st0 at scsi1, channel 0, id 1, lun 0
eepro100.c:v1.09j-t 9/29/99 Donald Becker =
http://cesdis.gsfc.nasa.gov/linux/drivers/eepro100.html
eepro100.c: $Revision: 1.18 $ 1999/12/29 Modified by Andrey V. =
Savochkin <saw@msu.ru>
eth0: OEM i82557/i82558 10/100 Ethernet at 0xd011e000, =
00:03:47:4C:15:B9, IRQ 5.
  Receiver lock-up bug exists -- enabling work-around.
  Board assembly 733470-007, Physical connectors present: RJ45
  Primary interface chip i82555 PHY #1.
  General self-test: passed.
  Serial sub-system self-test: passed.
  Internal registers self-test: passed.
  ROM checksum self-test: passed (0x04f4518b).
eth0: 0 multicast blocks dropped.
************* modprobre -r ncr53c8xx *************
ncr53c895-0: releasing host resources
ncr53c895-0: resetting chip
ncr53c895-0: enabling clock multiplier
ncr53c895-0: host resources successfully released
scsi : 2 hosts.
************* modprobre sym53c8xx ****************
sym53c8xx: at PCI bus 1, device 7, function 0
sym53c8xx: 53c895 detected with Symbios NVRAM
sym53c8xx: 53c895 state OFF thus not attached
scsi : 2 hosts.

------_=_NextPart_000_01C27F3D.110BBDF0
Content-Type: text/plain;
	name="RH73-krnl-2.4.18-3smp.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="RH73-krnl-2.4.18-3smp.txt"

Linux version 2.4.18-3smp (bhcompile@daffy.perf.redhat.com) (gcc =
version 2.96 20000731 (Red Hat Linux 7.3 2.96-110)) #1 SMP Thu Apr 18 =
07:27:31 EDT 2002
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8800 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000fff0000 (usable)
 BIOS-e820: 000000000fff0000 - 000000000ffffc00 (ACPI data)
 BIOS-e820: 000000000ffffc00 - 0000000010000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fffe8800 - 0000000100000000 (reserved)
found SMP MP-table at 000f6e10
hm, page 000f6000 reserved twice.
hm, page 000f7000 reserved twice.
hm, page 0009f000 reserved twice.
hm, page 000a0000 reserved twice.
On node 0 totalpages: 65520
zone(0): 4096 pages.
zone(1): 61424 pages.
zone(2): 0 pages.
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: HP       Product ID: LH 4         APIC at: 0xFEE00000
Processor #1 Pentium(tm) Pro APIC version 17
Processor #0 Pentium(tm) Pro APIC version 17
I/O APIC #2 Version 17 at 0xFEC00000.
Processors: 2
Kernel command line: auto BOOT_IMAGE=3Dlinux ro root=3D801 =
BOOT_FILE=3D/boot/vmlinuz-2.4.18-3smp
Initializing CPU#0
Detected 700.028 MHz processor.
Console: colour VGA+ 80x25
Calibrating delay loop... 1395.91 BogoMIPS
Memory: 254872k/262080k available (1232k kernel code, 6820k reserved, =
842k data, 304k init, 0k highmem)
Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
Inode cache hash table entries: 16384 (order: 5, 131072 bytes)
Mount-cache hash table entries: 4096 (order: 3, 32768 bytes)
Buffer cache hash table entries: 16384 (order: 4, 65536 bytes)
Page-cache hash table entries: 65536 (order: 6, 262144 bytes)
CPU: Before vendor init, caps: 0387fbff 00000000 00000000, vendor =3D 0
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: After vendor init, caps: 0387fbff 00000000 00000000 00000000
CPU serial number disabled.
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU:     After generic, caps: 0383fbff 00000000 00000000 00000000
CPU:             Common caps: 0383fbff 00000000 00000000 00000000
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
mtrr: v1.40 (20010327) Richard Gooch (rgooch@atnf.csiro.au)
mtrr: detected mtrr type: Intel
CPU: Before vendor init, caps: 0383fbff 00000000 00000000, vendor =3D 0
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: After vendor init, caps: 0383fbff 00000000 00000000 00000000
Intel machine check reporting enabled on CPU#0.
CPU:     After generic, caps: 0383fbff 00000000 00000000 00000000
CPU:             Common caps: 0383fbff 00000000 00000000 00000000
CPU0: Intel Pentium III (Cascades) stepping 01
per-CPU timeslice cutoff: 2923.17 usecs.
task migration cache decay timeout: 10 msecs.
enabled ExtINT on CPU#0
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Booting processor 1/0 eip 2000
Initializing CPU#1
masked ExtINT on CPU#1
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Calibrating delay loop... 1399.19 BogoMIPS
CPU: Before vendor init, caps: 0387fbff 00000000 00000000, vendor =3D 0
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: After vendor init, caps: 0387fbff 00000000 00000000 00000000
CPU serial number disabled.
Intel machine check reporting enabled on CPU#1.
CPU:     After generic, caps: 0383fbff 00000000 00000000 00000000
CPU:             Common caps: 0383fbff 00000000 00000000 00000000
CPU1: Intel Pentium III (Cascades) stepping 01
Total of 2 processors activated (2795.11 BogoMIPS).
ENABLING IO-APIC IRQs
Setting 2 in the phys_id_present_map
...changing IO-APIC physical APIC ID to 2 ... ok.
init IO_APIC IRQs
 IO-APIC (apicid-pin) 2-0, 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, =
2-23 not connected.
..TIMER: vector=3D0x31 pin1=3D2 pin2=3D0
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...=20
..... (found pin 0) ...works.
number of MP IRQ sources: 20.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
.... register #00: 02000000
.......    : physical APIC id: 02
.... register #01: 00170011
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:  =20
 00 003 03  0    0    0   0   0    1    1    31
 01 003 03  0    0    0   0   0    1    1    39
 02 000 00  1    0    0   0   0    0    0    00
 03 003 03  0    0    0   0   0    1    1    41
 04 003 03  0    0    0   0   0    1    1    49
 05 003 03  1    1    0   0   0    1    1    51
 06 003 03  0    0    0   0   0    1    1    59
 07 003 03  0    0    0   0   0    1    1    61
 08 003 03  0    0    0   0   0    1    1    69
 09 003 03  0    0    0   0   0    1    1    71
 0a 003 03  1    1    0   0   0    1    1    79
 0b 003 03  1    1    0   0   0    1    1    81
 0c 003 03  0    0    0   0   0    1    1    89
 0d 003 03  0    0    0   0   0    1    1    91
 0e 003 03  0    0    0   0   0    1    1    99
 0f 003 03  1    1    0   0   0    1    1    A1
 10 000 00  1    0    0   0   0    0    0    00
 11 000 00  1    0    0   0   0    0    0    00
 12 000 00  1    0    0   0   0    0    0    00
 13 000 00  1    0    0   0   0    0    0    00
 14 000 00  1    0    0   0   0    0    0    00
 15 000 00  1    0    0   0   0    0    0    00
 16 000 00  1    0    0   0   0    0    0    00
 17 000 00  1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:0
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
.................................... done.
Using local APIC timer interrupts.
calibrating APIC timer ...
..... CPU clock speed is 699.9396 MHz.
..... host bus clock speed is 99.9912 MHz.
cpu: 0, clocks: 999912, slice: 333304
CPU0<T0:999904,T1:666592,D:8,S:333304,C:999912>
cpu: 1, clocks: 999912, slice: 333304
CPU1<T0:999904,T1:333296,D:0,S:333304,C:999912>
checking TSC synchronization across CPUs: passed.
PCI: PCI BIOS revision 2.10 entry at 0xfdab2, last bus=3D2
PCI: Using configuration type 1
PCI: Probing PCI hardware
PCI: Searching for i450NX host bridges on 00:10.0
Unknown bridge resource 2: assuming transparent
Unknown bridge resource 2: assuming transparent
PCI: Using IRQ router PIIX [8086/7110] at 00:0f.0
PCI->APIC IRQ transform: (B0,I2,P0) -> 10
PCI->APIC IRQ transform: (B1,I3,P0) -> 11
PCI->APIC IRQ transform: (B1,I7,P0) -> 15
PCI->APIC IRQ transform: (B1,I3,P0) -> 11
PCI->APIC IRQ transform: (B1,I7,P0) -> 15
PCI->APIC IRQ transform: (B2,I2,P0) -> 5
PCI: Cannot allocate resource region 0 of device 01:03.0
PCI: Cannot allocate resource region 1 of device 01:03.0
PCI: Cannot allocate resource region 0 of device 01:07.0
PCI: Cannot allocate resource region 1 of device 01:07.0
PCI: Cannot allocate resource region 2 of device 01:07.0
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux NET4.0 for Linux 2.4
Based upon Swansea University Computer Society NET3.039
Initializing RT netlink socket
apm: BIOS not found.
Starting kswapd
VFS: Diskquotas version dquot_6.5.0 initialized
pty: 2048 Unix98 ptys configured
Serial driver version 5.05c (2001-07-08) with MANY_PORTS MULTIPORT =
SHARE_IRQ SERIAL_PCI ISAPNP enabled
ttyS00 at 0x03f8 (irq =3D 4) is a 16550A
ttyS01 at 0x02f8 (irq =3D 3) is a 16550A
Real Time Clock Driver v1.10e
block: 480 slots per queue, batch=3D120
Uniform Multi-Platform E-IDE driver Revision: 6.31
ide: Assuming 33MHz system bus speed for PIO modes; override with =
idebus=3Dxx
PIIX4: IDE controller on PCI bus 00 dev 79
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x9020-0x9027, BIOS settings: hda:DMA, hdb:DMA
PIIX4: IDE controller on PCI bus 00 dev 80
PIIX4: device not capable of full native PCI mode
PIIX4: device disabled (BIOS)
hda: CD-540E, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide-floppy driver 0.99.newide
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
ide-floppy driver 0.99.newide
md: md driver 0.90.0 MAX_MD_DEVS=3D256, MD_SB_DISKS=3D27
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
pci_hotplug: PCI Hot Plug PCI Core version: 0.4
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP, IGMP
IP: routing cache hash table of 2048 buckets, 16Kbytes
TCP: Hash tables configured (established 16384 bind 16384)
Linux IP multicast router 0.06 plus PIM-SM
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
RAMDISK: Compressed image found at block 0
Freeing initrd memory: 202k freed
VFS: Mounted root (ext2 filesystem).
SCSI subsystem driver Revision: 1.00
kmod: failed to exec /sbin/modprobe -s -k scsi_hostadapter, errno =3D 2
megaraid: v1.18a (Release Date: Mon Mar 11 11:38:38 EST 2002)
megaraid: found 0x8086:0x1960:idx 0:bus 0:slot 2:func 1
scsi0 : Found a MegaRAID controller at 0xd0837000, IRQ: 10
megaraid: [=02=03D :=01=02B ] detected 3 logical drives
megaraid: channel[1] is raid.
scsi0 : LSI Logic MegaRAID =02=03D  254 commands 15 targs 4 chans 7 =
luns
blk: queue cfecee18, I/O limit 4095Mb (mask 0xffffffff)
scsi0: scanning virtual channel 0 for logical drives.
  Vendor: MegaRAID  Model: LD0 RAID0  8677R  Rev:   D=20
  Type:   Direct-Access                      ANSI SCSI revision: 02
blk: queue cff52018, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: MegaRAID  Model: LD1 RAID1 17365R  Rev:   D=20
  Type:   Direct-Access                      ANSI SCSI revision: 02
blk: queue cfecea18, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: MegaRAID  Model: LD2 RAID0 17365R  Rev:   D=20
  Type:   Direct-Access                      ANSI SCSI revision: 02
blk: queue cfece618, I/O limit 4095Mb (mask 0xffffffff)
scsi0: scanning physical channel 0 for devices.
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi0, channel 0, id 1, lun 0
Attached scsi disk sdc at scsi0, channel 0, id 2, lun 0
SCSI device sda: 17770496 512-byte hdwr sectors (9098 MB)
Partition check:
 sda: sda1 sda2 < sda5 sda6 sda7 >
SCSI device sdb: 35563520 512-byte hdwr sectors (18209 MB)
 sdb: sdb1
SCSI device sdc: 35563520 512-byte hdwr sectors (18209 MB)
 sdc: sdc1 sdc2 < sdc5 sdc6 >
Journalled Block Device driver loaded
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Freeing unused kernel memory: 304k freed
Adding Swap: 1028120k swap-space (priority -1)
Adding Swap: 514040k swap-space (priority -2)
usb.c: registered new driver usbdevfs
usb.c: registered new driver hub
usb-uhci.c: $Revision: 1.275 $ time 07:32:55 Apr 18 2002
usb-uhci.c: High bandwidth mode enabled
PCI: No IRQ known for interrupt pin D of device 00:0f.2. Probably buggy =
MP table.
usb-uhci.c: found UHCI device with no IRQ assigned. check BIOS =
settings!
usb-uhci.c: v1.275:USB Universal Host Controller Interface driver
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on sd(8,1), internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on sd(8,6), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on sd(8,5), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
usb-uhci.c: $Revision: 1.275 $ time 07:32:55 Apr 18 2002
usb-uhci.c: High bandwidth mode enabled
PCI: No IRQ known for interrupt pin D of device 00:0f.2. Probably buggy =
MP table.
usb-uhci.c: found UHCI device with no IRQ assigned. check BIOS =
settings!
usb-uhci.c: v1.275:USB Universal Host Controller Interface driver
parport0: PC-style at 0x378 [PCSPP]
eepro100.c:v1.09j-t 9/29/99 Donald Becker =
http://www.scyld.com/network/eepro100.html
eepro100.c: $Revision: 1.36 $ 2000/11/17 Modified by Andrey V. =
Savochkin <saw@saw.sw.com.sg> and others
eth0: OEM i82557/i82558 10/100 Ethernet, 00:03:47:4C:15:B9, IRQ 5.
  Board assembly 733470-007, Physical connectors present: RJ45
  Primary interface chip i82555 PHY #1.
  General self-test: passed.
  Serial sub-system self-test: passed.
  Internal registers self-test: passed.
  ROM checksum self-test: passed (0x04f4518b).
************* modprobre ncr53c8xx ****************
ncr53c8xx: at PCI bus 1, device 7, function 0
ncr53c8xx: 53c895 detected=20
ncr53c895-0: rev 0x1 on pci bus 1 device 7 function 0 irq 15
ncr53c895-0: ID 7, Fast-40, Parity Checking
CACHE TEST FAILED: reg dstat-sstat2 readback ffffffff.
CACHE INCORRECTLY CONFIGURED.
ncr53c895-0: detaching...
************* modprobre sym53c8xx ****************
sym53c8xx: at PCI bus 1, device 7, function 0
sym53c8xx: 53c895 detected=20
sym53c895-0: rev 0x1 on pci bus 1 device 7 function 0 irq 15
sym53c895-0: ID 7, Fast-40, Parity Checking
CACHE TEST FAILED: reg dstat-sstat2 readback ffffffff.
CACHE INCORRECTLY CONFIGURED.
sym53c895-0: giving up ...
************* modprobre sym53c8xx_2 **************
sym0: <895> rev 0x1 on pci bus 1 device 7 function 0 irq 15
sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
CACHE TEST FAILED: reg dstat-sstat2 readback ffffffff.
sym0: CACHE INCORRECTLY CONFIGURED.
sym0: giving up ...
************* modprobre aic7xxx ******************
aic7xxx: PCI Device 1:3:0 failed memory mapped test
ahc_pci:1:3:0: No SCB space found
PCI: Enabling device 01:03.0 (0155 -> 0157)
aic7xxx: PCI Device 1:3:0 failed memory mapped test
ahc_pci:1:3:0: No SCB space found

------_=_NextPart_000_01C27F3D.110BBDF0
Content-Type: text/plain;
	name="RH80-krnl-2.4.18.14smp.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="RH80-krnl-2.4.18.14smp.txt"

Linux version 2.4.18-14smp (bhcompile@stripples.devel.redhat.com) (gcc =
version 3.2 20020903 (Red Hat Linux 8.0 3.2-7)) #1 SMP Wed Sep 4 =
12:34:47 EDT 2002
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8800 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000fff0000 (usable)
 BIOS-e820: 000000000fff0000 - 000000000ffffc00 (ACPI data)
 BIOS-e820: 000000000ffffc00 - 0000000010000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fffe8800 - 0000000100000000 (reserved)
0MB HIGHMEM available.
255MB LOWMEM available.
found SMP MP-table at 000f6e10
hm, page 000f6000 reserved twice.
hm, page 000f7000 reserved twice.
hm, page 0009f000 reserved twice.
hm, page 000a0000 reserved twice.
On node 0 totalpages: 65520
zone(0): 4096 pages.
zone(1): 61424 pages.
zone(2): 0 pages.
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: HP       Product ID: LH 4         APIC at: 0xFEE00000
Processor #1 Pentium(tm) Pro APIC version 17
Processor #0 Pentium(tm) Pro APIC version 17
I/O APIC #2 Version 17 at 0xFEC00000.
Processors: 2
Kernel command line: auto BOOT_IMAGE=3Dlinux ro =
BOOT_FILE=3D/boot/vmlinuz-2.4.18-14smp root=3DLABEL=3D/
Initializing CPU#0
Detected 700.045 MHz processor.
Speakup v-1.00 CVS: Tue Jun 11 14:22:53 EDT 2002 : initialized
Console: colour VGA+ 80x25
Calibrating delay loop... 1389.41 BogoMIPS
Memory: 252376k/262080k available (1451k kernel code, 7272k reserved, =
1067k data, 240k init, 0k highmem)
Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
Inode cache hash table entries: 16384 (order: 5, 131072 bytes)
Mount cache hash table entries: 4096 (order: 3, 32768 bytes)
ramfs: mounted with options: <defaults>
ramfs: max_pages=3D31802 max_file_pages=3D0 max_inodes=3D0 =
max_dentries=3D31802
Buffer cache hash table entries: 16384 (order: 4, 65536 bytes)
Page-cache hash table entries: 65536 (order: 6, 262144 bytes)
CPU: Before vendor init, caps: 0387fbff 00000000 00000000, vendor =3D 0
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: After vendor init, caps: 0387fbff 00000000 00000000 00000000
CPU serial number disabled.
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU:     After generic, caps: 0383fbff 00000000 00000000 00000000
CPU:             Common caps: 0383fbff 00000000 00000000 00000000
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
mtrr: v1.40 (20010327) Richard Gooch (rgooch@atnf.csiro.au)
mtrr: detected mtrr type: Intel
CPU: Before vendor init, caps: 0383fbff 00000000 00000000, vendor =3D 0
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: After vendor init, caps: 0383fbff 00000000 00000000 00000000
Intel machine check reporting enabled on CPU#0.
CPU:     After generic, caps: 0383fbff 00000000 00000000 00000000
CPU:             Common caps: 0383fbff 00000000 00000000 00000000
CPU0: Intel Pentium III (Cascades) stepping 01
per-CPU timeslice cutoff: 2923.17 usecs.
task migration cache decay timeout: 3 msecs.
enabled ExtINT on CPU#0
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Booting processor 1/0 eip 2000
Initializing CPU#1
masked ExtINT on CPU#1
ESR value before enabling vector: 00000000
ESR value after enabling vector: 00000000
Calibrating delay loop... 1397.52 BogoMIPS
CPU: Before vendor init, caps: 0387fbff 00000000 00000000, vendor =3D 0
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: After vendor init, caps: 0387fbff 00000000 00000000 00000000
CPU serial number disabled.
Intel machine check reporting enabled on CPU#1.
CPU:     After generic, caps: 0383fbff 00000000 00000000 00000000
CPU:             Common caps: 0383fbff 00000000 00000000 00000000
CPU1: Intel Pentium III (Cascades) stepping 01
Total of 2 processors activated (2786.93 BogoMIPS).
ENABLING IO-APIC IRQs
Setting 2 in the phys_id_present_map
...changing IO-APIC physical APIC ID to 2 ... ok.
init IO_APIC IRQs
 IO-APIC (apicid-pin) 2-0, 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, =
2-23 not connected.
..TIMER: vector=3D0x31 pin1=3D2 pin2=3D0
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...=20
..... (found pin 0) ...works.
number of MP IRQ sources: 20.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
.... register #00: 02000000
.......    : physical APIC id: 02
.... register #01: 00170011
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:  =20
 00 001 01  0    0    0   0   0    1    1    31
 01 003 03  0    0    0   0   0    1    1    39
 02 002 02  1    0    0   0   0    0    0    00
 03 003 03  0    0    0   0   0    1    1    41
 04 003 03  0    0    0   0   0    1    1    49
 05 003 03  1    1    0   0   0    1    1    51
 06 003 03  0    0    0   0   0    1    1    59
 07 003 03  0    0    0   0   0    1    1    61
 08 003 03  0    0    0   0   0    1    1    69
 09 003 03  0    0    0   0   0    1    1    71
 0a 003 03  1    1    0   0   0    1    1    79
 0b 003 03  1    1    0   0   0    1    1    81
 0c 003 03  0    0    0   0   0    1    1    89
 0d 003 03  0    0    0   0   0    1    1    91
 0e 003 03  0    0    0   0   0    1    1    99
 0f 003 03  1    1    0   0   0    1    1    A1
 10 000 00  1    0    0   0   0    0    0    00
 11 000 00  1    0    0   0   0    0    0    00
 12 000 00  1    0    0   0   0    0    0    00
 13 000 00  1    0    0   0   0    0    0    00
 14 000 00  1    0    0   0   0    0    0    00
 15 000 00  1    0    0   0   0    0    0    00
 16 000 00  1    0    0   0   0    0    0    00
 17 000 00  1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:0
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
.................................... done.
Using local APIC timer interrupts.
calibrating APIC timer ...
..... CPU clock speed is 699.1796 MHz.
..... host bus clock speed is 99.1930 MHz.
cpu: 0, clocks: 195277, slice: 65092
CPU0<T0:195264,T1:130160,D:12,S:65092,C:195277>
cpu: 1, clocks: 195277, slice: 65092
CPU1<T0:195264,T1:65072,D:8,S:65092,C:195277>
checking TSC synchronization across CPUs: passed.
migration_task 0 on cpu=3D0
migration_task 1 on cpu=3D1
PCI: PCI BIOS revision 2.10 entry at 0xfdab2, last bus=3D2
PCI: Using configuration type 1
PCI: Probing PCI hardware
PCI: Searching for i450NX host bridges on 00:10.0
Unknown bridge resource 2: assuming transparent
Unknown bridge resource 2: assuming transparent
PCI: Using IRQ router PIIX [8086/7110] at 00:0f.0
PCI->APIC IRQ transform: (B0,I2,P0) -> 10
PCI->APIC IRQ transform: (B1,I3,P0) -> 11
PCI->APIC IRQ transform: (B1,I7,P0) -> 15
PCI->APIC IRQ transform: (B1,I3,P0) -> 11
PCI->APIC IRQ transform: (B1,I7,P0) -> 15
PCI->APIC IRQ transform: (B2,I2,P0) -> 5
PCI: Cannot allocate resource region 0 of device 01:03.0
PCI: Cannot allocate resource region 1 of device 01:03.0
PCI: Cannot allocate resource region 0 of device 01:07.0
PCI: Cannot allocate resource region 1 of device 01:07.0
PCI: Cannot allocate resource region 2 of device 01:07.0
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
speakup:  initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
Linux NET4.0 for Linux 2.4
Based upon Swansea University Computer Society NET3.039
Initializing RT netlink socket
apm: BIOS not found.
Starting kswapd
VFS: Diskquotas version dquot_6.5.0 initialized
pty: 2048 Unix98 ptys configured
Serial driver version 5.05c (2001-07-08) with MANY_PORTS MULTIPORT =
SHARE_IRQ SERIAL_PCI ISAPNP enabled
ttyS0 at 0x03f8 (irq =3D 4) is a 16550A
ttyS1 at 0x02f8 (irq =3D 3) is a 16550A
Real Time Clock Driver v1.10e
oprofile: APIC was already enabled
oprofile 0.2 loaded, major 254
block: 480 slots per queue, batch=3D120
Uniform Multi-Platform E-IDE driver Revision: 6.31
ide: Assuming 33MHz system bus speed for PIO modes; override with =
idebus=3Dxx
PIIX4: IDE controller on PCI bus 00 dev 79
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x9020-0x9027, BIOS settings: hda:DMA, hdb:DMA
PIIX4: IDE controller on PCI bus 00 dev 80
PIIX4: device not capable of full native PCI mode
PIIX4: device disabled (BIOS)
hda: CD-540E, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide-floppy driver 0.99.newide
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
NET4: Frame Diverter 0.46
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
ide-floppy driver 0.99.newide
md: md driver 0.90.0 MAX_MD_DEVS=3D256, MD_SB_DISKS=3D27
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
pci_hotplug: PCI Hot Plug PCI Core version: 0.4
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP, IGMP
IP: routing cache hash table of 2048 buckets, 16Kbytes
TCP: Hash tables configured (established 16384 bind 16384)
Linux IP multicast router 0.06 plus PIM-SM
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
RAMDISK: Compressed image found at block 0
Freeing initrd memory: 214k freed
VFS: Mounted root (ext2 filesystem).
SCSI subsystem driver Revision: 1.00
kmod: failed to exec /sbin/modprobe -s -k scsi_hostadapter, errno =3D 2
megaraid: v1.18d (Release Date: Wed Aug  7 18:51:51 EDT 2002)
megaraid: found 0x8086:0x1960:idx 0:bus 0:slot 2:func 1
scsi0 : Found a MegaRAID controller at 0xd0850000, IRQ: 10
megaraid: [=02=03D :=01=02B ] detected 3 logical drives
megaraid: channel[1] is raid.
scsi0 : LSI Logic MegaRAID =02=03D  254 commands 15 targs 4 chans 7 =
luns
blk: queue c1a90c18, I/O limit 4095Mb (mask 0xffffffff)
scsi0: scanning virtual channel 0 for logical drives.
  Vendor: MegaRAID  Model: LD0 RAID0  8677R  Rev:   D=20
  Type:   Direct-Access                      ANSI SCSI revision: 02
blk: queue c1a90a18, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: MegaRAID  Model: LD1 RAID1 17365R  Rev:   D=20
  Type:   Direct-Access                      ANSI SCSI revision: 02
blk: queue c1a90618, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: MegaRAID  Model: LD2 RAID0 17365R  Rev:   D=20
  Type:   Direct-Access                      ANSI SCSI revision: 02
blk: queue c1a90218, I/O limit 4095Mb (mask 0xffffffff)
scsi0: scanning physical channel 0 for devices.
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi0, channel 0, id 1, lun 0
Attached scsi disk sdc at scsi0, channel 0, id 2, lun 0
SCSI device sda: 17770496 512-byte hdwr sectors (9098 MB)
Partition check:
 sda: sda1 sda2 < sda5 sda6 sda7 >
SCSI device sdb: 35563520 512-byte hdwr sectors (18209 MB)
 sdb: sdb1
SCSI device sdc: 35563520 512-byte hdwr sectors (18209 MB)
 sdc: sdc1 sdc2 < sdc5 sdc6 >
Journalled Block Device driver loaded
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
Freeing unused kernel memory: 240k freed
EXT3 FS 2.4-0.9.18, 14 May 2002 on sd(8,1), internal journal
Adding Swap: 1028120k swap-space (priority -1)
Adding Swap: 514040k swap-space (priority -2)
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.18, 14 May 2002 on sd(8,6), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.18, 14 May 2002 on sd(8,5), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
parport0: PC-style at 0x378 [PCSPP]
ohci1394: pci_module_init failed
ip_tables: (C) 2000-2002 Netfilter core team
eepro100.c:v1.09j-t 9/29/99 Donald Becker =
http://www.scyld.com/network/eepro100.html
eepro100.c: $Revision: 1.36 $ 2000/11/17 Modified by Andrey V. =
Savochkin <saw@saw.sw.com.sg> and others
divert: allocating divert_blk for eth0
eth0: OEM i82557/i82558 10/100 Ethernet, 00:03:47:4C:15:B9, IRQ 5.
  Board assembly 733470-007, Physical connectors present: RJ45
  Primary interface chip i82555 PHY #1.
  General self-test: passed.
  Serial sub-system self-test: passed.
  Internal registers self-test: passed.
  ROM checksum self-test: passed (0x04f4518b).
mice: PS/2 mouse device common for all mice
************* modprobre ncr53c8xx **************
ncr53c8xx: at PCI bus 1, device 7, function 0
ncr53c8xx: 53c895 detected=20
ncr53c895-0: rev 0x1 on pci bus 1 device 7 function 0 irq 15
ncr53c895-0: ID 7, Fast-40, Parity Checking
CACHE TEST FAILED: reg dstat-sstat2 readback ffffffff.
CACHE INCORRECTLY CONFIGURED.
ncr53c895-0: detaching...
************* modprobre sym53c8xx **************
sym53c8xx: at PCI bus 1, device 7, function 0
sym53c8xx: 53c895 detected=20
sym53c895-0: rev 0x1 on pci bus 1 device 7 function 0 irq 15
sym53c895-0: ID 7, Fast-40, Parity Checking
CACHE TEST FAILED: reg dstat-sstat2 readback ffffffff.
CACHE INCORRECTLY CONFIGURED.
sym53c895-0: giving up ...
************* modprobre sym53c8xx_2 **************
sym0: <895> rev 0x1 on pci bus 1 device 7 function 0 irq 15
sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
CACHE TEST FAILED: reg dstat-sstat2 readback ffffffff.
sym0: CACHE INCORRECTLY CONFIGURED.
sym0: giving up ...
************* modprobre aic7xxx **************
aic7xxx: PCI Device 1:3:0 failed memory mapped test
ahc_pci:1:3:0: No SCB space found
PCI: Enabling device 01:03.0 (0155 -> 0157)
aic7xxx: PCI Device 1:3:0 failed memory mapped test
ahc_pci:1:3:0: No SCB space found

------_=_NextPart_000_01C27F3D.110BBDF0--
