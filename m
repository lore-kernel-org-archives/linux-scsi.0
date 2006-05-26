From: "Dan Carpenter" <error27@gmail.com>
Subject: Re: mptspi doesn't work the nStor
Date: Fri, 26 May 2006 16:15:56 -0700
Message-ID: <a63d67fe0605261615s4e8fc487l60402784b53252af@mail.gmail.com>
References: <a63d67fe0605221637i231d4b48n942461ccdf4ee470@mail.gmail.com>
	 <008901c67e1f$654674c0$321015ac@ericmoore>
	 <a63d67fe0605232346p73d66be7jc0d717604e894ff6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_39575_22692921.1148685356485"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0102.google.com ([64.233.162.203]:37568 "EHLO
	nz-out-0102.google.com") by vger.kernel.org with ESMTP
	id S1751683AbWEZXP5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 May 2006 19:15:57 -0400
Received: by nz-out-0102.google.com with SMTP id s18so161971nze
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2006 16:15:56 -0700 (PDT)
In-Reply-To: <a63d67fe0605232346p73d66be7jc0d717604e894ff6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, coldwell@redhat.com, sprelutsky@penguincomputing.com

------=_Part_39575_22692921.1148685356485
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 5/23/06, Dan Carpenter <error27@gmail.com> wrote:
> On 5/22/06, Moore, Eric <Eric.Moore@lsil.com> wrote:
>
> > Ok, I see various things here, such as the end device being busy, and d=
ata underruns,
> > and device not there.  Nothing conclusive.  Can you send me your pariti=
cular dmesg
> > with debuging enabled in the driver.  Also in private email I will send=
 you our latest drivers.
> >
> > Eric Moore
>

I've attached a better dmesg.  This one doesn't have drives connected
to the fusion card internally.

regards,
dan carpenter

------=_Part_39575_22692921.1148685356485
Content-Type: text/plain; name=dmesg_lsi_fix.txt; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Attachment-Id: f_enp5h7nk
Content-Disposition: attachment; filename="dmesg_lsi_fix.txt"

Bootdata ok (command line is ro root=/dev/VolGroup00/LogVol00 )
Linux version 2.6.16-1.2122_FC5 (bhcompile@hs20-bc1-7.build.redhat.com) (gcc version 4.1.0 20060304 (Red Hat 4.1.0-3)) #1 SMP Sun May 21 15:01:10 EDT 2006
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fffe000 (ACPI data)
 BIOS-e820: 000000003fffe000 - 0000000040000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fec10000 - 00000000fec11000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
ACPI: RSDP (v000 ACPIAM                                ) @ 0x00000000000f8040
ACPI: RSDT (v001 A M I  OEMRSDT  0x02000617 MSFT 0x00000097) @ 0x000000003fff0000
ACPI: FADT (v002 A M I  OEMFACP  0x02000617 MSFT 0x00000097) @ 0x000000003fff0200
ACPI: MADT (v001 A M I  OEMAPIC  0x02000617 MSFT 0x00000097) @ 0x000000003fff0390
ACPI: SPCR (v001 A M I  OEMSPCR  0x02000617 MSFT 0x00000097) @ 0x000000003fff0420
ACPI: OEMB (v001 A M I  AMI_OEM  0x02000617 MSFT 0x00000097) @ 0x000000003fffe040
ACPI: DSDT (v001  DOLPH DOLPH164 0x00000164 INTL 0x02002026) @ 0x0000000000000000
No NUMA configuration found
Faking a node at 0000000000000000-000000003fff0000
Bootmem setup node 0 0000000000000000-000000003fff0000
On node 0 totalpages: 256787
  DMA zone: 2786 pages, LIFO batch:0
  DMA32 zone: 254001 pages, LIFO batch:31
  Normal zone: 0 pages, LIFO batch:0
  HighMem zone: 0 pages, LIFO batch:0
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
Processor #6 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
Processor #1 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] enabled)
Processor #7 15:4 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec10000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 32, address 0xfec10000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ10 used by override.
Setting APIC routing to physical flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
Checking aperture...
SMP: Allowing 4 CPUs, 0 hotplug CPUs
Built 1 zonelists
Kernel command line: ro root=/dev/VolGroup00/LogVol00 
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 131072 bytes)
time.c: Using 3.579545 MHz WALL PM GTOD PIT/TSC timer.
time.c: Detected 2793.257 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Memory: 1023372k/1048512k available (2305k kernel code, 24752k reserved, 1212k data, 196k init)
Calibrating delay using timer specific routine.. 5595.15 BogoMIPS (lpj=11190311)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 256
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU0: Thermal monitoring enabled (TM1)
Using local APIC timer interrupts.
result 12469818
Detected 12.469 MHz APIC timer.
Booting processor 1/4 APIC 0x6
Initializing CPU#1
Calibrating delay using timer specific routine.. 5586.79 BogoMIPS (lpj=11173598)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 3
CPU1: Thermal monitoring enabled (TM1)
                  Intel(R) Xeon(TM) CPU 2.80GHz stepping 01
Booting processor 2/4 APIC 0x1
Initializing CPU#2
Calibrating delay using timer specific routine.. 5586.81 BogoMIPS (lpj=11173637)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU2: Thermal monitoring enabled (TM1)
                  Intel(R) Xeon(TM) CPU 2.80GHz stepping 01
APIC error on CPU2: 00(40)
Booting processor 3/4 APIC 0x7
Initializing CPU#3
Calibrating delay using timer specific routine.. 5586.94 BogoMIPS (lpj=11173896)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 3
CPU3: Thermal monitoring enabled (TM1)
                  Intel(R) Xeon(TM) CPU 2.80GHz stepping 01
APIC error on CPU3: 00(40)
Brought up 4 CPUs
testing NMI watchdog ... OK.
migration_cost=10,849
checking if image is initramfs... it is
Freeing initrd memory: 1900k freed
DMI 2.3 present.
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Subsystem revision 20060127
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0800-087f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH4 GPIO
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
Boot video device is 0000:07:01.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EPA0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EPB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EPB1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EPC0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EPC1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 9 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 9 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 6 9 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 *9 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 9 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 5) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs *7)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 16 devices
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI-DMA: Disabling IOMMU.
pnp: 00:09: ioport range 0xa00-0xa3f has been reserved
PCI: Bridge: 0000:00:02.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:04.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: fc300000-fc3fffff
  PREFETCH window: fbf00000-fbffffff
PCI: Bridge: 0000:00:07.0
  IO window: disabled.
  MEM window: fc400000-fc4fffff
  PREFETCH window: fc000000-fc0fffff
PCI: Bridge: 0000:00:1c.0
  IO window: 6000-afff
  MEM window: fc500000-fc9fffff
  PREFETCH window: fc100000-fc1fffff
PCI: Bridge: 0000:00:1e.0
  IO window: b000-dfff
  MEM window: fca00000-feafffff
  PREFETCH window: 50000000-500fffff
