From: Gabriel Gomiz <gomita@cooperativaobrera.com.ar>
Subject: Re: Symbios-NCR 6285-3621 + Adaptec 2944W multilun problem
Date: Fri, 12 May 2006 11:34:13 -0300
Message-ID: <44649CE5.7070604@cooperativaobrera.com.ar>
References: <44648D9C.2090602@cooperativaobrera.com.ar> <1147442986.3769.2.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020505020904070300070600"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 200-26-107-84.advance.com.ar ([200.26.107.84]:39077 "EHLO
	thorin.cooperativaobrera.com.ar") by vger.kernel.org with ESMTP
	id S932098AbWELOe3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 10:34:29 -0400
In-Reply-To: <1147442986.3769.2.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020505020904070300070600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

James:

First of all I want to salute you and give thanks for the Linux Voyager 
Architecture support! Maybe you remember me from that 2.4.19 boot 
problem with the NCR 4100!!! We have two 4100 running perfectly with 
linux since then. Now with kernel 2.6.x!!! Thanks again for that.

I'm attaching dmesg output. I'm sorry I forgot to attach it in the last 
email. The I/O errors occur when the devices are being detected and 
whenever I try to access them. For example to do 'fsidk -l /dev/sdc'.

Thanks again

James Bottomley wrote:
> On Fri, 2006-05-12 at 10:29 -0300, Gabriel Gomiz wrote:
> 
>>When configuring 2.6.16.13 kernel scsi subsystem with multilun
>>support, 
>>I'm trying to access a Symbios 6285-3621 Array via an Adaptec 2944W
>>HBA 
>>with aic7xxx module. All scsi "virtual devices" are recognized 
>>sdc-sdd-sde-sdf-sdg-sdh-sdi but then when the kernel tries to detect
>>the 
>>partition tables it gets a lot of "Buffer I/O errors".
> 
> 
> Could we get the dmesg output, both of the devices being detected, and
> when the I/O errors occur, please?
> 
> James

-- 
       .^.    Lic. Gabriel Gomiz - Red Hat Certified Engineer (RHCE)
       /V\    Administrador Red/Sistemas - Desarrollo Sistema POSEIDON
      // \\   Gerencia de Sistemas - Cooperativa Obrera Ltda.
     /(   )\  Tel (0291) 456-0084
      ^^-^^   s/Window[$s]/LINUX!!/g or die;


--------------020505020904070300070600
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

Linux version 2.6.16.13 (root@galadriel.cooperativaobrera.com.ar) (gcc version 3.4.5 20051201 (Red Hat 3.4.5-2)) #2 SMP Thu May 4 18:35:29 ART 2006
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
 BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0400 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000f9efa800 (usable)
 BIOS-e820: 00000000f9efa800 - 00000000f9effc00 (ACPI data)
 BIOS-e820: 00000000f9effc00 - 00000000f9f00000 (ACPI NVS)
 BIOS-e820: 00000000fe300000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000106100000 (usable)
Warning only 4GB will be used.
Use a PAE enabled kernel.
3200MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f6b70
On node 0 totalpages: 1048576
  DMA zone: 4096 pages, LIFO batch:0
  DMA32 zone: 0 pages, LIFO batch:0
  Normal zone: 225280 pages, LIFO batch:31
  HighMem zone: 819200 pages, LIFO batch:31
