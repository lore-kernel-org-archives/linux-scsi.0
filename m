From: Andrew Morton <akpm@osdl.org>
Subject: Re: Adaptec 9405w in debian - HELP
Date: Mon, 24 Jul 2006 14:07:08 -0700
Message-ID: <20060724140708.046490ba.akpm@osdl.org>
References: <20060723141934.GA12721@beraldoleal.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:50585 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751448AbWGXVHW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 17:07:22 -0400
In-Reply-To: <20060723141934.GA12721@beraldoleal.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Beraldo Leal <uid0@beraldoleal.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>

On Sun, 23 Jul 2006 12:19:34 -0200
Beraldo Leal <uid0@beraldoleal.org> wrote:

> Hi Andrew, I see your page in wikipedia about the Adaptec 9405w, I
> follow the steps, but I don't see my SATA disk.
>=20
> I have debian testing in HD IDE with kernel 2.6.15.
> I download the kernel 2.6.15 source.
> I download your patch from your url.
> I apply the patch. make menuconfig , select module Adaptec AIC94xx
> SAS/SATA Support, i create a .deb, I install with dpkg -i, and I crea=
te
> the initrd.=20
> The boot is perfect, but I don' t see or I don't know to see the SATA=
=2E
> My dmesg out put is in attachment.
>=20
> Thanks for any help.
> Abrac=E7os,
> Beraldo Leal
> uid0@beraldoleal.org
> www.beraldoleal.org
>=20
>=20

I'm not really sure who looks after the SAS stuff, but it sure ain't me=
 ;)

Cc's added.  Probably they'll ask you to test 2.6.18-rc2-mm1, which has=
 the
latest code.

We have no idea which patch you used, btw.  There are many patches.