GSI 16 sharing vector 0xA9 and IRQ 16
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:04.0 to 64
ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:05.0 to 64
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:06.0 to 64
ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:07.0 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
IA32 emulation $Id: sys_ia32.c,v 1.32 2002/03/24 13:02:28 ak Exp $
audit: initializing netlink socket (disabled)
audit(1148659228.968:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
Initializing Cryptographic API
ksign: Installing public key data
Loading keyring
- Added public key 8E9602B123E405B3
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
Allocate Port Service[0000:00:02.0:pcie00]
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:04.0 to 64
Allocate Port Service[0000:00:04.0:pcie00]
ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:05.0 to 64
Allocate Port Service[0000:00:05.0:pcie00]
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:06.0 to 64
Allocate Port Service[0000:00:06.0:pcie00]
ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:07.0 to 64
Allocate Port Service[0000:00:07.0:pcie00]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Processor [CPU2] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.101 (c) Dave Jones
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
isa bounce pool size: 16 pages
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH5: IDE controller at PCI slot 0000:00:1f.1
GSI 17 sharing vector 0xB1 and IRQ 17
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 17
ICH5: chipset revision 2
ICH5: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xfc00-0xfc07, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xfc08-0xfc0f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hda: CD-224E-N, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
Probing IDE interface ide1...
hda: ATAPI 24X CD-ROM drive, 256kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
usbcore: registered new driver libusual
usbcore: registered new driver hiddev
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
mice: PS/2 mouse device common for all mice
md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 4.39
NET: Registered protocol family 2
input: AT Translated Set 2 keyboard as /class/input/input0
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
TCP bic registered
Initializing IPsec netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
ACPI wakeup devices: 
EPB0 EPB1 EPC0 EPC1 P0P4 P0P5 USB1 USB2 EUSB SBRG PS2K PS2M 
ACPI: (supports S0 S4 S5)
Freeing unused kernel memory: 196k freed
Write protecting the kernel read-only data: 432k
Fusion MPT base driver 3.02.73
Copyright (c) 1999-2006 LSI Logic Corporation
mptbase: Register for IOC reset notification
SCSI subsystem initialized
Fusion MPT SPI Host driver 3.02.73
mptspi: Registered for IOC event notifications
mptspi: Registered for IOC reset notifications
GSI 18 sharing vector 0xB9 and IRQ 18
ACPI: PCI Interrupt 0000:06:03.0[A] -> GSI 24 (level, low) -> IRQ 18
mptbase: mpt_adapter_install
mptbase: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED
mptbase: Using 64 bit consistent mask
mptbase: ii=0 port i/o @ 9000, psize=0x100 bytes
mptbase: ii=1 MPT adapter @ fc9a0000, msize=0x20000 bytes
mptbase: mem = ffffc20000040000, mem_phys = fc9a0000
mptbase: facts @ ffff81003f3acbec, pfacts[0] @ ffff81003f3acc3c
mptbase: ioc0 installed at interrupt 18
mptbase: ioc0: PCI device 0000:06:03.0 devfn=6/18, searching for devfn match on ffffffff or 1
mptbase: Initiating ioc0 bringup
mptbase::MakeIocReady, ioc0 [raw] state=22000000
mptbase: ioc0: IOC operational unexpected
mptbase: whoinit 0x2 statefault 0 force 0
mptbase: ioc0: Sending IOC reset(0x40)!
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: Sending get IocFacts request req_sz=12 reply_sz=80
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: HandShake request start reqBytes=12, WaitCnt=1
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: Handshake request frame (@ffff81003ec558d8) header
  03000000 00000000 00000000
mptbase: ioc0: HandShake request post done, WaitCnt=1
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitCnt=1 First handshake reply word=030f0102
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
input: ImExPS/2 Generic Explorer Mouse as /class/input/input1
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: Got Handshake reply:
  030f0102 00000e00 00000000 00000000 00000000 00080030 001800ff 04020000 00000000 000100de 00000000 01100080 0000f800 ca42ce52 01032700
mptbase: ioc0: WaitForDoorbell REPLY WaitCnt=1 (sz=15)
mptbase: ioc0: HandShake reply count=15
mptbase: ioc0: NB_for_64_byte_frame=2 NBShiftFactor=5 BlockSize=8
mptbase: ioc0: reply_sz=80 mpt_reply_depth=128 ReplyQueueDepth=255 reply_depth=128
mptbase: ioc0: req_sz=96 mpt_can_queue=128 GlobalCredits=222 req_depth=222
mptbase: ioc0: Sending get PortFacts(0) request
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: HandShake request start reqBytes=12, WaitCnt=1
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: Handshake request frame (@ffff81003ec558c8) header
  05000000 00000000 00000000
mptbase: ioc0: HandShake request post done, WaitCnt=1
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitCnt=1 First handshake reply word=050a0000
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: Got Handshake reply:
  050a0000 00000000 00000000 00000000 00000000 00100100 00080007 00000001 00000000 00000000
mptbase: ioc0: WaitForDoorbell REPLY WaitCnt=1 (sz=10)
mptbase: ioc0: HandShake reply count=10
ioc0: 53C1030: Capabilities={Initiator}
mptbase: ioc0 dma_addr_t size=8 u64 size=8
mptbase: ioc0 req_sz=96 SGE_size=12 scale=8 num_sge=11 numSGE=329 MaxChainDepth=48 maxSGEs=340 mpt_sg_tablesize=40
mptbase: ioc0 numSGE=29 now
mptbase: ioc0 Now num_chain=6
mptbase: ioc0 req_depth=222 max num_chain=1332 mpt_chain_alloc_percent=100 total_num_chain=1332
mptbase: ioc0 ReplyBuffer sz=80 bytes, ReplyDepth=128
mptbase: ioc0 Total ReplyBuffer sz=10240[2800] bytes
mptbase: ioc0 RequestBuffer sz=96 bytes, RequestDepth=222
mptbase: ioc0 Total RequestBuffer sz=21312[5340] bytes
mptbase: ioc0 Total ChainBuffer sz=127872[1f380] bytes total_num_chain=1332
mptbase: ioc0 Total ioc alloc size=159424[26ec0] bytes
mptbase: ioc0 Total ioc alloc @ ffff81003ec80000[000000003ec80000]
mptbase: ioc0 ReplyBuffers @ ffff81003ec80000[000000003ec80000]
mptbase: ioc0 RequestBuffers @ ffff81003ec82800[000000003ec82800]
mptbase :ioc0 ChainBuffers @ ffff81003ec87b40(000000003ec87b40)
mptbase: ioc0 SenseBuffers @ ffff81003ec3c000[000000003ec3c000]
mptbase: ioc0 ReqToChain alloc  @ ffff81000228f000, sz=888 bytes
mptbase: ioc0 RequestNB alloc  @ ffff81003f3b0c00, sz=888 bytes
mptbase: ioc0 ChainToChain alloc @ ffff81003fc64000, sz=5328 bytes
mptbase: ioc0: upload_fw 0 facts.Flags=0
mptbase: ioc0: ioc_init.MaxDevice=16
mptbase: ioc0: facts.MsgVersion=102
mptbase: ioc0: Sending IOCInit (req @ ffff81003ec55868)
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: HandShake request start reqBytes=44, WaitCnt=1
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: Handshake request frame (@ffff81003ec55868) header
  02000004 00011000 00000000
mptbase: ioc0: HandShake request post done, WaitCnt=1
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=10
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitCnt=1 First handshake reply word=02050004
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: Got Handshake reply:
  02050004 00011000 00000000 00000000 00000000
mptbase: ioc0: WaitForDoorbell REPLY WaitCnt=1 (sz=5)
mptbase: ioc0: HandShake reply count=5
mptbase: ioc0: Sending PortEnable (req @ ffff81003ec55868)
mptbase: ioc0: Sending Port(0)Enable (req @ ffff81003ec558d8)
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: HandShake request start reqBytes=12, WaitCnt=1
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: Handshake request frame (@ffff81003ec558d8) header
  06000000 00000000 00000000
mptbase: ioc0: HandShake request post done, WaitCnt=1
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=300
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitCnt=1 First handshake reply word=06050000
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: Got Handshake reply:
  06050000 00000000 00000000 00000000 00000000
mptbase: ioc0: WaitForDoorbell REPLY WaitCnt=1 (sz=5)
mptbase: ioc0: HandShake reply count=5
mptbase: ioc0: INFO - Wait IOC_OPERATIONAL state (cnt=0)
mptbase: ioc0: Sending EventNotification (1) request ffff81003ec82800
mptbase: ioc0: SCSI device NVRAM settings @ ffff810002351780, sz=64
  07080001 80000000 000f0000 00000000 00000000 0000000a 00000000 00000001
mptbase: ioc0: WARNING - MPT Event=0Ah (Events ON) detected!
mptbase: Event data:
 00000001
mptbase: ioc0: Routing Event to event handler #14
mptscsih: ioc0: MPT event (=0Ah) routed to SCSI host driver!
mptbase: ioc0: Sending Config request type 3, page 0 and action 0
  04060000 00000000 000f0001 00000000 00000000 03000302
mptbase: ioc0: config_complete (mf=ffff81003ec82860,mr=ffff81003ec80050)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc0: Sending Config request type 3, page 0 and action 1
  04060001 00000000 000f0002 00000000 00000000 03000302
mptbase: ioc0: config_complete (mf=ffff81003ec828c0,mr=ffff81003ec800a0)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc0: Sending Config request type 3, page 2 and action 0
  04060000 00000000 000f0003 00000000 00000000 23021302
mptbase: ioc0: config_complete (mf=ffff81003ec82920,mr=ffff81003ec800f0)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc0: Sending Config request type 3, page 2 and action 6
  04060006 00000000 000f0004 00000000 00000000 03021302
mptbase: ioc0: config_complete (mf=ffff81003ec82980,mr=ffff81003ec80140)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc0: Sending Config request type 4, page 1 and action 0
  04060000 00000000 000f0005 00000000 00000000 14010405
mptbase: ioc0: config_complete (mf=ffff81003ec829e0,mr=ffff81003ec80190)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc0: Sending Config request type 4, page 0 and action 0
  04060000 00000000 000f0006 00000000 00000000 04000304
mptbase: ioc0: config_complete (mf=ffff81003ec82a40,mr=ffff81003ec801e0)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc0: Headers: 0: version 4 length 3
mptbase: ioc0: Headers: 1: version 5 length 4
mptbase: ioc0: Sending Config request type 1, page 2 and action 0
  04060000 00000000 000f0007 00000000 00000000 01020302
mptbase: ioc0: config_complete (mf=ffff81003ec82aa0,mr=ffff81003ec80230)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc0: Sending Config request type 1, page 2 and action 1
  04060001 00000000 000f0008 00000000 00000000 01020302
mptbase: ioc0: config_complete (mf=ffff81003ec82b00,mr=ffff81003ec80280)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc0: Sending Config request type 1, page 1 and action 0
  04060000 00000000 000f0009 00000000 00000000 21010401
mptbase: ioc0: config_complete (mf=ffff81003ec82b60,mr=ffff81003ec802d0)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc0: Sending Config request type 1, page 1 and action 1
  04060001 00000000 000f000a 00000000 00000000 01010401
mptbase: ioc0: config_complete (mf=ffff81003ec82bc0,mr=ffff81003ec80320)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc0: Coalescing Enabled Timeout = 10
mptbase: ioc0: Sending Config request type 1, page 4 and action 0
  04060000 00000000 000f000b 00000000 00000000 11040300
mptbase: ioc0: config_complete (mf=ffff81003ec82c20,mr=ffff81003ec80370)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc0: Sending Config request type 1, page 4 and action 1
  04060001 00000000 000f000c 00000000 00000000 01040300
mptbase: ioc0: config_complete (mf=ffff81003ec82c80,mr=ffff81003ec803c0)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc0: Sending Config request type 0, page 2 and action 0
  04060000 00000000 000f000d 00000000 00000000 20020700
mptbase: ioc0: config_complete (mf=ffff81003ec82ce0,mr=ffff81003ec80410)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc0: Sending Config request type 0, page 2 and action 1
  04060001 00000000 000f000e 00000000 00000000 00020700
mptbase: ioc0: config_complete (mf=ffff81003ec82d40,mr=ffff81003ec80460)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc0: mpt_can_queue=128 req_depth=222 can_queue=128
mptspi: ioc0: ScsiLookup @ ffff81003fd14000, sz=1776
  Targets @ ffff81003fd0f140, sz=128
scsi0 : ioc0: LSI53C1030, FwRev=01032700h, Ports=1, MaxQ=222, IRQ=18
mptscsih: ioc0: TMHandler Entered!
mptscsih: ioc0: IssueTaskMgmt request @ ffff81003ec82da0
mptscsih: ioc0: IssueTaskMgmt: ctx2abort (0x00000000) type=4
TM_REQUEST:
01000000 04000400 000d000f 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000 00000000 00000000 
mptbase: ioc0: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc0: mpt_send_handshake_request start, WaitCnt=1
mptbase: ioc0: WaitForDoorbell ACK (count=0)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell ACK (count=1)
mptbase: ioc0: WaitForDoorbell INT (cnt=0) howlong=10
  01060000 04000400 000d000f 00000000 00000000 00000000
mptscsih: ioc0: WARNING - TaskMgmt completed (mf=ffff81003ec82da0,mr=ffff81003ec804b0)
mptscsih: ioc0: WARNING -   TaskType = 4, TerminationCount=0
TM_REPLY MessageLength=6:
 01060000 04000400 000d000f 00000000 00000000 00000000
mptscsih: ioc0: WARNING -   SCSI TaskMgmt (4) IOCStatus=0000 IOCLogInfo=00000000
mptscsih: ioc0: WARNING -  TaskMgmt SUCCESS
mptscsih: ioc0: Issue of TaskMgmt Successful!
mptscsih: ioc0: TMHandler rc = 0!
mptscsih: ioc0:  mptscsih_slave_alloc target=0 lun=0 pTarget=ffff81003ff84580
mptscsih: ioc0:  mptscsih_slave_alloc target=0 lun=0 pTarget=ffff81003ff84580 num_luns=1
mptscsih: ioc0:  set_dvflags: id=0 lun=0 negoNvram=0 cmd=12
  00080000 01014006 000e0010 00430000 00000000 00000000 00000000 00000000
Reply ha=0 id=0 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc0:  mptscsih_slave_destroy target=0 lun=0 type=0 pTarget=ffff81003ff84580
mptscsih: search_running target 0 lun 0 max 222
mptscsih: search_running target 0 lun 0 completed
mptscsih: ioc0:  mptscsih_slave_destroy target=0 lun=0 freeing pTarget=ffff81003ff84580
mptscsih: ioc0:  mptscsih_slave_destroy target=0 lun=0 pTarget=ffff81003ff84580 completed
mptscsih: ioc0:  mptscsih_slave_alloc target=1 lun=0 pTarget=ffff81003ff84580
mptscsih: ioc0:  mptscsih_slave_alloc target=1 lun=0 pTarget=ffff81003ff84580 num_luns=1
mptscsih: ioc0:  set_dvflags: id=1 lun=0 negoNvram=0 cmd=12
  00080001 01014006 000e0011 00430000 00000000 00000000 00000000 00000000
Reply ha=0 id=1 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc0:  mptscsih_slave_destroy target=1 lun=0 type=0 pTarget=ffff81003ff84580
mptscsih: search_running target 1 lun 0 max 222
mptscsih: search_running target 1 lun 0 completed
mptscsih: ioc0:  mptscsih_slave_destroy target=1 lun=0 freeing pTarget=ffff81003ff84580
mptscsih: ioc0:  mptscsih_slave_destroy target=1 lun=0 pTarget=ffff81003ff84580 completed
mptscsih: ioc0:  mptscsih_slave_alloc target=2 lun=0 pTarget=ffff81003ff84580
mptscsih: ioc0:  mptscsih_slave_alloc target=2 lun=0 pTarget=ffff81003ff84580 num_luns=1
mptscsih: ioc0:  set_dvflags: id=2 lun=0 negoNvram=0 cmd=12
  00080002 01014006 000e0012 00430000 00000000 00000000 00000000 00000000
Reply ha=0 id=2 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc0:  mptscsih_slave_destroy target=2 lun=0 type=0 pTarget=ffff81003ff84580
mptscsih: search_running target 2 lun 0 max 222
mptscsih: search_running target 2 lun 0 completed
mptscsih: ioc0:  mptscsih_slave_destroy target=2 lun=0 freeing pTarget=ffff81003ff84580
mptscsih: ioc0:  mptscsih_slave_destroy target=2 lun=0 pTarget=ffff81003ff84580 completed
mptscsih: ioc0:  mptscsih_slave_alloc target=3 lun=0 pTarget=ffff81003ff84580
mptscsih: ioc0:  mptscsih_slave_alloc target=3 lun=0 pTarget=ffff81003ff84580 num_luns=1
mptscsih: ioc0:  set_dvflags: id=3 lun=0 negoNvram=0 cmd=12
  00080003 01014006 000e0013 00430000 00000000 00000000 00000000 00000000
Reply ha=0 id=3 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc0:  mptscsih_slave_destroy target=3 lun=0 type=0 pTarget=ffff81003ff84580
mptscsih: search_running target 3 lun 0 max 222
mptscsih: search_running target 3 lun 0 completed
mptscsih: ioc0:  mptscsih_slave_destroy target=3 lun=0 freeing pTarget=ffff81003ff84580
mptscsih: ioc0:  mptscsih_slave_destroy target=3 lun=0 pTarget=ffff81003ff84580 completed
mptscsih: ioc0:  mptscsih_slave_alloc target=4 lun=0 pTarget=ffff81003ff84580
mptscsih: ioc0:  mptscsih_slave_alloc target=4 lun=0 pTarget=ffff81003ff84580 num_luns=1
mptscsih: ioc0:  set_dvflags: id=4 lun=0 negoNvram=0 cmd=12
mptscsih: ioc0:  set_dvflags: id=4 lun=0 negoNvram=0 cmd=12
  Vendor: nStor     Model: NexStorWahooSATA  Rev:     
  Type:   Direct-Access                      ANSI SCSI revision: 03
mptscsih: ioc0: device @ ffff81003f3a2800, id=4, LUN=0, channel=0
mptscsih: ioc0: sdtr 1 wdtr 1 ppr 1 inq length=144
mptscsih: ioc0: initTarget bus=0 id=4 lun=0 hd=ffff81003f33e518
Command-line QAS setting sets noQas=00 on id=4!
Enabling QAS due to byte56=0f on id=4!
MPT_SCSICFG_NEGOTIATE on id=4!
writeSDP1: id=4 width=0 factor=ff offset=0 negoFlags=0 request=ff00 config=0
mptscsih: ioc0: WriteSDP1 (mf=ffff81003ec83040, id=4, req=0xff00, cfg=0x0)
mptscsih: ioc0: writeSDP1: last_lun=63 on id=4
mptscsih: ioc0: write SDP1: id 4 pgaddr 0x4 req 0xff00 config 0x0
mptscsih: ioc0: Queue depth=64, tflags=1b
  04060002 00000000 000e0016 00000000 00000000 04010405
mptscsih: ioc0: negoFlags=0, maxOffset=7f, SyncFactor=8
mptscsih: ioc0: tagged 1, simple 1, ordered 0
mptscsih: ioc0:  set_dvflags: id=4 lun=0 negoNvram=0 cmd=0
  00080004 01014006 000e0017 00000102 00000000 00000000 00000012 00000000
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=01h SCSIStatus=02h
resid=0 bufflen=0 xfer_cnt=0
  sc->result is 00000002h
mptscsih: ioc0:  set_dvflags: id=4 lun=0 negoNvram=0 cmd=0
mptscsih: ioc0:  set_dvflags: id=4 lun=0 negoNvram=0 cmd=25
NEED_DV set for visible disk id 4
SCSI device sda: 384897024 512-byte hdwr sectors (197067 MB)
mptscsih: ioc0:  set_dvflags: id=4 lun=0 negoNvram=0 cmd=1a
NEED_DV set for visible disk id 4
sda: Write Protect is off
sda: Mode Sense: a7 00 10 08
mptscsih: ioc0:  set_dvflags: id=4 lun=0 negoNvram=0 cmd=1a
NEED_DV set for visible disk id 4
mptscsih: ioc0:  set_dvflags: id=4 lun=0 negoNvram=0 cmd=1a
NEED_DV set for visible disk id 4
SCSI device sda: drive cache: write back w/ FUA
mptscsih: ioc0:  set_dvflags: id=4 lun=0 negoNvram=0 cmd=0
mptscsih: ioc0:  set_dvflags: id=4 lun=0 negoNvram=0 cmd=25
NEED_DV set for visible disk id 4
SCSI device sda: 384897024 512-byte hdwr sectors (197067 MB)
mptscsih: ioc0:  set_dvflags: id=4 lun=0 negoNvram=0 cmd=1a
NEED_DV set for visible disk id 4
sda: Write Protect is off
sda: Mode Sense: a7 00 10 08
mptscsih: ioc0:  set_dvflags: id=4 lun=0 negoNvram=0 cmd=1a
NEED_DV set for visible disk id 4
mptscsih: ioc0:  set_dvflags: id=4 lun=0 negoNvram=0 cmd=1a
NEED_DV set for visible disk id 4
SCSI device sda: drive cache: write back w/ FUA
 sda:<5>mptscsih: ioc0:  set_dvflags: id=4 lun=0 negoNvram=0 cmd=28
 sda1
sd 0:0:4:0: Attached scsi disk sda
mptscsih: ioc0:  set_dvflags: id=4 lun=0 negoNvram=0 cmd=a0
  00080004 0101400c 000e0023 00450000 00000000 00000020 00000000 00000000
Reply ha=0 id=4 lun=0:
IOCStatus=0045h SCSIState=00h SCSIStatus=00h
resid=4064 bufflen=4096 xfer_cnt=32
  sc->underflow={report ERR if < 00h bytes xfer'd}
  ActBytesXferd=20h
  sc->result is 00000000h
mptscsih: ioc0:  mptscsih_slave_alloc target=4 lun=1 pTarget=ffff81003ff84580 num_luns=2
mptscsih: ioc0:  set_dvflags: id=4 lun=1 negoNvram=0 cmd=12
mptscsih: ioc0:  set_dvflags: id=4 lun=1 negoNvram=0 cmd=12
  Vendor: nStor     Model: NexStorWahooSATA  Rev:     
  Type:   Direct-Access                      ANSI SCSI revision: 03
mptscsih: ioc0: device @ ffff81003fd14800, id=4, LUN=1, channel=0
mptscsih: ioc0: sdtr 1 wdtr 1 ppr 1 inq length=144
mptscsih: ioc0: initTarget bus=0 id=4 lun=1 hd=ffff81003f33e518
mptscsih: ioc0: Queue depth=64, tflags=1b
mptscsih: ioc0: negoFlags=0, maxOffset=7f, SyncFactor=8
mptscsih: ioc0: tagged 1, simple 1, ordered 0
mptscsih: ioc0:  set_dvflags: id=4 lun=1 negoNvram=0 cmd=0
  00080004 01014006 000e0026 00000102 00000000 00000000 00000012 00000000
Reply ha=0 id=4 lun=1:
IOCStatus=0000h SCSIState=01h SCSIStatus=02h
resid=0 bufflen=0 xfer_cnt=0
  sc->result is 00000002h
mptscsih: ioc0:  set_dvflags: id=4 lun=1 negoNvram=0 cmd=0
mptscsih: ioc0:  set_dvflags: id=4 lun=1 negoNvram=0 cmd=25
SCSI device sdb: 154349568 512-byte hdwr sectors (79027 MB)
mptscsih: ioc0:  set_dvflags: id=4 lun=1 negoNvram=0 cmd=1a
sdb: Write Protect is off
sdb: Mode Sense: a7 00 10 08
mptscsih: ioc0:  set_dvflags: id=4 lun=1 negoNvram=0 cmd=1a
mptscsih: ioc0:  set_dvflags: id=4 lun=1 negoNvram=0 cmd=1a
SCSI device sdb: drive cache: write back w/ FUA
mptscsih: ioc0:  set_dvflags: id=4 lun=1 negoNvram=0 cmd=0
mptscsih: ioc0:  set_dvflags: id=4 lun=1 negoNvram=0 cmd=25
SCSI device sdb: 154349568 512-byte hdwr sectors (79027 MB)
mptscsih: ioc0:  set_dvflags: id=4 lun=1 negoNvram=0 cmd=1a
sdb: Write Protect is off
sdb: Mode Sense: a7 00 10 08
mptscsih: ioc0:  set_dvflags: id=4 lun=1 negoNvram=0 cmd=1a
mptscsih: ioc0:  set_dvflags: id=4 lun=1 negoNvram=0 cmd=1a
SCSI device sdb: drive cache: write back w/ FUA
 sdb:<5>mptscsih: ioc0:  set_dvflags: id=4 lun=1 negoNvram=0 cmd=28
 sdb1
sd 0:0:4:1: Attached scsi disk sdb
mptscsih: ioc0:  mptscsih_slave_alloc target=4 lun=2 pTarget=ffff81003ff84580 num_luns=3
mptscsih: ioc0:  set_dvflags: id=4 lun=2 negoNvram=0 cmd=12
mptscsih: ioc0:  set_dvflags: id=4 lun=2 negoNvram=0 cmd=12
  Vendor: nStor     Model: NexStorWahooSATA  Rev:     
  Type:   Processor                          ANSI SCSI revision: 03
mptscsih: ioc0: device @ ffff81003f262000, id=4, LUN=2, channel=0
mptscsih: ioc0: sdtr 1 wdtr 1 ppr 1 inq length=144
mptscsih: ioc0: initTarget bus=0 id=4 lun=2 hd=ffff81003f33e518
mptscsih: ioc0: writeIOCPage4: MaxSEP=1 ActiveSEP=1 id=4 bus=0
mptscsih: ioc0: Queue depth=64, tflags=3b
  04060002 00000000 000e0034 00000000 00000000 11040300
mptscsih: ioc0: negoFlags=0, maxOffset=7f, SyncFactor=8
mptscsih: ioc0: tagged 1, simple 1, ordered 0
mptscsih: ioc0:  mptscsih_slave_alloc target=5 lun=0 pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_alloc target=5 lun=0 pTarget=ffff81003ff84280 num_luns=1
mptscsih: ioc0:  set_dvflags: id=5 lun=0 negoNvram=0 cmd=12
  00080005 01014006 000e0035 00430000 00000000 00000000 00000000 00000000
Reply ha=0 id=5 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc0:  mptscsih_slave_destroy target=5 lun=0 type=0 pTarget=ffff81003ff84280
mptscsih: search_running target 5 lun 0 max 222
mptscsih: search_running target 5 lun 0 completed
mptscsih: ioc0:  mptscsih_slave_destroy target=5 lun=0 freeing pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_destroy target=5 lun=0 pTarget=ffff81003ff84280 completed
mptscsih: ioc0:  mptscsih_slave_alloc target=6 lun=0 pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_alloc target=6 lun=0 pTarget=ffff81003ff84280 num_luns=1
mptscsih: ioc0:  set_dvflags: id=6 lun=0 negoNvram=0 cmd=12
mptscsih: ioc0: DV Started: bus=0 id=4 dv @ ffff810037f49d98
mptscsih: ioc0: Getting NVRAM:  id=4 width=1 factor=8 offset=7f negoFlags=0
mptscsih: ioc0: DV: Start Basic test on id=4
mptscsih: ioc0: Setting Min: Setting Min: id=4 width=0 factor=ff offset=0 negoFlags=0 request=ff00 config=0
id=4 width=0 factor=ff offset=0 request=ff00 config=0 negoFlags=0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
  04060002 00000000 000f0037 00000000 00000000 04010405
mptbase: ioc0: config_complete (mf=ffff81003ec83ca0,mr=ffff81003ec80820)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptscsih: ioc0: Sending Command 0x12 for (0:4:0)
  00080006 01014006 000e0036 00430000 00000000 00000000 00000000 00000000
Reply ha=0 id=6 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc0: ScanDvComplete (mf=ffff81003ec83d00,mr=0000000000000000,idx=56)
mptscsih: ioc0: Sending Command 0x12 for (0:4:0)
mptscsih: ioc0:  mptscsih_slave_destroy target=6 lun=0 type=0 pTarget=ffff81003ff84280
mptscsih: search_running target 6 lun 0 max 222
mptscsih: search_running target 6 lun 0 completed
mptscsih: ioc0:  mptscsih_slave_destroy target=6 lun=0 freeing pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_destroy target=6 lun=0 pTarget=ffff81003ff84280 completed
mptscsih: ioc0:  mptscsih_slave_alloc target=8 lun=0 pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_alloc target=8 lun=0 pTarget=ffff81003ff84280 num_luns=1
mptscsih: ioc0: ScanDvComplete (mf=ffff81003ec83d60,mr=0000000000000000,idx=57)
mptscsih: ioc0: Setting Max: Setting Max: id=4 width=1 factor=8 offset=7f negoFlags=0 request=207f0807 config=0
id=4 width=1 factor=8 offset=7f negoFlags=0 request=207f0807 configuration=0
mptbase: ioc0: Sending Config request type 4, page 1 and action 2
mptscsih: ioc0:  set_dvflags: id=8 lun=0 negoNvram=0 cmd=12
  04060002 00000000 000f003a 00000000 00000000 04010405
mptbase: ioc0: config_complete (mf=ffff81003ec83dc0,mr=ffff81003ec808c0)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptscsih: ioc0: Sending Command 0x12 for (0:4:0)
  00080008 01014006 000e003b 00430000 00000000 00000000 00000000 00000000
Reply ha=0 id=8 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc0:  mptscsih_slave_destroy target=8 lun=0 type=0 pTarget=ffff81003ff84280
mptscsih: search_running target 8 lun 0 max 222
mptscsih: search_running target 8 lun 0 completed
mptscsih: ioc0:  mptscsih_slave_destroy target=8 lun=0 freeing pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_destroy target=8 lun=0 pTarget=ffff81003ff84280 completed
mptscsih: ioc0:  mptscsih_slave_alloc target=9 lun=0 pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_alloc target=9 lun=0 pTarget=ffff81003ff84280 num_luns=1
mptscsih: ioc0: ScanDvComplete (mf=ffff81003ec83e80,mr=0000000000000000,idx=60)
mptbase: ioc0: Sending Config request type 4, page 0 and action 1
mptscsih: ioc0:  set_dvflags: id=9 lun=0 negoNvram=0 cmd=12
  04060001 00000000 000f003d 00000000 00000000 04000304
mptbase: ioc0: config_complete (mf=ffff81003ec83ee0,mr=ffff81003ec80960)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptscsih: ioc0: Updating with SDP0 Data: id=4 width=1 factor=8 offset=7f negoFlags=0
mptscsih: ioc0: DV:Inquiry compared id=4, calling initTarget
mptscsih: ioc0: initTarget bus=0 id=4 lun=0 hd=ffff81003f33e518
mptscsih: ioc0: DV: Basic test on id=4 completed OK.
mptscsih: ioc0: DV: bus, id, lun (0, 4, 0) PortFlags=0
mptscsih: ioc0: Sending Command 0x0 for (0:4:0)
  00080009 01014006 000e003e 00430000 00000000 00000000 00000000 00000000
Reply ha=0 id=9 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc0: ScanDvComplete (mf=ffff81003ec83fa0,mr=0000000000000000,idx=63)
mptscsih: ioc0: Sending Command 0x3c for (0:4:0)
mptscsih: ioc0:  mptscsih_slave_destroy target=9 lun=0 type=0 pTarget=ffff81003ff84280
mptscsih: search_running target 9 lun 0 max 222
mptscsih: search_running target 9 lun 0 completed
mptscsih: ioc0: ScanDvComplete (mf=ffff81003ec84000,mr=0000000000000000,idx=64)
mptscsih: ioc0:  mptscsih_slave_destroy target=9 lun=0 freeing pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_destroy target=9 lun=0 pTarget=ffff81003ff84280 completed
ReadBuffer Comp Code 0  buff: 0 0 10 0
mptscsih: ioc0: Sending Command 0x3c for (0:4:0)
mptscsih: ioc0:  mptscsih_slave_alloc target=10 lun=0 pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_alloc target=10 lun=0 pTarget=ffff81003ff84280 num_luns=1
mptscsih: ioc0: ScanDvComplete (mf=ffff81003ec84060,mr=0000000000000000,idx=65)
mptscsih: ioc0:  set_dvflags: id=10 lun=0 negoNvram=0 cmd=12
ReadBuffer Comp Code 0  buff: 0 0 10 0
mptscsih: ioc0: Echo Buffer Capacity 4096
Pattern 0
mptscsih: ioc0: Sending Command 0x16 for (0:4:0)
  0008000a 01014006 000e0042 00430000 00000000 00000000 00000000 00000000
Reply ha=0 id=10 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc0: ScanDvComplete (mf=ffff81003ec84120,mr=0000000000000000,idx=67)
mptscsih: ioc0: Sending Command 0x3b for (0:4:0)
mptscsih: ioc0:  mptscsih_slave_destroy target=10 lun=0 type=0 pTarget=ffff81003ff84280
mptscsih: search_running target 10 lun 0 max 222
mptscsih: search_running target 10 lun 0 completed
mptscsih: ioc0:  mptscsih_slave_destroy target=10 lun=0 freeing pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_destroy target=10 lun=0 pTarget=ffff81003ff84280 completed
mptscsih: ioc0: ScanDvComplete (mf=ffff81003ec84180,mr=0000000000000000,idx=68)
mptscsih: ioc0: Sending Command 0x3c for (0:4:0)
mptscsih: ioc0:  mptscsih_slave_alloc target=11 lun=0 pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_alloc target=11 lun=0 pTarget=ffff81003ff84280 num_luns=1
mptscsih: ioc0:  set_dvflags: id=11 lun=0 negoNvram=0 cmd=12
mptscsih: ioc0: ScanDvComplete (mf=ffff81003ec841e0,mr=0000000000000000,idx=69)
Pattern 1
mptscsih: ioc0: Sending Command 0x3b for (0:4:0)
  0008000b 01014006 000e0046 00430000 00000000 00000000 00000000 00000000
Reply ha=0 id=11 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc0: ScanDvComplete (mf=ffff81003ec842a0,mr=0000000000000000,idx=71)
mptscsih: ioc0: Sending Command 0x3c for (0:4:0)
mptscsih: ioc0:  mptscsih_slave_destroy target=11 lun=0 type=0 pTarget=ffff81003ff84280
mptscsih: search_running target 11 lun 0 max 222
mptscsih: search_running target 11 lun 0 completed
mptscsih: ioc0: ScanDvComplete (mf=ffff81003ec84300,mr=0000000000000000,idx=72)
mptscsih: ioc0:  mptscsih_slave_destroy target=11 lun=0 freeing pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_destroy target=11 lun=0 pTarget=ffff81003ff84280 completed
Pattern 2
mptscsih: ioc0: Sending Command 0x3b for (0:4:0)
mptscsih: ioc0:  mptscsih_slave_alloc target=12 lun=0 pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_alloc target=12 lun=0 pTarget=ffff81003ff84280 num_luns=1
mptscsih: ioc0:  set_dvflags: id=12 lun=0 negoNvram=0 cmd=12
mptscsih: ioc0: ScanDvComplete (mf=ffff81003ec84360,mr=0000000000000000,idx=73)
mptscsih: ioc0: Sending Command 0x3c for (0:4:0)
  0008000c 01014006 000e004a 00430000 00000000 00000000 00000000 00000000
Reply ha=0 id=12 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc0: ScanDvComplete (mf=ffff81003ec84420,mr=0000000000000000,idx=75)
Pattern 3
mptscsih: ioc0:  mptscsih_slave_destroy target=12 lun=0 type=0 pTarget=ffff81003ff84280
mptscsih: ioc0: Sending Command 0x3b for (0:4:0)
mptscsih: search_running target 12 lun 0 max 222
mptscsih: search_running target 12 lun 0 completed
mptscsih: ioc0:  mptscsih_slave_destroy target=12 lun=0 freeing pTarget=ffff81003ff84280
mptscsih: ioc0: ScanDvComplete (mf=ffff81003ec84480,mr=0000000000000000,idx=76)
mptscsih: ioc0: Sending Command 0x3c for (0:4:0)
mptscsih: ioc0: ScanDvComplete (mf=ffff81003ec844e0,mr=0000000000000000,idx=77)
mptscsih: ioc0: Sending Command 0x17 for (0:4:0)
mptscsih: ioc0:  mptscsih_slave_destroy target=12 lun=0 pTarget=ffff81003ff84280 completed
mptscsih: ioc0: ScanDvComplete (mf=ffff81003ec84540,mr=0000000000000000,idx=78)
mptscsih: ioc0: Saving to Target structure: id=4 width=1 factor=8 offset=127 negoFlags=0
mptscsih: ioc0: DV Done id=4
mptscsih: ioc0:  mptscsih_slave_alloc target=13 lun=0 pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_alloc target=13 lun=0 pTarget=ffff81003ff84280 num_luns=1
mptscsih: ioc0:  set_dvflags: id=13 lun=0 negoNvram=0 cmd=12
  0008000d 01014006 000e004f 00430000 00000000 00000000 00000000 00000000
Reply ha=0 id=13 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc0:  mptscsih_slave_destroy target=13 lun=0 type=0 pTarget=ffff81003ff84280
mptscsih: search_running target 13 lun 0 max 222
mptscsih: search_running target 13 lun 0 completed
mptscsih: ioc0:  mptscsih_slave_destroy target=13 lun=0 freeing pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_destroy target=13 lun=0 pTarget=ffff81003ff84280 completed
mptscsih: ioc0:  mptscsih_slave_alloc target=14 lun=0 pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_alloc target=14 lun=0 pTarget=ffff81003ff84280 num_luns=1
mptscsih: ioc0:  set_dvflags: id=14 lun=0 negoNvram=0 cmd=12
  0008000e 01014006 000e0050 00430000 00000000 00000000 00000000 00000000
Reply ha=0 id=14 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc0:  mptscsih_slave_destroy target=14 lun=0 type=0 pTarget=ffff81003ff84280
mptscsih: search_running target 14 lun 0 max 222
mptscsih: search_running target 14 lun 0 completed
mptscsih: ioc0:  mptscsih_slave_destroy target=14 lun=0 freeing pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_destroy target=14 lun=0 pTarget=ffff81003ff84280 completed
mptscsih: ioc0:  mptscsih_slave_alloc target=15 lun=0 pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_alloc target=15 lun=0 pTarget=ffff81003ff84280 num_luns=1
mptscsih: ioc0:  set_dvflags: id=15 lun=0 negoNvram=0 cmd=12
  0008000f 01014006 000e0051 00430000 00000000 00000000 00000000 00000000
Reply ha=0 id=15 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc0:  mptscsih_slave_destroy target=15 lun=0 type=0 pTarget=ffff81003ff84280
mptscsih: search_running target 15 lun 0 max 222
mptscsih: search_running target 15 lun 0 completed
mptscsih: ioc0:  mptscsih_slave_destroy target=15 lun=0 freeing pTarget=ffff81003ff84280
mptscsih: ioc0:  mptscsih_slave_destroy target=15 lun=0 pTarget=ffff81003ff84280 completed
GSI 19 sharing vector 0xC1 and IRQ 19
ACPI: PCI Interrupt 0000:06:03.1[B] -> GSI 25 (level, low) -> IRQ 19
mptbase: mpt_adapter_install
mptbase: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED
mptbase: Using 64 bit consistent mask
mptbase: ii=0 port i/o @ a000, psize=0x100 bytes
mptbase: ii=1 MPT adapter @ fc9e0000, msize=0x20000 bytes
mptbase: mem = ffffc20000080000, mem_phys = fc9e0000
mptbase: facts @ ffff81003fd20bec, pfacts[0] @ ffff81003fd20c3c
mptbase: ioc1 installed at interrupt 19
mptbase: ioc1: PCI device 0000:06:03.1 devfn=6/19, searching for devfn match on 0 or 2
mptbase: FOUND! binding ioc1 <==> ioc0
mptbase: Initiating ioc1 bringup
mptbase::MakeIocReady, ioc1 [raw] state=22000000
mptbase: ioc1: IOC operational unexpected
mptbase: whoinit 0x2 statefault 0 force 0
mptbase: ioc1: Sending IOC reset(0x40)!
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: Sending get IocFacts request req_sz=12 reply_sz=80
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: HandShake request start reqBytes=12, WaitCnt=1
mptbase: ioc1: WaitForDoorbell ACK (count=0)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: Handshake request frame (@ffff81003ec558d8) header
  03000000 00000000 00000000
mptbase: ioc1: HandShake request post done, WaitCnt=1
mptbase: ioc1: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitCnt=1 First handshake reply word=030f0102
mptbase: ioc1: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: Got Handshake reply:
  030f0102 00010e00 00000000 00000000 00000000 00080030 001800ff 04020000 00000000 000100de 00000000 01100080 0000f800 bfb92bb0 01032700
mptbase: ioc1: WaitForDoorbell REPLY WaitCnt=1 (sz=15)
mptbase: ioc1: HandShake reply count=15
mptbase: ioc1: NB_for_64_byte_frame=2 NBShiftFactor=5 BlockSize=8
mptbase: ioc1: reply_sz=80 mpt_reply_depth=128 ReplyQueueDepth=255 reply_depth=128
mptbase: ioc1: req_sz=96 mpt_can_queue=128 GlobalCredits=222 req_depth=222
mptbase: ioc1: Sending get PortFacts(0) request
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: HandShake request start reqBytes=12, WaitCnt=1
mptbase: ioc1: WaitForDoorbell ACK (count=0)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: Handshake request frame (@ffff81003ec558c8) header
  05000000 00000000 00000000
mptbase: ioc1: HandShake request post done, WaitCnt=1
mptbase: ioc1: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitCnt=1 First handshake reply word=050a0000
mptbase: ioc1: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: Got Handshake reply:
  050a0000 00000000 00000000 00000000 00000000 00100100 00080007 00000001 00000000 00000000
mptbase: ioc1: WaitForDoorbell REPLY WaitCnt=1 (sz=10)
mptbase: ioc1: HandShake reply count=10
ioc1: 53C1030: Capabilities={Initiator}
mptbase: ioc1 dma_addr_t size=8 u64 size=8
mptbase: ioc1 req_sz=96 SGE_size=12 scale=8 num_sge=11 numSGE=329 MaxChainDepth=48 maxSGEs=340 mpt_sg_tablesize=40
mptbase: ioc1 numSGE=29 now
mptbase: ioc1 Now num_chain=6
mptbase: ioc1 req_depth=222 max num_chain=1332 mpt_chain_alloc_percent=100 total_num_chain=1332
mptbase: ioc1 ReplyBuffer sz=80 bytes, ReplyDepth=128
mptbase: ioc1 Total ReplyBuffer sz=10240[2800] bytes
mptbase: ioc1 RequestBuffer sz=96 bytes, RequestDepth=222
mptbase: ioc1 Total RequestBuffer sz=21312[5340] bytes
mptbase: ioc1 Total ChainBuffer sz=127872[1f380] bytes total_num_chain=1332
mptbase: ioc1 Total ioc alloc size=159424[26ec0] bytes
mptbase: ioc1 Total ioc alloc @ ffff81003ecc0000[000000003ecc0000]
mptbase: ioc1 ReplyBuffers @ ffff81003ecc0000[000000003ecc0000]
mptbase: ioc1 RequestBuffers @ ffff81003ecc2800[000000003ecc2800]
mptbase :ioc1 ChainBuffers @ ffff81003ecc7b40(000000003ecc7b40)
mptbase: ioc1 SenseBuffers @ ffff81003fb2c000[000000003fb2c000]
mptbase: ioc1 ReqToChain alloc  @ ffff81003fd1e400, sz=888 bytes
mptbase: ioc1 RequestNB alloc  @ ffff81003f267800, sz=888 bytes
mptbase: ioc1 ChainToChain alloc @ ffff810002358000, sz=5328 bytes
mptbase: ioc1: upload_fw 0 facts.Flags=0
mptbase: ioc1: ioc_init.MaxDevice=16
mptbase: ioc1: facts.MsgVersion=102
mptbase: ioc1: Sending IOCInit (req @ ffff81003ec55868)
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: HandShake request start reqBytes=44, WaitCnt=1
mptbase: ioc1: WaitForDoorbell ACK (count=0)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: Handshake request frame (@ffff81003ec55868) header
  02000004 00011000 00000000
mptbase: ioc1: HandShake request post done, WaitCnt=1
mptbase: ioc1: WaitForDoorbell INT (cnt=0) howlong=10
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitCnt=1 First handshake reply word=02050004
mptbase: ioc1: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: Got Handshake reply:
  02050004 00011000 00000000 00000000 00000000
mptbase: ioc1: WaitForDoorbell REPLY WaitCnt=1 (sz=5)
mptbase: ioc1: HandShake reply count=5
mptbase: ioc1: Sending PortEnable (req @ ffff81003ec55868)
mptbase: ioc1: Sending Port(0)Enable (req @ ffff81003ec558d8)
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: HandShake request start reqBytes=12, WaitCnt=1
mptbase: ioc1: WaitForDoorbell ACK (count=0)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: Handshake request frame (@ffff81003ec558d8) header
  06000000 00000000 00000000
mptbase: ioc1: HandShake request post done, WaitCnt=1
mptbase: ioc1: WaitForDoorbell INT (cnt=0) howlong=300
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitCnt=1 First handshake reply word=06050000
mptbase: ioc1: WaitForDoorbell INT (cnt=0) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: Got Handshake reply:
  06050000 00000000 00000000 00000000 00000000
mptbase: ioc1: WaitForDoorbell REPLY WaitCnt=1 (sz=5)
mptbase: ioc1: HandShake reply count=5
mptbase: ioc1: INFO - Wait IOC_OPERATIONAL state (cnt=0)
mptbase: alt-ioc0 reply irq re-enabled
mptbase: ioc1: Sending EventNotification (1) request ffff81003ecc2800
mptbase: ioc1: SCSI device NVRAM settings @ ffff81003f266e40, sz=64
  07080001 80000000 000f0000 00000000 00000000 0000000a 00000000 00000001
mptbase: ioc1: WARNING - MPT Event=0Ah (Events ON) detected!
mptbase: Event data:
 00000001
mptbase: ioc1: Routing Event to event handler #14
mptscsih: ioc1: MPT event (=0Ah) routed to SCSI host driver!
mptbase: ioc1: Sending Config request type 3, page 0 and action 0
  04060000 00000000 000f0001 00000000 00000000 03000302
mptbase: ioc1: config_complete (mf=ffff81003ecc2860,mr=ffff81003ecc0050)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc1: Sending Config request type 3, page 0 and action 1
  04060001 00000000 000f0002 00000000 00000000 03000302
mptbase: ioc1: config_complete (mf=ffff81003ecc28c0,mr=ffff81003ecc00a0)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc1: Sending Config request type 3, page 2 and action 0
  04060000 00000000 000f0003 00000000 00000000 23021302
mptbase: ioc1: config_complete (mf=ffff81003ecc2920,mr=ffff81003ecc00f0)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc1: Sending Config request type 3, page 2 and action 6
  04060006 00000000 000f0004 00000000 00000000 03021302
mptbase: ioc1: config_complete (mf=ffff81003ecc2980,mr=ffff81003ecc0140)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc1: Sending Config request type 4, page 1 and action 0
  04060000 00000000 000f0005 00000000 00000000 14010405
mptbase: ioc1: config_complete (mf=ffff81003ecc29e0,mr=ffff81003ecc0190)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc1: Sending Config request type 4, page 0 and action 0
  04060000 00000000 000f0006 00000000 00000000 04000304
mptbase: ioc1: config_complete (mf=ffff81003ecc2a40,mr=ffff81003ecc01e0)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc1: Headers: 0: version 4 length 3
mptbase: ioc1: Headers: 1: version 5 length 4
mptbase: ioc1: Sending Config request type 1, page 2 and action 0
  04060000 00000000 000f0007 00000000 00000000 01020302
mptbase: ioc1: config_complete (mf=ffff81003ecc2aa0,mr=ffff81003ecc0230)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc1: Sending Config request type 1, page 2 and action 1
  04060001 00000000 000f0008 00000000 00000000 01020302
mptbase: ioc1: config_complete (mf=ffff81003ecc2b00,mr=ffff81003ecc0280)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc1: Sending Config request type 1, page 1 and action 0
  04060000 00000000 000f0009 00000000 00000000 21010401
mptbase: ioc1: config_complete (mf=ffff81003ecc2b60,mr=ffff81003ecc02d0)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc1: Sending Config request type 1, page 1 and action 1
  04060001 00000000 000f000a 00000000 00000000 01010401
mptbase: ioc1: config_complete (mf=ffff81003ecc2bc0,mr=ffff81003ecc0320)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc1: Coalescing Enabled Timeout = 10
mptbase: ioc1: Sending Config request type 1, page 4 and action 0
  04060000 00000000 000f000b 00000000 00000000 11040300
mptbase: ioc1: config_complete (mf=ffff81003ecc2c20,mr=ffff81003ecc0370)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc1: Sending Config request type 1, page 4 and action 1
  04060001 00000000 000f000c 00000000 00000000 01040300
mptbase: ioc1: config_complete (mf=ffff81003ecc2c80,mr=ffff81003ecc03c0)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc1: Sending Config request type 0, page 2 and action 0
  04060000 00000000 000f000d 00000000 00000000 20020700
mptbase: ioc1: config_complete (mf=ffff81003ecc2ce0,mr=ffff81003ecc0410)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptbase: ioc1: Sending Config request type 0, page 2 and action 1
  04060001 00000000 000f000e 00000000 00000000 00020700
mptbase: ioc1: config_complete (mf=ffff81003ecc2d40,mr=ffff81003ecc0460)
  IOCStatus=0000h, IOCLogInfo=00000000h
mptspi: ioc1: mpt_can_queue=128 req_depth=222 can_queue=128
mptspi: ioc1: ScsiLookup @ ffff81003f3ac000, sz=1776
  Targets @ ffff81003f3b22c0, sz=128
scsi1 : ioc1: LSI53C1030, FwRev=01032700h, Ports=1, MaxQ=222, IRQ=19
mptscsih: ioc1: TMHandler Entered!
mptscsih: ioc1: IssueTaskMgmt request @ ffff81003ecc2da0
mptscsih: ioc1: IssueTaskMgmt: ctx2abort (0x00000000) type=4
TM_REQUEST:
01000000 04000400 000d000f 00000000 00000000 00000000 00000000 00000000 
00000000 00000000 00000000 00000000 00000000 
mptbase: ioc1: WaitForDoorbell INT (cnt=1) howlong=5
mptbase: ioc1: mpt_send_handshake_request start, WaitCnt=1
mptbase: ioc1: WaitForDoorbell ACK (count=0)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell ACK (count=1)
mptbase: ioc1: WaitForDoorbell INT (cnt=0) howlong=10
  01060000 04000400 000d000f 00000000 00000000 00000000
mptscsih: ioc1: WARNING - TaskMgmt completed (mf=ffff81003ecc2da0,mr=ffff81003ecc04b0)
mptscsih: ioc1: WARNING -   TaskType = 4, TerminationCount=0
TM_REPLY MessageLength=6:
 01060000 04000400 000d000f 00000000 00000000 00000000
mptscsih: ioc1: WARNING -   SCSI TaskMgmt (4) IOCStatus=0000 IOCLogInfo=00000000
mptscsih: ioc1: WARNING -  TaskMgmt SUCCESS
mptscsih: ioc1: Issue of TaskMgmt Successful!
mptscsih: ioc1: TMHandler rc = 0!
mptscsih: ioc1:  mptscsih_slave_alloc target=0 lun=0 pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_alloc target=0 lun=0 pTarget=ffff81003f2b20c0 num_luns=1
mptscsih: ioc1:  set_dvflags: id=0 lun=0 negoNvram=0 cmd=12
  00080000 01014006 000e0010 00430000 00000000 00000000 00000000 00000000
Reply ha=1 id=0 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc1:  mptscsih_slave_destroy target=0 lun=0 type=0 pTarget=ffff81003f2b20c0
mptscsih: search_running target 0 lun 0 max 222
mptscsih: search_running target 0 lun 0 completed
mptscsih: ioc1:  mptscsih_slave_destroy target=0 lun=0 freeing pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_destroy target=0 lun=0 pTarget=ffff81003f2b20c0 completed
mptscsih: ioc1:  mptscsih_slave_alloc target=1 lun=0 pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_alloc target=1 lun=0 pTarget=ffff81003f2b20c0 num_luns=1
mptscsih: ioc1:  set_dvflags: id=1 lun=0 negoNvram=0 cmd=12
  00080001 01014006 000e0011 00430000 00000000 00000000 00000000 00000000
Reply ha=1 id=1 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc1:  mptscsih_slave_destroy target=1 lun=0 type=0 pTarget=ffff81003f2b20c0
mptscsih: search_running target 1 lun 0 max 222
mptscsih: search_running target 1 lun 0 completed
mptscsih: ioc1:  mptscsih_slave_destroy target=1 lun=0 freeing pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_destroy target=1 lun=0 pTarget=ffff81003f2b20c0 completed
mptscsih: ioc1:  mptscsih_slave_alloc target=2 lun=0 pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_alloc target=2 lun=0 pTarget=ffff81003f2b20c0 num_luns=1
mptscsih: ioc1:  set_dvflags: id=2 lun=0 negoNvram=0 cmd=12
  00080002 01014006 000e0012 00430000 00000000 00000000 00000000 00000000
Reply ha=1 id=2 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc1:  mptscsih_slave_destroy target=2 lun=0 type=0 pTarget=ffff81003f2b20c0
mptscsih: search_running target 2 lun 0 max 222
mptscsih: search_running target 2 lun 0 completed
mptscsih: ioc1:  mptscsih_slave_destroy target=2 lun=0 freeing pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_destroy target=2 lun=0 pTarget=ffff81003f2b20c0 completed
mptscsih: ioc1:  mptscsih_slave_alloc target=3 lun=0 pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_alloc target=3 lun=0 pTarget=ffff81003f2b20c0 num_luns=1
mptscsih: ioc1:  set_dvflags: id=3 lun=0 negoNvram=0 cmd=12
  00080003 01014006 000e0013 00430000 00000000 00000000 00000000 00000000
Reply ha=1 id=3 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc1:  mptscsih_slave_destroy target=3 lun=0 type=0 pTarget=ffff81003f2b20c0
mptscsih: search_running target 3 lun 0 max 222
mptscsih: search_running target 3 lun 0 completed
mptscsih: ioc1:  mptscsih_slave_destroy target=3 lun=0 freeing pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_destroy target=3 lun=0 pTarget=ffff81003f2b20c0 completed
mptscsih: ioc1:  mptscsih_slave_alloc target=4 lun=0 pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_alloc target=4 lun=0 pTarget=ffff81003f2b20c0 num_luns=1
mptscsih: ioc1:  set_dvflags: id=4 lun=0 negoNvram=0 cmd=12
  00080004 01014006 000e0014 00430000 00000000 00000000 00000000 00000000
Reply ha=1 id=4 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc1:  mptscsih_slave_destroy target=4 lun=0 type=0 pTarget=ffff81003f2b20c0
mptscsih: search_running target 4 lun 0 max 222
mptscsih: search_running target 4 lun 0 completed
mptscsih: ioc1:  mptscsih_slave_destroy target=4 lun=0 freeing pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_destroy target=4 lun=0 pTarget=ffff81003f2b20c0 completed
mptscsih: ioc1:  mptscsih_slave_alloc target=5 lun=0 pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_alloc target=5 lun=0 pTarget=ffff81003f2b20c0 num_luns=1
mptscsih: ioc1:  set_dvflags: id=5 lun=0 negoNvram=0 cmd=12
  00080005 01014006 000e0015 00430000 00000000 00000000 00000000 00000000
Reply ha=1 id=5 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc1:  mptscsih_slave_destroy target=5 lun=0 type=0 pTarget=ffff81003f2b20c0
mptscsih: search_running target 5 lun 0 max 222
mptscsih: search_running target 5 lun 0 completed
mptscsih: ioc1:  mptscsih_slave_destroy target=5 lun=0 freeing pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_destroy target=5 lun=0 pTarget=ffff81003f2b20c0 completed
mptscsih: ioc1:  mptscsih_slave_alloc target=6 lun=0 pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_alloc target=6 lun=0 pTarget=ffff81003f2b20c0 num_luns=1
mptscsih: ioc1:  set_dvflags: id=6 lun=0 negoNvram=0 cmd=12
  00080006 01014006 000e0016 00430000 00000000 00000000 00000000 00000000
Reply ha=1 id=6 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc1:  mptscsih_slave_destroy target=6 lun=0 type=0 pTarget=ffff81003f2b20c0
mptscsih: search_running target 6 lun 0 max 222
mptscsih: search_running target 6 lun 0 completed
mptscsih: ioc1:  mptscsih_slave_destroy target=6 lun=0 freeing pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_destroy target=6 lun=0 pTarget=ffff81003f2b20c0 completed
mptscsih: ioc1:  mptscsih_slave_alloc target=8 lun=0 pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_alloc target=8 lun=0 pTarget=ffff81003f2b20c0 num_luns=1
mptscsih: ioc1:  set_dvflags: id=8 lun=0 negoNvram=0 cmd=12
  00080008 01014006 000e0017 00430000 00000000 00000000 00000000 00000000
Reply ha=1 id=8 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc1:  mptscsih_slave_destroy target=8 lun=0 type=0 pTarget=ffff81003f2b20c0
mptscsih: search_running target 8 lun 0 max 222
mptscsih: search_running target 8 lun 0 completed
mptscsih: ioc1:  mptscsih_slave_destroy target=8 lun=0 freeing pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_destroy target=8 lun=0 pTarget=ffff81003f2b20c0 completed
mptscsih: ioc1:  mptscsih_slave_alloc target=9 lun=0 pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_alloc target=9 lun=0 pTarget=ffff81003f2b20c0 num_luns=1
mptscsih: ioc1:  set_dvflags: id=9 lun=0 negoNvram=0 cmd=12
  00080009 01014006 000e0018 00430000 00000000 00000000 00000000 00000000
Reply ha=1 id=9 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc1:  mptscsih_slave_destroy target=9 lun=0 type=0 pTarget=ffff81003f2b20c0
mptscsih: search_running target 9 lun 0 max 222
mptscsih: search_running target 9 lun 0 completed
mptscsih: ioc1:  mptscsih_slave_destroy target=9 lun=0 freeing pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_destroy target=9 lun=0 pTarget=ffff81003f2b20c0 completed
mptscsih: ioc1:  mptscsih_slave_alloc target=10 lun=0 pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_alloc target=10 lun=0 pTarget=ffff81003f2b20c0 num_luns=1
mptscsih: ioc1:  set_dvflags: id=10 lun=0 negoNvram=0 cmd=12
  0008000a 01014006 000e0019 00430000 00000000 00000000 00000000 00000000
Reply ha=1 id=10 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc1:  mptscsih_slave_destroy target=10 lun=0 type=0 pTarget=ffff81003f2b20c0
mptscsih: search_running target 10 lun 0 max 222
mptscsih: search_running target 10 lun 0 completed
mptscsih: ioc1:  mptscsih_slave_destroy target=10 lun=0 freeing pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_destroy target=10 lun=0 pTarget=ffff81003f2b20c0 completed
mptscsih: ioc1:  mptscsih_slave_alloc target=11 lun=0 pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_alloc target=11 lun=0 pTarget=ffff81003f2b20c0 num_luns=1
mptscsih: ioc1:  set_dvflags: id=11 lun=0 negoNvram=0 cmd=12
  0008000b 01014006 000e001a 00430000 00000000 00000000 00000000 00000000
Reply ha=1 id=11 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc1:  mptscsih_slave_destroy target=11 lun=0 type=0 pTarget=ffff81003f2b20c0
mptscsih: search_running target 11 lun 0 max 222
mptscsih: search_running target 11 lun 0 completed
mptscsih: ioc1:  mptscsih_slave_destroy target=11 lun=0 freeing pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_destroy target=11 lun=0 pTarget=ffff81003f2b20c0 completed
mptscsih: ioc1:  mptscsih_slave_alloc target=12 lun=0 pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_alloc target=12 lun=0 pTarget=ffff81003f2b20c0 num_luns=1
mptscsih: ioc1:  set_dvflags: id=12 lun=0 negoNvram=0 cmd=12
  0008000c 01014006 000e001b 00430000 00000000 00000000 00000000 00000000
Reply ha=1 id=12 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc1:  mptscsih_slave_destroy target=12 lun=0 type=0 pTarget=ffff81003f2b20c0
mptscsih: search_running target 12 lun 0 max 222
mptscsih: search_running target 12 lun 0 completed
mptscsih: ioc1:  mptscsih_slave_destroy target=12 lun=0 freeing pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_destroy target=12 lun=0 pTarget=ffff81003f2b20c0 completed
mptscsih: ioc1:  mptscsih_slave_alloc target=13 lun=0 pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_alloc target=13 lun=0 pTarget=ffff81003f2b20c0 num_luns=1
mptscsih: ioc1:  set_dvflags: id=13 lun=0 negoNvram=0 cmd=12
  0008000d 01014006 000e001c 00430000 00000000 00000000 00000000 00000000
Reply ha=1 id=13 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc1:  mptscsih_slave_destroy target=13 lun=0 type=0 pTarget=ffff81003f2b20c0
mptscsih: search_running target 13 lun 0 max 222
mptscsih: search_running target 13 lun 0 completed
mptscsih: ioc1:  mptscsih_slave_destroy target=13 lun=0 freeing pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_destroy target=13 lun=0 pTarget=ffff81003f2b20c0 completed
mptscsih: ioc1:  mptscsih_slave_alloc target=14 lun=0 pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_alloc target=14 lun=0 pTarget=ffff81003f2b20c0 num_luns=1
mptscsih: ioc1:  set_dvflags: id=14 lun=0 negoNvram=0 cmd=12
  0008000e 01014006 000e001d 00430000 00000000 00000000 00000000 00000000
Reply ha=1 id=14 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc1:  mptscsih_slave_destroy target=14 lun=0 type=0 pTarget=ffff81003f2b20c0
mptscsih: search_running target 14 lun 0 max 222
mptscsih: search_running target 14 lun 0 completed
mptscsih: ioc1:  mptscsih_slave_destroy target=14 lun=0 freeing pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_destroy target=14 lun=0 pTarget=ffff81003f2b20c0 completed
mptscsih: ioc1:  mptscsih_slave_alloc target=15 lun=0 pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_alloc target=15 lun=0 pTarget=ffff81003f2b20c0 num_luns=1
mptscsih: ioc1:  set_dvflags: id=15 lun=0 negoNvram=0 cmd=12
  0008000f 01014006 000e001e 00430000 00000000 00000000 00000000 00000000
Reply ha=1 id=15 lun=0:
IOCStatus=0043h SCSIState=00h SCSIStatus=00h
resid=36 bufflen=36 xfer_cnt=0
  sc->result is 00010000h
mptscsih: ioc1:  mptscsih_slave_destroy target=15 lun=0 type=0 pTarget=ffff81003f2b20c0
mptscsih: search_running target 15 lun 0 max 222
mptscsih: search_running target 15 lun 0 completed
mptscsih: ioc1:  mptscsih_slave_destroy target=15 lun=0 freeing pTarget=ffff81003f2b20c0
mptscsih: ioc1:  mptscsih_slave_destroy target=15 lun=0 pTarget=ffff81003f2b20c0 completed
libata version 1.20 loaded.
ata_piix 0000:00:1f.2: version 1.05
ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 18 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ata1: SATA max UDMA/133 cmd 0xE800 ctl 0xE482 bmdma 0xE000 irq 17
ata2: SATA max UDMA/133 cmd 0xE400 ctl 0xE082 bmdma 0xE008 irq 17
ata1: dev 0 cfg 49:2f00 82:7c6b 83:7b09 84:4003 85:7c69 86:3a01 87:4003 88:207f
ata1: dev 0 ATA-7, max UDMA/133, 240121728 sectors: LBA
ata1: dev 0 configured for UDMA/133
scsi2 : ata_piix
ATA: abnormal status 0x7F on port 0xE407
scsi3 : ata_piix
  Vendor: ATA       Model: Maxtor 6Y120M0    Rev: YAR5
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdc: 240121728 512-byte hdwr sectors (122942 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: drive cache: write back
SCSI device sdc: 240121728 512-byte hdwr sectors (122942 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: drive cache: write back
 sdc: sdc1 sdc2
sd 2:0:0:0: Attached scsi disk sdc
device-mapper: 4.5.0-ioctl (2005-10-04) initialised: dm-devel@redhat.com
  00080004 0100400a 000e0053 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0058 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=1:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0066 00000008 00000000 00000000 00000028 00001800
Reply ha=0 id=4 lun=1:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=20480 bufflen=20480 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e006a 00000008 00000000 00000000 f0160028 000040e1
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=3584 bufflen=3584 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e006b 00000008 00000000 00000000 f0160028 000040e1
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=3584 bufflen=3584 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e006c 00000008 00000000 00000000 f0160028 000040e1
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=3584 bufflen=3584 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e006d 00000008 00000000 00000000 f0160028 000040e1
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=3584 bufflen=3584 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0074 00000008 00000000 00000000 00000028 00005700
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=20480 bufflen=20480 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e007d 00000008 00000000 00000000 00000028 00001800
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=20480 bufflen=20480 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0088 00000008 00000000 00000000 00000028 00001800
Reply ha=0 id=4 lun=1:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=20480 bufflen=20480 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0091 00000008 00000000 00000000 00000028 00005700
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=20480 bufflen=20480 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e009a 00000008 00000000 00000000 00000028 00001800
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=20480 bufflen=20480 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e00a5 00000008 00000000 00000000 00000028 00001800
Reply ha=0 id=4 lun=1:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=20480 bufflen=20480 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e00ae 00000008 00000000 00000000 00000028 00005700
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=20480 bufflen=20480 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e00b7 00000008 00000000 00000000 00000028 00001800
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=20480 bufflen=20480 xfer_cnt=0
  sc->result is 00020008h
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
GSI 20 sharing vector 0xC9 and IRQ 20
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfebfec00
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
MC: drivers/edac/edac_mc.c version edac_mc  Ver: 2.0.0 May 21 2006
i6300ESB timer: initialized (0xffffc2000001e800). heartbeat=30 sec (nowayout=0)
tolm = 40000, remapbase = ffc000, remaplimit = 0
EDAC MC0: Giving out device to "e752x_edac" E7520: PCI 0000:00:00.0
hw_random: RNG not detected
USB Universal Host Controller Interface driver v2.3
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000e880
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
  00080004 01004006 000e00bb 00000008 00000000 00000000 00000112 000000fe
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=254 bufflen=254 xfer_cnt=0
  sc->result is 00020008h
  00080004 01004006 000e00ba 00450000 00000000 00000008 00000000 00000000
Reply ha=0 id=4 lun=1:
IOCStatus=0045h SCSIState=00h SCSIStatus=00h
resid=246 bufflen=254 xfer_cnt=8
  sc->underflow={report ERR if < 00h bytes xfer'd}
  ActBytesXferd=08h
  sc->result is 00000000h
  00080004 01004006 000e00bc 00450000 00000000 00000010 00000000 00000000
Reply ha=0 id=4 lun=1:
IOCStatus=0045h SCSIState=00h SCSIStatus=00h
resid=238 bufflen=254 xfer_cnt=16
  sc->underflow={report ERR if < 00h bytes xfer'd}
  ActBytesXferd=10h
  sc->result is 00000000h
  00080004 01004006 000e00bd 00450000 00000000 00000008 00000000 00000000
Reply ha=0 id=4 lun=0:
IOCStatus=0045h SCSIState=00h SCSIStatus=00h
resid=246 bufflen=254 xfer_cnt=8
  sc->underflow={report ERR if < 00h bytes xfer'd}
  ActBytesXferd=08h
  sc->result is 00000000h
  00080004 01004006 000e00be 00450000 00000000 00000010 00000000 00000000
Reply ha=0 id=4 lun=0:
IOCStatus=0045h SCSIState=00h SCSIStatus=00h
resid=238 bufflen=254 xfer_cnt=16
  sc->underflow={report ERR if < 00h bytes xfer'd}
  ActBytesXferd=10h
  sc->result is 00000000h
GSI 21 sharing vector 0xD1 and IRQ 21
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 21, io base 0x0000ec00
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
sd 0:0:4:0: Attached scsi generic sg0 type 0
sd 0:0:4:1: Attached scsi generic sg1 type 0
 0:0:4:2: Attached scsi generic sg2 type 3
sd 2:0:0:0: Attached scsi generic sg3 type 0
  00080004 0100400a 000e00d4 00000008 00000000 00000000 f0160028 000040e1
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=3584 bufflen=3584 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e00d5 00000008 00000000 00000000 f0160028 000040e1
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=3584 bufflen=3584 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e00d6 00000008 00000000 00000000 f0160028 000040e1
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=3584 bufflen=3584 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0005 00000008 00000000 00000000 00000028 00009500
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=4608 bufflen=4608 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0006 00000008 00000000 00000000 00000028 00009500
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=4608 bufflen=4608 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0007 00000008 00000000 00000000 00000028 00009e00
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=14848 bufflen=14848 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0008 00000008 00000000 00000000 00000028 00009500
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=4608 bufflen=4608 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e000a 00000008 00000000 00000000 00000028 00009e00
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=14848 bufflen=14848 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e000b 00000008 00000000 00000000 00000028 00009500
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=4608 bufflen=4608 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e000c 00000008 00000000 00000000 00000028 00009e00
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=14848 bufflen=14848 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e000d 00000008 00000000 00000000 00000028 00009500
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=4608 bufflen=4608 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e000f 00000008 00000000 00000000 00000028 00009500
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=4608 bufflen=4608 xfer_cnt=0
  sc->result is 00020008h
sd 0:0:4:0: SCSI error: return code = 0x20008
end_request: I/O error, dev sda, sector 149
Buffer I/O error on device sda1, logical block 86
  00080004 0100400a 000e0010 00000008 00000000 00000000 00000028 00009600
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=4096 bufflen=4096 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0011 00000008 00000000 00000000 00000028 00009600
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=4096 bufflen=4096 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0012 00000008 00000000 00000000 00000028 00009600
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=4096 bufflen=4096 xfer_cnt=0
  sc->result is 00020008h
tg3.c:v3.49 (Feb 2, 2006)
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:04:00.0 to 64
eth0: Tigon3 [partno(BCM95721) rev 4101 PHY(5750)] (PCI Express) 10/100/1000BaseT Ethernet 00:a0:d1:e0:ae:64
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] Split[0] WireSpeed[1] TSOcap[1] 
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:05:00.0 to 64
eth1: Tigon3 [partno(BCM95721) rev 4101 PHY(5750)] (PCI Express) 10/100/1000BaseT Ethernet 00:a0:d1:e0:ad:b3
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] Split[0] WireSpeed[1] TSOcap[1] 
eth1: dma_rwctrl[76180000] dma_mask[64-bit]
Non-volatile memory driver v1.2
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
lp: driver loaded but no devices found
ACPI: Power Button (FF) [PWRF]
ACPI: Power Button (CM) [PWRB]
ibm_acpi: ec object not found
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
  00080004 01004006 000e001e 00450000 00000000 0000000c 00000000 00000000
Reply ha=0 id=4 lun=1:
IOCStatus=0045h SCSIState=00h SCSIStatus=00h
resid=243 bufflen=255 xfer_cnt=12
  sc->underflow={report ERR if < 00h bytes xfer'd}
  ActBytesXferd=0ch
  sc->result is 00000000h
  00080004 01004006 000e001f 00450000 00000000 0000000c 00000000 00000000
Reply ha=0 id=4 lun=0:
IOCStatus=0045h SCSIState=00h SCSIStatus=00h
resid=243 bufflen=255 xfer_cnt=12
  sc->underflow={report ERR if < 00h bytes xfer'd}
  ActBytesXferd=0ch
  sc->result is 00000000h
  00080004 0100400a 000e003f 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0040 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0041 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0042 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0047 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=1:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0048 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=1:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0049 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=1:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e004a 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=1:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e004f 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0050 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0051 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0053 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0056 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=1:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0058 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=1:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0057 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=1:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0059 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=1:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2031608k swap on /dev/VolGroup00/LogVol01.  Priority:-1 extents:1 across:2031608k
tg3: eth1: Link is up at 1000 Mbps, full duplex.
tg3: eth1: Flow control is on for TX and on for RX.
Bluetooth: Core ver 2.8
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.7
Bluetooth: HIDP (Human Interface Emulation) ver 1.1
ppdev: user-space parallel port driver
ppdev0: claim the port first
ppdev1: claim the port first
ppdev2: claim the port first
ppdev3: claim the port first
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
IPv6 over IPv4 tunneling driver
  00080004 0100400a 000e005d 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=1:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e005f 00000008 00000000 00000000 00000028 00004000
Reply ha=0 id=4 lun=1:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=65536 bufflen=65536 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0069 00000008 00000000 00000000 00000028 00000800
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=28672 bufflen=28672 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e006f 00000008 00000000 00000000 00000028 00004000
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=65536 bufflen=65536 xfer_cnt=0
  sc->result is 00020008h
  00080004 0100400a 000e0074 00000008 00000000 00000000 f0160028 000040e1
Reply ha=0 id=4 lun=0:
IOCStatus=0000h SCSIState=00h SCSIStatus=08h
resid=3584 bufflen=3584 xfer_cnt=0
  sc->result is 00020008h
eth1: no IPv6 routers present


------=_Part_39575_22692921.1148685356485--