DMI 2.1 present.
Using APIC driver default
ACPI: RSDP (v000 PTLTD                                 ) @ 0x000f6b50
ACPI: RSDT (v001 INTEL  S450NX01 0x00000000 INTL 0x01000000) @ 0xf9efabdf
ACPI: FADT (v001 Intel  S450NX   0x00000002 INT  0x000f4240) @ 0xf9effafe
ACPI: MADT (v001 Intel  Custom   0x00000001 INT  0x10000000) @ 0xf9effb72
ACPI: DSDT (v001  INTEL  S450NX1 0x00000001 MSFT 0x01000009) @ 0x00000000
ACPI: BIOS age (1999) fails cutoff (2001), acpi=force is required to enable ACPI
ACPI: Disabling ACPI support
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: INTEL    Product ID: S450NX       APIC at: 0xFEE00000
Processor #3 6:7 APIC version 17
Processor #0 6:7 APIC version 17
Processor #1 6:7 APIC version 17
Processor #2 6:7 APIC version 17
I/O APIC #4 Version 19 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 4
Allocating PCI resources starting at fa000000 (gap: f9f00000:04400000)
Built 1 zonelists
Kernel command line: ro root=/dev/vol00/root
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0392000 soft=c0372000
PID hash table entries: 4096 (order: 12, 65536 bytes)
Detected 550.250 MHz processor.
Using tsc for high-res timesource
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 4046464k/4194304k available (1611k kernel code, 47224k reserved, 678k data, 188k init, 3177448k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1102.51 BogoMIPS (lpj=2205028)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0387fbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: After vendor identify, caps: 0387fbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU serial number disabled.
CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
CPU0: Intel Pentium III (Katmai) stepping 03
Booting processor 1/0 eip 2000
CPU 1 irqstacks, hard=c0393000 soft=c0373000
Initializing CPU#1
Calibrating delay using timer specific routine.. 1100.46 BogoMIPS (lpj=2200921)
CPU: After generic identify, caps: 0387fbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: After vendor identify, caps: 0387fbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU serial number disabled.
CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel Pentium III (Katmai) stepping 03
Booting processor 2/1 eip 2000
CPU 2 irqstacks, hard=c0394000 soft=c0374000
Initializing CPU#2
Calibrating delay using timer specific routine.. 1100.45 BogoMIPS (lpj=2200913)
CPU: After generic identify, caps: 0387fbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: After vendor identify, caps: 0387fbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU serial number disabled.
CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU2: Intel Pentium III (Katmai) stepping 03
Booting processor 3/2 eip 2000
CPU 3 irqstacks, hard=c0395000 soft=c0375000
Initializing CPU#3
Calibrating delay using timer specific routine.. 1100.48 BogoMIPS (lpj=2200965)
CPU: After generic identify, caps: 0387fbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: After vendor identify, caps: 0387fbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU serial number disabled.
CPU: After all inits, caps: 0383fbff 00000000 00000000 00000040 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU3: Intel Pentium III (Katmai) stepping 03
Total of 4 processors activated (4403.91 BogoMIPS).
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
checking TSC synchronization across 4 CPUs: passed.
Brought up 4 CPUs
migration_cost=6742
checking if image is initramfs... it is
Freeing initrd memory: 1158k freed
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfdb33, last bus=1
PCI: Using configuration type 1
ACPI: Subsystem revision 20060127
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:00:0a.0
PCI quirk: region 0c00-0c3f claimed by PIIX4 ACPI
PCI quirk: region 0cc0-0ccf claimed by PIIX4 SMB
PIIX4 devres B PIO at 0ca2-0ca3
PIIX4 devres C PIO at 0ca0-0ca1
PCI: Searching for i450NX host bridges on 0000:00:10.0
PCI->APIC IRQ transform: 0000:01:03.0[A] -> IRQ 185
PCI->APIC IRQ transform: 0000:01:03.1[B] -> IRQ 177
PCI->APIC IRQ transform: 0000:01:05.0[A] -> IRQ 161
PCI->APIC IRQ transform: 0000:00:06.0[A] -> IRQ 145
PCI->APIC IRQ transform: 0000:00:07.0[A] -> IRQ 153
PCI->APIC IRQ transform: 0000:00:08.0[A] -> IRQ 193
PCI->APIC IRQ transform: 0000:00:0c.2[D] -> IRQ 169
apm: BIOS not found.
audit: initializing netlink socket (disabled)
audit(1146771827.192:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Initializing Cryptographic API
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Real Time Clock Driver v1.12ac
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
Probing IDE interface ide1...
ide-floppy driver 0.99.newide
mice: PS/2 mouse device common for all mice
md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 4.39
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 8, 1048576 bytes)
TCP established hash table entries: 131072 (order: 9, 2621440 bytes)
TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
input: AT Translated Set 2 keyboard as /class/input/input0
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
TCP bic registered
Initializing IPsec netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 188k freed
SCSI subsystem initialized
sym0: <896> rev 0x1 at pci 0000:01:03.0 irq 185
sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.2
input: ImExPS/2 Generic Explorer Mouse as /class/input/input1
  Vendor: SEAGATE   Model: ST318203LC        Rev: 0002
  Type:   Direct-Access                      ANSI SCSI revision: 02
 target0:0:0: tagged command queuing enabled, command queue depth 16.
 target0:0:0: Beginning Domain Validation
 target0:0:0: asynchronous
 target0:0:0: wide asynchronous
 target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 15)
 target0:0:0: Domain Validation skipping write tests
 target0:0:0: Ending Domain Validation