> ff 20100000 00000000 00000180 0000649d 00000000 00000000
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#0.
> CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
> CPU0: Thermal monitoring handled by SMI
> mtrr: v2.0 (20020519)
> CPU: Intel(R) Pentium(R) 4 CPU 3.40GHz stepping 03
> Checking 'hlt' instruction... OK.
> ENABLING IO-APIC IRQs
> ..TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
> checking if image is initramfs...it isn't (bad gzip magic numbers); l=
ooks like an initrd
> Freeing initrd memory: 4756k freed
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: PCI BIOS revision 2.10 entry at 0xfd78f, last bus=3D10
> PCI: Using MMCONFIG
> ACPI: Subsystem revision 20051216
> ACPI: Interpreter enabled
> ACPI: Using IOAPIC for interrupt routing
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> PCI: Probing PCI hardware (bus 00)
> PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
> PCI: PXH quirk detected, disabling MSI for SHPC device
> Boot video device is 0000:0a:04.0
> PCI: Transparent bridge - 0000:00:1e.0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG_._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1.PXHV._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP6._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
> ACPI: PCI Interrupt Link [LNKA] (IRQs 3 *10 11 14 15)
> ACPI: PCI Interrupt Link [LNKB] (IRQs 3 10 *11 14 15)
> ACPI: PCI Interrupt Link [LNKC] (IRQs 3 10 *11 14 15)
> ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *10 11 14 15)
> ACPI: PCI Interrupt Link [LNKE] (IRQs 3 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNKF] (IRQs 3 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNKG] (IRQs 3 10 11 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNKH] (IRQs 3 10 11 14 15) *5
> Linux Plug and Play Support v0.97 (c) Adam Belay
> pnp: PnP ACPI init
> pnp: PnP ACPI: found 12 devices
> PnPBIOS: Disabled by ACPI PNP
> SCSI subsystem initialized
> PCI: Using ACPI for IRQ routing
> PCI: If a device doesn't work, try "pci=3Drouteirq".  If it helps, po=
st a report
> PCI: Cannot allocate resource region 7 of bridge 0000:00:01.0
> PCI: Cannot allocate resource region 8 of bridge 0000:00:01.0
> PCI: Cannot allocate resource region 9 of bridge 0000:00:01.0
> PCI: Bridge: 0000:00:01.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:02:00.0
>   IO window: 4000-4fff
>   MEM window: c0200000-c02fffff
>   PREFETCH window: c0600000-c06fffff
> PCI: Bridge: 0000:00:1c.0
>   IO window: 4000-4fff
>   MEM window: c0100000-c02fffff
>   PREFETCH window: c0600000-c06fffff
> PCI: Bridge: 0000:00:1c.4
>   IO window: disabled.
>   MEM window: c0300000-c03fffff
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:1c.5
>   IO window: disabled.
>   MEM window: c0400000-c04fffff
>   PREFETCH window: 50000000-500fffff
> PCI: Bridge: 0000:00:1e.0
>   IO window: 5000-5fff
>   MEM window: c0500000-c05fffff
>   PREFETCH window: c8000000-cfffffff
> ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 169
> PCI: Setting latency timer of device 0000:00:01.0 to 64
> ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 177
> PCI: Setting latency timer of device 0000:00:1c.0 to 64
> PCI: Setting latency timer of device 0000:02:00.0 to 64
> ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 177
> PCI: Setting latency timer of device 0000:00:1c.4 to 64
> ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 16 (level, low) -> IRQ 169
> PCI: Setting latency timer of device 0000:00:1c.5 to 64
> PCI: Setting latency timer of device 0000:00:1e.0 to 64
> Simple Boot Flag at 0x3c set to 0x1
> audit: initializing netlink socket (disabled)
> audit(1153652738.097:1): initialized
> highmem bounce pool size: 64 pages
> VFS: Disk quotas dquot_6.5.1
> Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> Initializing Cryptographic API
> io scheduler noop registered
> io scheduler anticipatory registered
> io scheduler deadline registered
> io scheduler cfq registered
> ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 169
> PCI: Setting latency timer of device 0000:00:01.0 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:00:01.0:pcie00]
> Allocate Port Service[0000:00:01.0:pcie03]
> ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 177
> PCI: Setting latency timer of device 0000:00:1c.0 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:00:1c.0:pcie00]
> Allocate Port Service[0000:00:1c.0:pcie02]
> Allocate Port Service[0000:00:1c.0:pcie03]
> ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 177
> PCI: Setting latency timer of device 0000:00:1c.4 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:00:1c.4:pcie00]
> Allocate Port Service[0000:00:1c.4:pcie02]
> Allocate Port Service[0000:00:1c.4:pcie03]
> ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 16 (level, low) -> IRQ 169
> PCI: Setting latency timer of device 0000:00:1c.5 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:00:1c.5:pcie00]
> Allocate Port Service[0000:00:1c.5:pcie02]
> Allocate Port Service[0000:00:1c.5:pcie03]
> isapnp: Scanning for PnP cards...
> Time: tsc clocksource has been installed.
> isapnp: No Plug & Play device found
> PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,1=
2
> serio: i8042 AUX port at 0x60,0x64 irq 12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enab=
led
> serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
> serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
> 00:07: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
> 00:08: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
> RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
> aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.2 loaded
> ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI 19 (level, low) -> IRQ 225
> aic94xx: found Adaptec AIC-9405W SAS/SATA Host Adapter, device 0000:0=
3:04.0
> aic94xx: BIOS present (1,1), 1549
> aic94xx: ue num:1, ue size:88
> aic94xx: 1Found FLASH(8) manuf:1, dev_id:0xda, sec_prot:0
> aic94xx: manuf sect SAS_ADDR 5005076a01406f40
> aic94xx: manuf sect PCBA SN ORG
> aic94xx: ms: num_phy_desc: 8
> aic94xx: ms: phy0: HIDDEN
> aic94xx: ms: phy1: HIDDEN
> aic94xx: ms: phy2: HIDDEN
> aic94xx: ms: phy3: HIDDEN
> aic94xx: ms: phy4: ENEBLEABLE
> aic94xx: ms: phy5: ENEBLEABLE
> aic94xx: ms: phy6: ENEBLEABLE
> aic94xx: ms: phy7: ENEBLEABLE
> aic94xx: ms: max_phys:0x4, num_phys:0x4
> aic94xx: ms: enabled_phys:0xf0
> aic94xx: ctrla: phy4: sas_addr: 5005076a01406f40, sas rate:0x9-0x8, s=
ata rate:0x0-0x0, flags:0x0
> aic94xx: ctrla: phy5: sas_addr: 5005076a01406f40, sas rate:0x9-0x8, s=
ata rate:0x0-0x0, flags:0x0
> aic94xx: ctrla: phy6: sas_addr: 5005076a01406f40, sas rate:0x9-0x8, s=
ata rate:0x0-0x0, flags:0x0
> aic94xx: ctrla: phy7: sas_addr: 5005076a01406f40, sas rate:0x9-0x8, s=
ata rate:0x0-0x0, flags:0x0
> aic94xx: max_scbs:512, max_ddbs:128
> aic94xx: setting phy4 addr to 5005076a01406f40
> aic94xx: setting phy5 addr to 5005076a01406f40
> aic94xx: setting phy6 addr to 5005076a01406f40
> aic94xx: setting phy7 addr to 5005076a01406f40
> aic94xx: num_edbs:14
> aic94xx: num_escbs:2
> aic94xx: using sequencer Razor_10a1
> aic94xx: downloading CSEQ...
> aic94xx: dma-ing 8192 bytes
> aic94xx: verified 8192 bytes, passed
> aic94xx: downloading LSEQs...
> aic94xx: dma-ing 14336 bytes
> aic94xx: LSEQ4 verified 14336 bytes, passed
> aic94xx: LSEQ5 verified 14336 bytes, passed
> aic94xx: LSEQ6 verified 14336 bytes, passed
> aic94xx: LSEQ7 verified 14336 bytes, passed
> aic94xx: max_scbs:446
> aic94xx: first_scb_site_no:0x20
> aic94xx: last_scb_site_no:0x1fe
> aic94xx: First SCB dma_handle: 0x1fb92000
> aic94xx: device 0000:03:04.0: SAS addr 5005076a01406f40, PCBA SN ORG,=
 4 phys, 4 enabled phys, flash present, BIOS build 1549