SCSI device sda: 35566480 512-byte hdwr sectors (18210 MB)
sda: Write Protect is off
sda: Mode Sense: 9f 00 10 08
SCSI device sda: drive cache: write through w/ FUA
SCSI device sda: 35566480 512-byte hdwr sectors (18210 MB)
sda: Write Protect is off
sda: Mode Sense: 9f 00 10 08
SCSI device sda: drive cache: write through w/ FUA
 sda: sda1 sda2
sd 0:0:0:0: Attached scsi disk sda
  Vendor: SEAGATE   Model: ST318405LC        Rev: 5063
  Type:   Direct-Access                      ANSI SCSI revision: 03
 target0:0:1: tagged command queuing enabled, command queue depth 16.
 target0:0:1: Beginning Domain Validation
 target0:0:1: asynchronous
 target0:0:1: wide asynchronous
 target0:0:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 31)
 target0:0:1: Domain Validation skipping write tests
 target0:0:1: Ending Domain Validation
SCSI device sdb: 35843670 512-byte hdwr sectors (18352 MB)
sdb: Write Protect is off
sdb: Mode Sense: 9f 00 10 08
SCSI device sdb: drive cache: write back w/ FUA
SCSI device sdb: 35843670 512-byte hdwr sectors (18352 MB)
sdb: Write Protect is off
sdb: Mode Sense: 9f 00 10 08
SCSI device sdb: drive cache: write back w/ FUA
 sdb: sdb1 sdb2
sd 0:0:1:0: Attached scsi disk sdb
  Vendor: ESG-SHV   Model: SCA HSBP M6       Rev: 0.61
  Type:   Processor                          ANSI SCSI revision: 02
 target0:0:6: Beginning Domain Validation
 target0:0:6: asynchronous
 target0:0:6: Ending Domain Validation
sym1: <896> rev 0x1 at pci 0000:01:03.1 irq 177
sym1: No NVRAM, ID 7, Fast-40, SE, parity checking
sym1: SCSI BUS has been reset.
scsi1 : sym-2.2.2
  Vendor: TOSHIBA   Model: CD-ROM XM-6401TA  Rev: 1012
  Type:   CD-ROM                             ANSI SCSI revision: 02
 target1:0:5: Beginning Domain Validation
 target1:0:5: asynchronous
 target1:0:5: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 16)
 target1:0:5: Domain Validation skipping write tests
 target1:0:5: Ending Domain Validation
sym2: <810a> rev 0x23 at pci 0000:00:08.0 irq 193
sym2: No NVRAM, ID 7, Fast-10, SE, parity checking
sym2: SCSI BUS has been reset.
scsi2 : sym-2.2.2
scsi3 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 2944 SCSI adapter>
        aic7870: Wide Channel A, SCSI Id=6, 16/253 SCBs

  Vendor: SYMBIOS   Model: INF-01-00         Rev: 0205
  Type:   Direct-Access                      ANSI SCSI revision: 02
scsi3:A:1:0: Tagged Queuing enabled.  Depth 4
 target3:0:1: Beginning Domain Validation
 target3:0:1: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
 target3:0:1: Domain Validation skipping write tests
 target3:0:1: Ending Domain Validation
SCSI device sdc: 35484544 512-byte hdwr sectors (18168 MB)
sdc: Write Protect is off
sdc: Mode Sense: 6b 00 10 08
SCSI device sdc: drive cache: write through w/ FUA
SCSI device sdc: 35484544 512-byte hdwr sectors (18168 MB)
sdc: Write Protect is off
sdc: Mode Sense: 6b 00 10 08
SCSI device sdc: drive cache: write through w/ FUA
 sdc:end_request: I/O error, dev sdc, sector 0
Buffer I/O error on device sdc, logical block 0
end_request: I/O error, dev sdc, sector 0
Buffer I/O error on device sdc, logical block 0
end_request: I/O error, dev sdc, sector 0
Buffer I/O error on device sdc, logical block 0
 unable to read partition table
sd 3:0:1:0: Attached scsi disk sdc
  Vendor: SYMBIOS   Model: INF-01-00         Rev: 0205
  Type:   Direct-Access                      ANSI SCSI revision: 02
 target3:0:1: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
scsi3:A:1:1: Tagged Queuing enabled.  Depth 4
SCSI device sdd: 35484544 512-byte hdwr sectors (18168 MB)
sdd: Write Protect is off
sdd: Mode Sense: 6b 00 10 08
SCSI device sdd: drive cache: write through w/ FUA
SCSI device sdd: 35484544 512-byte hdwr sectors (18168 MB)
sdd: Write Protect is off
sdd: Mode Sense: 6b 00 10 08
SCSI device sdd: drive cache: write through w/ FUA
 sdd:end_request: I/O error, dev sdd, sector 0
Buffer I/O error on device sdd, logical block 0
end_request: I/O error, dev sdd, sector 0
Buffer I/O error on device sdd, logical block 0
end_request: I/O error, dev sdd, sector 0
Buffer I/O error on device sdd, logical block 0
 unable to read partition table
sd 3:0:1:1: Attached scsi disk sdd
  Vendor: SYMBIOS   Model: INF-01-00         Rev: 0205
  Type:   Direct-Access                      ANSI SCSI revision: 02
 target3:0:1: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
scsi3:A:1:2: Tagged Queuing enabled.  Depth 4
SCSI device sde: 35484544 512-byte hdwr sectors (18168 MB)
sde: Write Protect is off
sde: Mode Sense: 6b 00 10 08
SCSI device sde: drive cache: write through w/ FUA
SCSI device sde: 35484544 512-byte hdwr sectors (18168 MB)
sde: Write Protect is off
sde: Mode Sense: 6b 00 10 08
SCSI device sde: drive cache: write through w/ FUA
 sde:end_request: I/O error, dev sde, sector 0
Buffer I/O error on device sde, logical block 0
end_request: I/O error, dev sde, sector 0
Buffer I/O error on device sde, logical block 0
end_request: I/O error, dev sde, sector 0
Buffer I/O error on device sde, logical block 0
 unable to read partition table
sd 3:0:1:2: Attached scsi disk sde
  Vendor: SYMBIOS   Model: INF-01-00         Rev: 0205
  Type:   Direct-Access                      ANSI SCSI revision: 02
 target3:0:1: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
scsi3:A:1:3: Tagged Queuing enabled.  Depth 4
SCSI device sdf: 35484544 512-byte hdwr sectors (18168 MB)
sdf: Write Protect is off
sdf: Mode Sense: 6b 00 10 08
SCSI device sdf: drive cache: write through w/ FUA
SCSI device sdf: 35484544 512-byte hdwr sectors (18168 MB)
sdf: Write Protect is off
sdf: Mode Sense: 6b 00 10 08
SCSI device sdf: drive cache: write through w/ FUA
 sdf:end_request: I/O error, dev sdf, sector 0
Buffer I/O error on device sdf, logical block 0
end_request: I/O error, dev sdf, sector 0
end_request: I/O error, dev sdf, sector 0
 unable to read partition table
sd 3:0:1:3: Attached scsi disk sdf
  Vendor: SYMBIOS   Model: INF-01-00         Rev: 0205
  Type:   Direct-Access                      ANSI SCSI revision: 02
 target3:0:1: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
scsi3:A:1:4: Tagged Queuing enabled.  Depth 4
SCSI device sdg: 35484544 512-byte hdwr sectors (18168 MB)
sdg: Write Protect is off
sdg: Mode Sense: 6b 00 10 08
SCSI device sdg: drive cache: write through w/ FUA
SCSI device sdg: 35484544 512-byte hdwr sectors (18168 MB)
sdg: Write Protect is off
sdg: Mode Sense: 6b 00 10 08
SCSI device sdg: drive cache: write through w/ FUA
 sdg:end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdg, sector 0
 unable to read partition table
sd 3:0:1:4: Attached scsi disk sdg
  Vendor: SYMBIOS   Model: INF-01-00         Rev: 0205
  Type:   Direct-Access                      ANSI SCSI revision: 02
 target3:0:1: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
scsi3:A:1:5: Tagged Queuing enabled.  Depth 4
SCSI device sdh: 35484544 512-byte hdwr sectors (18168 MB)
sdh: Write Protect is off
sdh: Mode Sense: 6b 00 10 08
SCSI device sdh: drive cache: write through w/ FUA
SCSI device sdh: 35484544 512-byte hdwr sectors (18168 MB)
sdh: Write Protect is off
sdh: Mode Sense: 6b 00 10 08
SCSI device sdh: drive cache: write through w/ FUA
 sdh:end_request: I/O error, dev sdh, sector 0
end_request: I/O error, dev sdh, sector 0
end_request: I/O error, dev sdh, sector 0
 unable to read partition table