> aic94xx: posting 2 escbs
> aic94xx: escbs posted
> scsi0 : Adaptec AIC-9405W SAS/SATA Host Adapter
> aic94xx: posting 4 control phy scbs
> aic94xx: enabled phys
> MC: drivers/edac/edac_mc.c version edac_mc  Ver: 2.0.0 Jul 22 2006
> aic94xx: control_phy_tasklet_complete: phy4, lrate:0x8, proto:0xe
> aic94xx: control_phy_tasklet_complete: phy5, lrate:0x8, proto:0xe
> NET: Registered protocol family 2
> IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> TCP established hash table entries: 131072 (order: 7, 524288 bytes)
> TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
> TCP: Hash tables configured (established 131072 bind 65536)
> TCP reno registered
> TCP bic registered
> NET: Registered protocol family 1
> NET: Registered protocol family 17
> NET: Registered protocol family 8
> aic94xx: control_phy_tasklet_complete: phy6: no device present: oob_s=
tatus:0x0
> aic94xx: control_phy_tasklet_complete: phy7: no device present: oob_s=
tatus:0x0
> NET: Registered protocol family 20
> Using IPI Shortcut mode
> ACPI wakeup devices:=20
>  PEG EXP1 EXP5 EXP6 PCIB COM1 COM2 KBC0 MSE0 AC97 USB1 USB2 USB3 USB4=
 EUSB=20
> ACPI: (supports S0 S1 S4 S5)
> RAMDISK: cramfs filesystem found at block 0
> RAMDISK: Loading 4756KiB [1 disk] into ram disk... |=08/=08-=08\=08|=08=
/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08=
\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08=
/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08=
\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08=
/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08=
\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08=
/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08=
\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08=
/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08=
\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08=
/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08=
\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08=
/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08=
\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08=
/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08=
\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08/=08-=08\=08|=08=
/=08-=08\=08|=08/=08done.
> VFS: Mounted root (cramfs filesystem) readonly.
> aic94xx: escb_tasklet_complete: phy4: BYTES_DMAED
> aic94xx: STP proto device-to-host FIS:
> aic94xx: 00: 34 00 50 01
> aic94xx: 04: 01 00 00 a0
> aic94xx: 08: 00 00 00 00
> aic94xx: 0c: 01 00 00 00
> aic94xx: 10: 00 00 00 00
> aic94xx: escb_tasklet_complete: phy5: BYTES_DMAED
> aic94xx: STP proto device-to-host FIS:
> aic94xx: 00: 34 00 50 01
> aic94xx: 04: 01 00 00 a0
> aic94xx: 08: 00 00 00 00
> aic94xx: 0c: 01 00 00 00
> aic94xx: 10: 00 00 00 00
> sas: phy4: port event: PORTE_BYTES_DMAED
> sas: phy4 added to port0, phy_mask:0x10
> sas: DOING DISCOVERY on port 0, pid:802
> sas: phy5: port event: PORTE_BYTES_DMAED
> sas: phy5 added to port1, phy_mask:0x20
> sas: DOING DISCOVERY on port 1, pid:804
> sas: DONE DISCOVERY on port 0, pid:802, result:0
> Freeing unused kernel memory: 156k freed
> sas: DONE DISCOVERY on port 1, pid:804, result:0
> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with ide=
bus=3Dxx
> input: AT Translated Set 2 keyboard as /class/input/input0
> ICH7: IDE controller at PCI slot 0000:00:1f.1
> ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 233
> ICH7: chipset revision 1
> ICH7: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0x30a0-0x30a7, BIOS settings: hda:DMA, hdb:pio
> Probing IDE interface ide0...
> hda: SAMSUNG SP0411N, ATA DISK drive
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> Probing IDE interface ide1...
> hda: max request size: 512KiB
> hda: 78242976 sectors (40060 MB) w/2048KiB Cache, CHS=3D16383/255/63,=
 UDMA(100)