sd 3:0:1:5: Attached scsi disk sdh
  Vendor: SYMBIOS   Model: INF-01-00         Rev: 0205
  Type:   Direct-Access                      ANSI SCSI revision: 02
 target3:0:1: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
scsi3:A:1:6: Tagged Queuing enabled.  Depth 4
  Vendor: SYMBIOS   Model: INF-01-00         Rev: 0205
  Type:   Direct-Access                      ANSI SCSI revision: 02
 target3:0:1: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
scsi3:A:1:7: Tagged Queuing enabled.  Depth 4
SCSI device sdi: 35484544 512-byte hdwr sectors (18168 MB)
sdi: Write Protect is off
sdi: Mode Sense: 6b 00 10 08
SCSI device sdi: drive cache: write through w/ FUA
SCSI device sdi: 35484544 512-byte hdwr sectors (18168 MB)
sdi: Write Protect is off
sdi: Mode Sense: 6b 00 10 08
SCSI device sdi: drive cache: write through w/ FUA
 sdi:end_request: I/O error, dev sdi, sector 0
end_request: I/O error, dev sdi, sector 0
end_request: I/O error, dev sdi, sector 0
 unable to read partition table
sd 3:0:1:7: Attached scsi disk sdi
device-mapper: 4.5.0-ioctl (2005-10-04) initialised: dm-devel@redhat.com
md: raid1 personality registered for level 1
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdb2 ...
md:  adding sdb2 ...
md: sdb1 has different UUID to sdb2
md:  adding sda2 ...
md: sda1 has different UUID to sdb2
md: created md1
md: bind<sda2>
md: bind<sdb2>
md: running: <sdb2><sda2>
raid1: raid set md1 active with 2 out of 2 mirrors
md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: bind<sdb1>
md: running: <sdb1><sda1>
raid1: raid set md0 active with 2 out of 2 mirrors
md: ... autorun DONE.
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdc, sector 35484416
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdd, sector 0
end_request: I/O error, dev sdd, sector 0
end_request: I/O error, dev sdd, sector 35484416
end_request: I/O error, dev sdd, sector 0
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sde, sector 35484416
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sdf, sector 0
end_request: I/O error, dev sdf, sector 0
end_request: I/O error, dev sdf, sector 35484416
end_request: I/O error, dev sdf, sector 0
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdg, sector 35484416
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdh, sector 0
end_request: I/O error, dev sdh, sector 0
end_request: I/O error, dev sdh, sector 35484416
end_request: I/O error, dev sdh, sector 0
end_request: I/O error, dev sdi, sector 0
end_request: I/O error, dev sdi, sector 0
end_request: I/O error, dev sdi, sector 35484416
end_request: I/O error, dev sdi, sector 0
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdd, sector 0
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sdf, sector 0
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdh, sector 0
end_request: I/O error, dev sdi, sector 0
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:1:0: Attached scsi generic sg1 type 0
 0:0:6:0: Attached scsi generic sg2 type 3
 1:0:5:0: Attached scsi generic sg3 type 5
sd 3:0:1:0: Attached scsi generic sg4 type 0
sd 3:0:1:1: Attached scsi generic sg5 type 0
sd 3:0:1:2: Attached scsi generic sg6 type 0
sd 3:0:1:3: Attached scsi generic sg7 type 0
sd 3:0:1:4: Attached scsi generic sg8 type 0
sd 3:0:1:5: Attached scsi generic sg9 type 0
 3:0:1:6: Attached scsi generic sg10 type 0
sd 3:0:1:7: Attached scsi generic sg11 type 0
sr0: scsi-1 drive
Uniform CD-ROM driver Revision: 3.20
sr 1:0:5:0: Attached scsi CD-ROM sr0
PIIX4: IDE controller at PCI slot 0000:00:0c.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x24a0-0x24a7, BIOS settings: hda:pio, hdb:pio
Probing IDE interface ide0...
PIIX4: IDE controller at PCI slot 0000:00:10.0
PIIX4: device not capable of full native PCI mode
PIIX4: device disabled (BIOS)
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
e100: Intel(R) PRO/100 Network Driver, 3.5.10-k2-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
e100: eth0: e100_probe: addr 0xfa200000, irq 145, MAC addr 00:D0:B7:6C:17:E7
e100: eth1: e100_probe: addr 0xfa201000, irq 153, MAC addr 00:D0:B7:6C:0D:F5
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
EXT3 FS on dm-0, internal journal
end_request: I/O error, dev sdc, sector 8
printk: 74 messages suppressed.
Buffer I/O error on device sdc, logical block 1
end_request: I/O error, dev sdc, sector 8
Buffer I/O error on device sdc, logical block 1
end_request: I/O error, dev sdc, sector 35484528
Buffer I/O error on device sdc, logical block 4435566
end_request: I/O error, dev sdc, sector 35484528
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484480
end_request: I/O error, dev sdc, sector 35484480
end_request: I/O error, dev sdc, sector 35484288
end_request: I/O error, dev sdc, sector 35484288
end_request: I/O error, dev sdc, sector 35484288
end_request: I/O error, dev sdc, sector 35484288
end_request: I/O error, dev sdc, sector 35484528
end_request: I/O error, dev sdc, sector 35484528
end_request: I/O error, dev sdc, sector 35484144
end_request: I/O error, dev sdc, sector 35484144
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdd, sector 8
end_request: I/O error, dev sdd, sector 8
end_request: I/O error, dev sdd, sector 35484528
end_request: I/O error, dev sdd, sector 35484528
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484480
end_request: I/O error, dev sdd, sector 35484480
end_request: I/O error, dev sdd, sector 35484288
end_request: I/O error, dev sdd, sector 35484288
end_request: I/O error, dev sdd, sector 35484288
end_request: I/O error, dev sdd, sector 35484288
end_request: I/O error, dev sdd, sector 35484528
end_request: I/O error, dev sdd, sector 35484528
end_request: I/O error, dev sdd, sector 35484144
end_request: I/O error, dev sdd, sector 35484144
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sde, sector 8
end_request: I/O error, dev sde, sector 8
end_request: I/O error, dev sde, sector 35484528
end_request: I/O error, dev sde, sector 35484528
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484480
end_request: I/O error, dev sde, sector 35484480
end_request: I/O error, dev sde, sector 35484288
end_request: I/O error, dev sde, sector 35484288
end_request: I/O error, dev sde, sector 35484288
end_request: I/O error, dev sde, sector 35484288
end_request: I/O error, dev sde, sector 35484528
end_request: I/O error, dev sde, sector 35484528
end_request: I/O error, dev sde, sector 35484144
end_request: I/O error, dev sde, sector 35484144
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sdf, sector 8
end_request: I/O error, dev sdf, sector 8
end_request: I/O error, dev sdf, sector 35484528
end_request: I/O error, dev sdf, sector 35484528
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484480
end_request: I/O error, dev sdf, sector 35484480
end_request: I/O error, dev sdf, sector 35484288
end_request: I/O error, dev sdf, sector 35484288
end_request: I/O error, dev sdf, sector 35484288
end_request: I/O error, dev sdf, sector 35484288
end_request: I/O error, dev sdf, sector 35484528
end_request: I/O error, dev sdf, sector 35484528
end_request: I/O error, dev sdf, sector 35484144
end_request: I/O error, dev sdf, sector 35484144
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdg, sector 8
end_request: I/O error, dev sdg, sector 8
end_request: I/O error, dev sdg, sector 35484528
end_request: I/O error, dev sdg, sector 35484528
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484480
end_request: I/O error, dev sdg, sector 35484480
end_request: I/O error, dev sdg, sector 35484288
end_request: I/O error, dev sdg, sector 35484288
end_request: I/O error, dev sdg, sector 35484288
end_request: I/O error, dev sdg, sector 35484288
end_request: I/O error, dev sdg, sector 35484528
end_request: I/O error, dev sdg, sector 35484528
end_request: I/O error, dev sdg, sector 35484144
end_request: I/O error, dev sdg, sector 35484144
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdh, sector 8
end_request: I/O error, dev sdh, sector 8
end_request: I/O error, dev sdh, sector 35484528
end_request: I/O error, dev sdh, sector 35484528
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484480
end_request: I/O error, dev sdh, sector 35484480
end_request: I/O error, dev sdh, sector 35484288
end_request: I/O error, dev sdh, sector 35484288
end_request: I/O error, dev sdh, sector 35484288
end_request: I/O error, dev sdh, sector 35484288
end_request: I/O error, dev sdh, sector 35484528
end_request: I/O error, dev sdh, sector 35484528
end_request: I/O error, dev sdh, sector 35484144
end_request: I/O error, dev sdh, sector 35484144
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdi, sector 8
end_request: I/O error, dev sdi, sector 8
end_request: I/O error, dev sdi, sector 35484528
end_request: I/O error, dev sdi, sector 35484528
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484480
end_request: I/O error, dev sdi, sector 35484480
end_request: I/O error, dev sdi, sector 35484288
end_request: I/O error, dev sdi, sector 35484288
end_request: I/O error, dev sdi, sector 35484288
end_request: I/O error, dev sdi, sector 35484288
end_request: I/O error, dev sdi, sector 35484528
end_request: I/O error, dev sdi, sector 35484528
end_request: I/O error, dev sdi, sector 35484144
end_request: I/O error, dev sdi, sector 35484144
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdc, sector 35484416
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdd, sector 0
end_request: I/O error, dev sdd, sector 0
end_request: I/O error, dev sdd, sector 35484416
end_request: I/O error, dev sdd, sector 0
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sde, sector 35484416
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sdf, sector 0
end_request: I/O error, dev sdf, sector 0
end_request: I/O error, dev sdf, sector 35484416
end_request: I/O error, dev sdf, sector 0
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdg, sector 35484416
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdh, sector 0
end_request: I/O error, dev sdh, sector 0
end_request: I/O error, dev sdh, sector 35484416
end_request: I/O error, dev sdh, sector 0
end_request: I/O error, dev sdi, sector 0
end_request: I/O error, dev sdi, sector 0
end_request: I/O error, dev sdi, sector 35484416
end_request: I/O error, dev sdi, sector 0
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdd, sector 0
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sdf, sector 0
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdh, sector 0
end_request: I/O error, dev sdi, sector 0
end_request: I/O error, dev sdc, sector 8
end_request: I/O error, dev sdc, sector 8
end_request: I/O error, dev sdc, sector 35484528
end_request: I/O error, dev sdc, sector 35484528
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484480
end_request: I/O error, dev sdc, sector 35484480
end_request: I/O error, dev sdc, sector 35484288
end_request: I/O error, dev sdc, sector 35484288
end_request: I/O error, dev sdc, sector 35484288
end_request: I/O error, dev sdc, sector 35484288
end_request: I/O error, dev sdc, sector 35484528
end_request: I/O error, dev sdc, sector 35484528
end_request: I/O error, dev sdc, sector 35484144
end_request: I/O error, dev sdc, sector 35484144
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdc, sector 35484536
end_request: I/O error, dev sdd, sector 8
end_request: I/O error, dev sdd, sector 8
end_request: I/O error, dev sdd, sector 35484528
end_request: I/O error, dev sdd, sector 35484528
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484480
end_request: I/O error, dev sdd, sector 35484480
end_request: I/O error, dev sdd, sector 35484288
end_request: I/O error, dev sdd, sector 35484288
end_request: I/O error, dev sdd, sector 35484288
end_request: I/O error, dev sdd, sector 35484288
end_request: I/O error, dev sdd, sector 35484528
end_request: I/O error, dev sdd, sector 35484528
end_request: I/O error, dev sdd, sector 35484144
end_request: I/O error, dev sdd, sector 35484144
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sdd, sector 35484536
end_request: I/O error, dev sde, sector 8
end_request: I/O error, dev sde, sector 8
end_request: I/O error, dev sde, sector 35484528
end_request: I/O error, dev sde, sector 35484528
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484480
end_request: I/O error, dev sde, sector 35484480
end_request: I/O error, dev sde, sector 35484288
end_request: I/O error, dev sde, sector 35484288
end_request: I/O error, dev sde, sector 35484288
end_request: I/O error, dev sde, sector 35484288
end_request: I/O error, dev sde, sector 35484528
end_request: I/O error, dev sde, sector 35484528
end_request: I/O error, dev sde, sector 35484144
end_request: I/O error, dev sde, sector 35484144
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sde, sector 35484536
end_request: I/O error, dev sdf, sector 8
end_request: I/O error, dev sdf, sector 8
end_request: I/O error, dev sdf, sector 35484528
end_request: I/O error, dev sdf, sector 35484528
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484480
end_request: I/O error, dev sdf, sector 35484480
end_request: I/O error, dev sdf, sector 35484288
end_request: I/O error, dev sdf, sector 35484288
end_request: I/O error, dev sdf, sector 35484288
end_request: I/O error, dev sdf, sector 35484288
end_request: I/O error, dev sdf, sector 35484528
end_request: I/O error, dev sdf, sector 35484528
end_request: I/O error, dev sdf, sector 35484144
end_request: I/O error, dev sdf, sector 35484144
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdf, sector 35484536
end_request: I/O error, dev sdg, sector 8
end_request: I/O error, dev sdg, sector 8
end_request: I/O error, dev sdg, sector 35484528
end_request: I/O error, dev sdg, sector 35484528
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484480
end_request: I/O error, dev sdg, sector 35484480
end_request: I/O error, dev sdg, sector 35484288
end_request: I/O error, dev sdg, sector 35484288
end_request: I/O error, dev sdg, sector 35484288
end_request: I/O error, dev sdg, sector 35484288
end_request: I/O error, dev sdg, sector 35484528
end_request: I/O error, dev sdg, sector 35484528
end_request: I/O error, dev sdg, sector 35484144
end_request: I/O error, dev sdg, sector 35484144
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdg, sector 35484536
end_request: I/O error, dev sdh, sector 8
end_request: I/O error, dev sdh, sector 8
end_request: I/O error, dev sdh, sector 35484528
end_request: I/O error, dev sdh, sector 35484528
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484480
end_request: I/O error, dev sdh, sector 35484480
end_request: I/O error, dev sdh, sector 35484288
end_request: I/O error, dev sdh, sector 35484288
end_request: I/O error, dev sdh, sector 35484288
end_request: I/O error, dev sdh, sector 35484288
end_request: I/O error, dev sdh, sector 35484528
end_request: I/O error, dev sdh, sector 35484528
end_request: I/O error, dev sdh, sector 35484144
end_request: I/O error, dev sdh, sector 35484144
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdh, sector 35484536
end_request: I/O error, dev sdi, sector 8
end_request: I/O error, dev sdi, sector 8
end_request: I/O error, dev sdi, sector 35484528
end_request: I/O error, dev sdi, sector 35484528
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484480
end_request: I/O error, dev sdi, sector 35484480
end_request: I/O error, dev sdi, sector 35484288
end_request: I/O error, dev sdi, sector 35484288
end_request: I/O error, dev sdi, sector 35484288
end_request: I/O error, dev sdi, sector 35484288
end_request: I/O error, dev sdi, sector 35484528
end_request: I/O error, dev sdi, sector 35484528
end_request: I/O error, dev sdi, sector 35484144
end_request: I/O error, dev sdi, sector 35484144
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdi, sector 35484536
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdc, sector 35484416
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdd, sector 0
end_request: I/O error, dev sdd, sector 0
end_request: I/O error, dev sdd, sector 35484416
end_request: I/O error, dev sdd, sector 0
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sde, sector 35484416
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sdf, sector 0
end_request: I/O error, dev sdf, sector 0
end_request: I/O error, dev sdf, sector 35484416
end_request: I/O error, dev sdf, sector 0
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdg, sector 35484416
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdh, sector 0
end_request: I/O error, dev sdh, sector 0
end_request: I/O error, dev sdh, sector 35484416
end_request: I/O error, dev sdh, sector 0
end_request: I/O error, dev sdi, sector 0
end_request: I/O error, dev sdi, sector 0
end_request: I/O error, dev sdi, sector 35484416
end_request: I/O error, dev sdi, sector 0
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdc, sector 35484416
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdd, sector 0
end_request: I/O error, dev sdd, sector 0
end_request: I/O error, dev sdd, sector 35484416
end_request: I/O error, dev sdd, sector 0
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sde, sector 35484416
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sdf, sector 0
end_request: I/O error, dev sdf, sector 0
end_request: I/O error, dev sdf, sector 35484416
end_request: I/O error, dev sdf, sector 0
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdg, sector 35484416
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdh, sector 0
end_request: I/O error, dev sdh, sector 0
end_request: I/O error, dev sdh, sector 35484416
end_request: I/O error, dev sdh, sector 0
end_request: I/O error, dev sdi, sector 0
end_request: I/O error, dev sdi, sector 0
end_request: I/O error, dev sdi, sector 35484416
end_request: I/O error, dev sdi, sector 0
end_request: I/O error, dev sdc, sector 0
end_request: I/O error, dev sdd, sector 0
end_request: I/O error, dev sde, sector 0
end_request: I/O error, dev sdf, sector 0
end_request: I/O error, dev sdg, sector 0
end_request: I/O error, dev sdh, sector 0
end_request: I/O error, dev sdi, sector 0
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2228216k swap on /dev/vol00/swap.  Priority:-1 extents:1 across:2228216k

--------------020505020904070300070600--