> hda: cache flushes supported
>  hda: hda1 hda2
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: mounted filesystem with ordered data mode.
> parport: PnPBIOS parport detected.
> parport0: PC-style at 0x378 (0x778), irq 7, dma 1 [PCSPP,TRISTATE,COM=
PAT,ECP,DMA]
> libata version 1.20 loaded.
> ahci 0000:00:1f.2: version 1.2
> ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 225
> hw_random: RNG not detected
> usbcore: registered new driver usbfs
> usbcore: registered new driver hub
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> Real Time Clock Driver v1.12ac
> input: PC Speaker as /class/input/input1
> USB Universal Host Controller Interface driver v3.0
> mice: PS/2 mouse device common for all mice
> PCI: Setting latency timer of device 0000:00:1f.2 to 64
> ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x0 impl SA=
TA mode
> ahci 0000:00:1f.2: flags: 64bit ncq pm led clo slum part=20
> ata1: SATA max UDMA/133 cmd 0xF8904500 ctl 0x0 bmdma 0x0 irq 50
> ata2: SATA max UDMA/133 cmd 0xF8904580 ctl 0x0 bmdma 0x0 irq 50
> ata3: SATA max UDMA/133 cmd 0xF8904600 ctl 0x0 bmdma 0x0 irq 50
> ata4: SATA max UDMA/133 cmd 0xF8904680 ctl 0x0 bmdma 0x0 irq 50
> ata1: SATA link down (SStatus 0)
> scsi1 : ahci
> ata2: SATA link down (SStatus 0)
> scsi2 : ahci
> ata3: SATA link down (SStatus 0)
> scsi3 : ahci
> ata4: SATA link down (SStatus 0)
> scsi4 : ahci
> tg3.c:v3.47 (Dec 28, 2005)
> ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 169
> PCI: Setting latency timer of device 0000:04:00.0 to 64
> eth0: Tigon3 [partno(BCM95721) rev 4101 PHY(5750)] (PCI Express) 10/1=
00/1000BaseT Ethernet 00:11:25:a4:7b:08
> eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] Split[0] WireSpeed[1] =
TSOcap[1]=20
> eth0: dma_rwctrl[76180000]
> ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 17 (level, low) -> IRQ 177
> PCI: Setting latency timer of device 0000:05:00.0 to 64
> eth1: Tigon3 [partno(BCM95721A211) rev 4101 PHY(5750)] (PCI Express) =
10/100/1000BaseT Ethernet 00:10:18:0f:aa:99
> eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] Split[0] WireSpeed[1] =
TSOcap[1]=20
> eth1: dma_rwctrl[76180000]
> ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 58
> PCI: Setting latency timer of device 0000:00:1d.0 to 64
> uhci_hcd 0000:00:1d.0: UHCI Host Controller
> uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
> uhci_hcd 0000:00:1d.0: irq 58, io base 0x00003000
> usb usb1: configuration #1 chosen from 1 choice
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 2 ports detected
> ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 225
> PCI: Setting latency timer of device 0000:00:1d.1 to 64
> uhci_hcd 0000:00:1d.1: UHCI Host Controller
> uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
> uhci_hcd 0000:00:1d.1: irq 225, io base 0x00003020
> usb usb2: configuration #1 chosen from 1 choice
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 2 ports detected
> ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 233
> PCI: Setting latency timer of device 0000:00:1d.2 to 64
> uhci_hcd 0000:00:1d.2: UHCI Host Controller
> uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
> uhci_hcd 0000:00:1d.2: irq 233, io base 0x00003040
> usb usb3: configuration #1 chosen from 1 choice
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 2 ports detected
> shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 58
> PCI: Setting latency timer of device 0000:00:1d.7 to 64
> ehci_hcd 0000:00:1d.7: EHCI Host Controller
> ehci_hcd 0000:00:1d.7: debug port 1
> PCI: cache line size of 128 is not supported by device 0000:00:1d.7
> ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
> ehci_hcd 0000:00:1d.7: irq 58, io mem 0xc0000000
> ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> usb usb4: configuration #1 chosen from 1 choice
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 6 ports detected
> Adding 979924k swap on /dev/hda1.  Priority:-1 extents:1 across:97992=
4k
> EXT3 FS on hda2, internal journal
> device-mapper: 4.5.0-ioctl (2005-10-04) initialised: dm-devel@redhat.=
com
> ACPI: Processor [CPU0] (supports 8 throttling states)
> ACPI: Power Button (FF) [PWRF]
> ACPI: Power Button (CM) [PWRB]
> NET: Registered protocol family 10
> lo: Disabled Privacy Extensions
> IPv6 over IPv4 tunneling driver
>=20
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
