From: Christian Roessner <info@roessner-net.com>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Tue, 13 Apr 2004 16:14:31 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404131614.31583.info@roessner-net.com>
References: <200404131416.32700.info@roessner-net.com> <21728.1081859533@www46.gmx.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_HX/eAoH/rluCG5k"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p15112047.pureserver.info ([217.160.169.118]:14288 "EHLO
	mail.wim-media.de") by vger.kernel.org with ESMTP id S263354AbUDMOOW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 10:14:22 -0400
In-Reply-To: <21728.1081859533@www46.gmx.net>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>


--Boundary-00=_HX/eAoH/rluCG5k
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

> > drivers/scsi/tmscsim.c: In function `dc390_initDCB':
> > drivers/scsi/tmscsim.c:1770: error: syntax error before "id"
>
> oh, sorry, forgot - there's a missing comma there. Should be:
>
> DCBDEBUG(printk (KERN_INFO "DC390: alloc mem for DCB (ID %i, LUN %i):
> %p\n", \

Done.

/var/log/kernel/current_debug attached.

Gru=DF
Christian

--Boundary-00=_HX/eAoH/rluCG5k
Content-Type: text/plain;
  charset="iso-8859-1";
  name="current_debug"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="current_debug"

Apr 13 15:54:20 [kernel] bootsplash: status on console 0 changed to on
Apr 13 15:55:46 [kernel] Bootdata ok (command line is hdc=ide-scsi vga=0x317 video=mtrr,vesa=1024x768 root=/dev/hdb3 acpi=force lapic splash=silent scsi_logging=0x1ff)
Apr 13 15:55:46 [kernel] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 11
Apr 13 15:55:46 [kernel] ACPI: PCI Interrupt Link [LACI] enabled at IRQ 9
Apr 13 15:55:46 [kernel] ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 11
Apr 13 15:55:46 [kernel] ACPI: PCI Interrupt Link [LNK4] enabled at IRQ 11
Apr 13 15:55:46 [kernel] ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 9
Apr 13 15:55:46 [kernel] ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 7
Apr 13 15:55:46 [kernel] ACPI: PCI Interrupt Link [LNK5] enabled at IRQ 7
Apr 13 15:55:46 [kernel] PCI: Using ACPI for IRQ routing
Apr 13 15:55:46 [kernel] PCI: if you experience problems, try using option 'pci=noacpi' or even 'acpi=off'
Apr 13 15:55:46 [kernel] agpgart: Detected AGP bridge 0
Apr 13 15:55:46 [kernel] agpgart: Setting up Nforce3 AGP.
Apr 13 15:55:46 [kernel] agpgart: Maximum main memory to use for agp memory: 439M
Apr 13 15:55:46 [kernel] agpgart: AGP aperture is 128M @ 0xe0000000
Apr 13 15:55:46 [kernel] PCI-DMA: Disabling IOMMU.
Apr 13 15:55:46 [kernel] vesafb: framebuffer at 0xe8000000, mapped to 0xffffff000004e000, size 16384k
Apr 13 15:55:46 [kernel] vesafb: mode is 1024x768x16, linelength=2048, pages=1
Apr 13 15:55:46 [kernel] vesafb: scrolling: redraw
Apr 13 15:55:46 [kernel] vesafb: directcolor: size=0:5:6:5, shift=0:11:5:0
Apr 13 15:55:46 [kernel] fb0: VESA VGA frame buffer device
Apr 13 15:55:46 [kernel] IA32 emulation $Id: sys_ia32.c,v 1.32 2002/03/24 13:02:28 ak Exp $
Apr 13 15:55:46 [kernel] ikconfig 0.7 with /proc/config*
Apr 13 15:55:46 [kernel] devfs: 2004-01-31 Richard Gooch (rgooch@atnf.csiro.au)
Apr 13 15:55:46 [kernel] devfs: boot_options: 0x1
Apr 13 15:55:46 [kernel] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Apr 13 15:55:46 [kernel] Initializing Cryptographic API
Apr 13 15:55:46 [kernel] ACPI: Power Button (FF) [PWRF]
Apr 13 15:55:46 [kernel] ACPI: Processor [CPU0] (supports C1)
Apr 13 15:55:46 [kernel] mice: PS/2 mouse device common for all mice
Apr 13 15:55:46 [kernel] input: PC Speaker
Apr 13 15:55:46 [kernel] serio: i8042 AUX port at 0x60,0x64 irq 12
Apr 13 15:55:46 [kernel] input: PS/2 Generic Mouse on isa0060/serio1
Apr 13 15:55:46 [kernel] serio: i8042 KBD port at 0x60,0x64 irq 1
Apr 13 15:55:46 [kernel] input: AT Translated Set 2 keyboard on isa0060/serio0
Apr 13 15:55:46 [kernel] bootsplash 3.1.4-2004/02/19: looking for picture.... silentjpeg size 21830 bytes, found (1024x768, 16923 bytes, v3).
Apr 13 15:55:46 [kernel] Console: switching to colour frame buffer device 122x40
Apr 13 15:55:46 [kernel] Real Time Clock Driver v1.12
Apr 13 15:55:46 [kernel] Linux agpgart interface v0.100 (c) Dave Jones
Apr 13 15:55:46 [kernel] Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing disabled
Apr 13 15:55:46 [kernel] ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Apr 13 15:55:46 [kernel] Using anticipatory io scheduler
Apr 13 15:55:46 [kernel] Floppy drive(s): fd0 is 1.44M
Apr 13 15:55:46 [kernel] FDC 0 is a post-1991 82077
Apr 13 15:55:46 [kernel] RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
Apr 13 15:55:46 [kernel] loop: loaded (max 8 devices)
Apr 13 15:55:46 [kernel] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Apr 13 15:55:46 [kernel] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Apr 13 15:55:46 [kernel] NFORCE3: IDE controller at PCI slot 0000:00:08.0
Apr 13 15:55:46 [kernel] NFORCE3: chipset revision 165
Apr 13 15:55:46 [kernel] NFORCE3: not 100% native mode: will probe irqs later
Apr 13 15:55:46 [kernel] NFORCE3: BIOS didn't set cable bits correctly. Enabling workaround.
Apr 13 15:55:46 [kernel] tuner: chip found at addr 0xc0 i2c-bus bt848 #0 [sw]
Apr 13 15:55:46 [kernel] tuner: type set to 0 (Temic PAL (4002 FH5)) by bt848 #0 [sw]
Apr 13 15:55:46 [kernel] bttv0: registered device video0
Apr 13 15:55:46 [kernel] bttv0: registered device vbi0
Apr 13 15:55:46 [kernel] kjournald starting.  Commit interval 5 seconds
Apr 13 15:55:46 [kernel] EXT3 FS on hdb1, internal journal
Apr 13 15:55:46 [kernel] EXT3-fs: mounted filesystem with ordered data mode.
Apr 13 15:55:46 [kernel] eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
Apr 13 15:55:46 [kernel] ohci_hcd: 2004 Feb 02 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
Apr 13 15:55:46 [kernel] ohci_hcd: block sizes: ed 80 td 96
Apr 13 15:55:46 [kernel] ohci_hcd 0000:00:02.0: nVidia Corporation nForce3 USB 1.1
Apr 13 15:55:46 [kernel] PCI: Setting latency timer of device 0000:00:02.0 to 64
Apr 13 15:55:46 [kernel] ohci_hcd 0000:00:02.0: irq 11, pci mem ffffff00010ee000
Apr 13 15:55:46 [kernel] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
Apr 13 15:55:46 [kernel] hub 1-0:1.0: USB hub found
Apr 13 15:55:46 [kernel] hub 1-0:1.0: 3 ports detected
Apr 13 15:55:46 [kernel] ohci_hcd 0000:00:02.1: nVidia Corporation nForce3 USB 1.1 (#2)
Apr 13 15:55:46 [kernel] ******* Your BIOS seems to not contain a fix for K8 errata #93
Apr 13 15:55:46 [kernel] ******* Working around it, but it may cause SEGVs or burn power.
Apr 13 15:55:46 [kernel] ******* Please consider a BIOS update.
Apr 13 15:55:46 [kernel] ******* Disabling USB legacy in the BIOS may also help.
Apr 13 15:55:46 [kernel] PCI: Setting latency timer of device 0000:00:02.1 to 64
Apr 13 15:55:46 [kernel] ohci_hcd 0000:00:02.1: irq 11, pci mem ffffff00010f0000
Apr 13 15:55:46 [kernel] ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
Apr 13 15:55:46 [kernel] hub 2-0:1.0: USB hub found
Apr 13 15:55:46 [kernel] ehci_hcd 0000:00:02.2: nVidia Corporation nForce3 USB 2.0
Apr 13 15:55:46 [kernel] PCI: Setting latency timer of device 0000:00:02.2 to 64
Apr 13 15:55:46 [kernel] ehci_hcd 0000:00:02.2: irq 11, pci mem ffffff00010f2000
Apr 13 15:55:46 [kernel] ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 3
Apr 13 15:55:46 [kernel] PCI: cache line size of 64 is not supported by device 0000:00:02.2
Apr 13 15:55:46 [kernel] ehci_hcd 0000:00:02.2: USB 2.0 enabled, EHCI 1.00, driver 2003-Dec-29
Apr 13 15:55:46 [kernel] hub 3-0:1.0: USB hub found
Apr 13 15:55:46 [kernel] hub 3-0:1.0: 6 ports detected
Apr 13 15:55:46 [kernel] DC390(0): IO_PORT=9400,IRQ=b
Apr 13 15:55:46 [kernel] DC390_init: No EEPROM found! Trying default settings ...
Apr 13 15:55:46 [kernel] DC390: Used defaults: AdaptID=7, SpeedIdx=1 (8.0 MHz), DevMode=0x1f, AdaptMode=0x0f, TaggedCmnds=3 (16), DelayReset=1s
Apr 13 15:55:46 [kernel] DC390: pSH = 1db7c000, Index 00
Apr 13 15:55:46 [kernel] DC390: Adapter index 0, ID 7, IO 0x00009400, IRQ 0x0b
Apr 13 15:55:46 [kernel] DC390: pACB = 1db7c308, pDCBmap = 1db7c374, pSRB_array = 1db7c468
Apr 13 15:55:46 [kernel] DC390: ACB size= 1bf0, DCB size=   50, SRB size=   88
Apr 13 15:55:46 [kernel] DC390: 1 adapters found
Apr 13 15:55:46 [kernel] scsi1 : Tekram DC390/AM53C974 V2.0f 2000-12-20
Apr 13 15:55:46 [kernel] DC390: Queue Cmd=12,Tgt=0,LUN=0 (pid=11), buffer=0000010000523e80
Apr 13 15:55:46 [kernel] DC390: alloc mem for DCB (ID 0, LUN 0): 000001001e5fa940
Apr 13 15:55:46 [kernel] DC390: Get Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: Free SRB w/o Waiting
Apr 13 15:55:46 [kernel] DC390: We were just reset and don't accept commands yet!
Apr 13 15:55:46 [kernel] DC390: Insert pSRB 000001001db7c468 cmd 11 to Waiting
Apr 13 15:55:46 [kernel]  ... command (pid 11) queued successfully.
Apr 13 15:55:46 [kernel] usb 2-1: new low speed USB device using address 2
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: .. IRQ returned
                - Last output repeated 29 times -
Apr 13 15:55:46 [kernel] input: USB HID v1.10 Mouse [Microsoft Microsoft 5-Button Mouse with IntelliEye(TM)] on usb-0000:00:02.1-1
Apr 13 15:55:46 [kernel] drivers/usb/core/usb.c: registered new driver hid
Apr 13 15:55:46 [kernel] drivers/usb/input/hid-core.c: v2.0:USB HID core driver
Apr 13 15:55:46 [kernel] usb 2-2: new full speed USB device using address 3
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: .. IRQ returned
                - Last output repeated 11 times -
Apr 13 15:55:46 [kernel] drivers/usb/core/usb.c: registered new driver usblp
Apr 13 15:55:46 [kernel] drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: .. IRQ returned
                - Last output repeated 2 times -
Apr 13 15:55:46 [kernel] drivers/usb/class/usblp.c: usblp0: USB Bidirectional printer dev 3 if 0 alt 0 proto 2 vid 0x03F0 pid 0x3004
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Debug: Waiting queue woken up by timer!
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped request buffer 0000010000523e80 at 523e80
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 12 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Remove SRB 000001001db7c468 from head of Waiting
Apr 13 15:55:46 [kernel] DC390: Append SRB 000001001db7c468 to Going
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 523e80
Apr 13 15:55:46 [kernel]  SRBdone (ff,00000000), SRB 000001001db7c468, pid 11
Apr 13 15:55:46 [kernel] DC390: INQUIRY: result: 00010000
Apr 13 15:55:46 [kernel] DC390: Driver about to free DCB (ID 0, LUN 0): 000001001e5fa940
Apr 13 15:55:46 [kernel] DC390: Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: SRBdone: done pid 11
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Queue Cmd=12,Tgt=1,LUN=0 (pid=12), buffer=0000010000523e80
Apr 13 15:55:46 [kernel] DC390: alloc mem for DCB (ID 1, LUN 0): 000001001e5fa940
Apr 13 15:55:46 [kernel] DC390: Get Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: Free SRB w/o Waiting
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped request buffer 0000010000523e80 at 523e80
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 12 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select w/DisCn for Cmd 12 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: Append SRB 000001001db7c468 to Going
Apr 13 15:55:46 [kernel]  ... command (pid 12) queued successfully.
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 523e80
Apr 13 15:55:46 [kernel]  SRBdone (ff,00000000), SRB 000001001db7c468, pid 12
Apr 13 15:55:46 [kernel] DC390: INQUIRY: result: 00010000
Apr 13 15:55:46 [kernel] DC390: Driver about to free DCB (ID 1, LUN 0): 000001001e5fa940
Apr 13 15:55:46 [kernel] DC390: Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: SRBdone: done pid 12
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Queue Cmd=12,Tgt=2,LUN=0 (pid=13), buffer=0000010000523e80
Apr 13 15:55:46 [kernel] DC390: alloc mem for DCB (ID 2, LUN 0): 000001001e5fa940
Apr 13 15:55:46 [kernel] DC390: Get Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: Free SRB w/o Waiting
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped request buffer 0000010000523e80 at 523e80
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 12 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select w/DisCn for Cmd 13 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: Append SRB 000001001db7c468 to Going
Apr 13 15:55:46 [kernel]  ... command (pid 13) queued successfully.
Apr 13 15:55:46 [kernel]  SRBdone (ff,00000000), SRB 000001001db7c468, pid 13
Apr 13 15:55:46 [kernel] DC390: INQUIRY: result: 00010000
Apr 13 15:55:46 [kernel] DC390: Driver about to free DCB (ID 2, LUN 0): 000001001e5fa940
Apr 13 15:55:46 [kernel] DC390: Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: SRBdone: done pid 13
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Queue Cmd=12,Tgt=3,LUN=0 (pid=14), buffer=0000010000523e80
Apr 13 15:55:46 [kernel] DC390: alloc mem for DCB (ID 3, LUN 0): 000001001e5fa940
Apr 13 15:55:46 [kernel] DC390: Get Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: Free SRB w/o Waiting
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped request buffer 0000010000523e80 at 523e80
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 12 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select w/DisCn for Cmd 14 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: Append SRB 000001001db7c468 to Going
Apr 13 15:55:46 [kernel]  ... command (pid 14) queued successfully.
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 523e80
Apr 13 15:55:46 [kernel]  SRBdone (ff,00000000), SRB 000001001db7c468, pid 14
Apr 13 15:55:46 [kernel] DC390: INQUIRY: result: 00010000
Apr 13 15:55:46 [kernel] DC390: Driver about to free DCB (ID 3, LUN 0): 000001001e5fa940
Apr 13 15:55:46 [kernel] DC390: Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: SRBdone: done pid 14
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Queue Cmd=12,Tgt=4,LUN=0 (pid=15), buffer=0000010000523e80
Apr 13 15:55:46 [kernel] DC390: alloc mem for DCB (ID 4, LUN 0): 000001001e5fa940
Apr 13 15:55:46 [kernel] DC390: Get Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: Free SRB w/o Waiting
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped request buffer 0000010000523e80 at 523e80
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 12 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select w/DisCn for Cmd 15 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: Append SRB 000001001db7c468 to Going
Apr 13 15:55:46 [kernel]  ... command (pid 15) queued successfully.
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 15:55:46 [kernel] DC390: [1]dc390_DataInPhase(1) (81)
Apr 13 15:55:46 [kernel]  DC390: Next SG segment.<7> DC390: Start transfer: 0 bytes (address 00523e80)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 15:55:46 [kernel] DC390: DMA Blast aborted unfinished!
Apr 13 15:55:46 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
Apr 13 15:55:46 [kernel] DC390: [4]dc390_Nop_0(1) (04)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 523e80
Apr 13 15:55:46 [kernel]  SRBdone (00,00000000), SRB 000001001db7c468, pid 15
Apr 13 15:55:46 [kernel] DC390: INQUIRY: result: 00000000
Apr 13 15:55:46 [kernel] DC390: Remove SRB 000001001db7c468 from Going
Apr 13 15:55:46 [kernel] DC390: Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: SRBdone: done pid 15
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel]   Vendor:           Model:                   Rev:     
Apr 13 15:55:46 [kernel]   Type:   Direct-Access                      ANSI SCSI revision: 00
Apr 13 15:55:46 [kernel] Attached scsi generic sg1 at scsi1, channel 0, id 4, lun 0,  type 0
Apr 13 15:55:46 [kernel] DC390: Queue Cmd=12,Tgt=5,LUN=0 (pid=16), buffer=0000010000523e80
Apr 13 15:55:46 [kernel] DC390: alloc mem for DCB (ID 5, LUN 0): 000001001f9e32c0
Apr 13 15:55:46 [kernel] DC390: Get Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: Free SRB w/o Waiting
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped request buffer 0000010000523e80 at 523e80
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 12 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select w/DisCn for Cmd 16 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: Append SRB 000001001db7c468 to Going
Apr 13 15:55:46 [kernel]  ... command (pid 16) queued successfully.
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 523e80
Apr 13 15:55:46 [kernel]  SRBdone (ff,00000000), SRB 000001001db7c468, pid 16
Apr 13 15:55:46 [kernel] DC390: INQUIRY: result: 00010000
Apr 13 15:55:46 [kernel] DC390: Driver about to free DCB (ID 5, LUN 0): 000001001f9e32c0
Apr 13 15:55:46 [kernel] DC390: Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: SRBdone: done pid 16
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Queue Cmd=12,Tgt=6,LUN=0 (pid=17), buffer=0000010000523e80
Apr 13 15:55:46 [kernel] DC390: alloc mem for DCB (ID 6, LUN 0): 000001001f9e32c0
Apr 13 15:55:46 [kernel] DC390: Get Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: Free SRB w/o Waiting
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped request buffer 0000010000523e80 at 523e80
Apr 13 15:55:46 [kernel] DC390: Select w/DisCn for Cmd 17 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: Append SRB 000001001db7c468 to Going
Apr 13 15:55:46 [kernel]  ... command (pid 17) queued successfully.
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 523e80
Apr 13 15:55:46 [kernel]  SRBdone (ff,00000000), SRB 000001001db7c468, pid 17
Apr 13 15:55:46 [kernel] DC390: INQUIRY: result: 00010000
Apr 13 15:55:46 [kernel] DC390: Driver about to free DCB (ID 6, LUN 0): 000001001f9e32c0
Apr 13 15:55:46 [kernel] DC390: Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: SRBdone: done pid 17
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] CAPI Subsystem Rev 1.1.2.7
Apr 13 15:55:46 [kernel] b1: revision 1.1.2.2
Apr 13 15:55:46 [kernel] b1dma: revision 1.1.2.3
Apr 13 15:55:46 [kernel] b1pci: PCI BIOS reports AVM-B1 at i/o 0x9c00, irq 11
Apr 13 15:55:46 [kernel] DC390: Queue Cmd=00,Tgt=4,LUN=0 (pid=18), buffer=0000010000522000
Apr 13 15:55:46 [kernel] DC390: Get Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: Free SRB w/o Waiting
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 00 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select w/DisCn for Cmd 18 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: Append SRB 000001001db7c468 to Going
Apr 13 15:55:46 [kernel]  ... command (pid 18) queued successfully.
Apr 13 15:55:46 [kernel] kcapi: Controller 1: b1pci-9c00 attached
Apr 13 15:55:46 [kernel] b1pci: AVM B1 PCI at i/o 0x9c00, irq 11, revision 2
Apr 13 15:55:46 [kernel] b1pci: revision 1.1.2.2
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 15:55:46 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
Apr 13 15:55:46 [kernel] DC390: [4]dc390_Nop_0(1) (04)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC, SRBdone (02,00000000), SRB 000001001db7c468, pid 18
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped sense buffer 000001001e64f198 at 1e64f198
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 00 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select wo/DisCn for Cmd 18 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: AutoReqSense !
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] libata version 1.02 loaded.
Apr 13 15:55:46 [kernel] sata_sil version 0.54
Apr 13 15:55:46 [kernel] ata2: SATA max UDMA/100 cmd 0xFFFFFF00010F60C0 ctl 0xFFFFFF00010F60CA bmdma 0xFFFFFF00010F6008 irq 9
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 15:55:46 [kernel] DC390: [1]dc390_DataInPhase(1) (81)
Apr 13 15:55:46 [kernel]  DC390: Next SG segment.<7> DC390: Start transfer: 0 bytes (address 1e64f198)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 15:55:46 [kernel] DC390: DMA Blast aborted unfinished!
Apr 13 15:55:46 [kernel] Blast: Read 40960 times DMA_Status 00<7>Xfered: -16777198, Total: -16777198, Remaining: 16777198
Apr 13 15:55:46 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
Apr 13 15:55:46 [kernel] DC390: [4]dc390_Nop_0(1) (04)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped sense buffer at 1e64f198
Apr 13 15:55:46 [kernel]  SRBdone (00,00000000), SRB 000001001db7c468, pid 18
Apr 13 15:55:46 [kernel] DC390: Remove SRB 000001001db7c468 from Going
Apr 13 15:55:46 [kernel] DC390: Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: SRBdone: done pid 18
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Queue Cmd=03,Tgt=4,LUN=0 (pid=18), buffer=0000010000522000
Apr 13 15:55:46 [kernel] DC390: Get Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: Free SRB w/o Waiting
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped request buffer 0000010000523e80 at 523e80
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 03 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select w/DisCn for Cmd 18 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: Append SRB 000001001db7c468 to Going
Apr 13 15:55:46 [kernel]  ... command (pid 18) queued successfully.
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 15:55:46 [kernel] DC390: [1]dc390_DataInPhase(1) (81)
Apr 13 15:55:46 [kernel]  DC390: Next SG segment.<7> DC390: Start transfer: 0 bytes (address 00523e80)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: DMA Blast aborted unfinished!
Apr 13 15:55:46 [kernel] Blast: Read 40960 times DMA_Status 00<7>Xfered: -16777198, Total: -16777198, Remaining: 16777198
Apr 13 15:55:46 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
Apr 13 15:55:46 [kernel] DC390: [4]dc390_Nop_0(1) (04)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 523e80
Apr 13 15:55:46 [kernel]  SRBdone (00,00000000), SRB 000001001db7c468, pid 18
Apr 13 15:55:46 [kernel] DC390: Remove SRB 000001001db7c468 from Going
Apr 13 15:55:46 [kernel] DC390: Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: SRBdone: done pid 18
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: RESET ... done
Apr 13 15:55:46 [kernel] scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 4 lun 0
Apr 13 15:55:46 [kernel] DC390: Queue Cmd=00,Tgt=4,LUN=0 (pid=19), buffer=0000010000522000
Apr 13 15:55:46 [kernel] DC390: Get Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: Free SRB w/o Waiting
Apr 13 15:55:46 [kernel] DC390: We were just reset and don't accept commands yet!
Apr 13 15:55:46 [kernel] DC390: Insert pSRB 000001001db7c468 cmd 19 to Waiting
Apr 13 15:55:46 [kernel]  ... command (pid 19) queued successfully.
Apr 13 15:55:46 [kernel] ata1: no device found (phy stat 00000000)
Apr 13 15:55:46 [kernel] ata1: thread exiting
Apr 13 15:55:46 [kernel] scsi2 : sata_sil
Apr 13 15:55:46 [kernel] ata2: no device found (phy stat 00000000)
Apr 13 15:55:46 [kernel] ata2: thread exiting
Apr 13 15:55:46 [kernel] scsi3 : sata_sil
Apr 13 15:55:46 [kernel] USB Universal Host Controller Interface driver v2.2
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: .. IRQ returned
                - Last output repeated 16 times -
Apr 13 15:55:46 [kernel] Disabled Privacy Extensions on device ffffffff8043fe00(lo)
Apr 13 15:55:46 [kernel] DC390: Debug: Waiting queue woken up by timer!
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 00 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select w/DisCn for Cmd 19 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: Remove SRB 000001001db7c468 from head of Waiting
Apr 13 15:55:46 [kernel] DC390: Append SRB 000001001db7c468 to Going
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 15:55:46 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
Apr 13 15:55:46 [kernel] DC390: [4]dc390_Nop_0(1) (04)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC, SRBdone (02,00000000), SRB 000001001db7c468, pid 19
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped sense buffer 000001001e64f198 at 1e64f198
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 00 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select wo/DisCn for Cmd 19 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: AutoReqSense !
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 15:55:46 [kernel] DC390: [1]dc390_DataInPhase(1) (81)
Apr 13 15:55:46 [kernel]  DC390: Next SG segment.<7> DC390: Start transfer: 0 bytes (address 1e64f198)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 15:55:46 [kernel] DC390: DMA Blast aborted unfinished!
Apr 13 15:55:46 [kernel] Blast: Read 40960 times DMA_Status 00<7>Xfered: -16777198, Total: -16777198, Remaining: 16777198
Apr 13 15:55:46 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
Apr 13 15:55:46 [kernel] DC390: [4]dc390_Nop_0(1) (04)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel]  SRBdone (00,00000000), SRB 000001001db7c468, pid 19
Apr 13 15:55:46 [kernel] DC390: Remove SRB 000001001db7c468 from Going
Apr 13 15:55:46 [kernel] DC390: Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: SRBdone: done pid 19
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Queue Cmd=00,Tgt=4,LUN=0 (pid=84), buffer=0000010000522000
Apr 13 15:55:46 [kernel] DC390: Get Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: Free SRB w/o Waiting
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 00 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select w/DisCn for Cmd 84 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: Append SRB 000001001db7c468 to Going
Apr 13 15:55:46 [kernel]  ... command (pid 84) queued successfully.
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 15:55:46 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
Apr 13 15:55:46 [kernel] DC390: [4]dc390_Nop_0(1) (04)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC, SRBdone (02,00000000), SRB 000001001db7c468, pid 84
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped sense buffer 000001001e64f198 at 1e64f198
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 00 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select wo/DisCn for Cmd 84 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: AutoReqSense !
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 15:55:46 [kernel] DC390: [1]dc390_DataInPhase(1) (81)
Apr 13 15:55:46 [kernel]  DC390: Next SG segment.<7> DC390: Start transfer: 0 bytes (address 1e64f198)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 15:55:46 [kernel] DC390: DMA Blast aborted unfinished!
Apr 13 15:55:46 [kernel] Blast: Read 40960 times DMA_Status 00<7>Xfered: -16777198, Total: -16777198, Remaining: 16777198
Apr 13 15:55:46 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped sense buffer at 1e64f198
Apr 13 15:55:46 [kernel]  SRBdone (00,00000000), SRB 000001001db7c468, pid 84
Apr 13 15:55:46 [kernel] DC390: Remove SRB 000001001db7c468 from Going
Apr 13 15:55:46 [kernel] DC390: Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: SRBdone: done pid 84
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] sda: Unit Not Ready, sense:
Apr 13 15:55:46 [kernel] : sense =  0  0
Apr 13 15:55:46 [kernel] Non-extended sense class 0 code 0x0
Apr 13 15:55:46 [kernel] Raw sense data:0x00 0x00 0x00 0x00 
Apr 13 15:55:46 [kernel] DC390: Queue Cmd=25,Tgt=4,LUN=0 (pid=85), buffer=0000010000522000
Apr 13 15:55:46 [kernel] DC390: Get Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: Free SRB w/o Waiting
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped request buffer 0000010000522000 at 522000
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 25 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select w/DisCn for Cmd 85 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: Append SRB 000001001db7c468 to Going
Apr 13 15:55:46 [kernel]  ... command (pid 85) queued successfully.
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 15:55:46 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
Apr 13 15:55:46 [kernel] DC390: [4]dc390_Nop_0(1) (04)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 522000
Apr 13 15:55:46 [kernel]  SRBdone (02,00000000), SRB 000001001db7c468, pid 85
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped sense buffer 000001001e64f198 at 1e64f198
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 25 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select wo/DisCn for Cmd 85 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: AutoReqSense !
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 15:55:46 [kernel] DC390: [1]dc390_DataInPhase(1) (81)
Apr 13 15:55:46 [kernel]  DC390: Next SG segment.<7> DC390: Start transfer: 0 bytes (address 1e64f198)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: DMA Blast aborted unfinished!
Apr 13 15:55:46 [kernel] Blast: Read 40960 times DMA_Status 00<7>Xfered: -16777198, Total: -16777198, Remaining: 16777198
Apr 13 15:55:46 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
Apr 13 15:55:46 [kernel] DC390: [4]dc390_Nop_0(1) (04)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped sense buffer at 1e64f198
Apr 13 15:55:46 [kernel]  SRBdone (00,00000000), SRB 000001001db7c468, pid 85
Apr 13 15:55:46 [kernel] DC390: RETRY pid 85 (25), target 04-00
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped request buffer 0000010000522000 at 522000
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 25 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select w/DisCn for Cmd 85 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 15:55:46 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
Apr 13 15:55:46 [kernel] DC390: [4]dc390_Nop_0(1) (04)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 522000
Apr 13 15:55:46 [kernel]  SRBdone (02,08000000), SRB 000001001db7c468, pid 85
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped sense buffer 000001001e64f198 at 1e64f198
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 25 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select wo/DisCn for Cmd 85 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: AutoReqSense !
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 15:55:46 [kernel] DC390: [1]dc390_DataInPhase(1) (81)
Apr 13 15:55:46 [kernel]  DC390: Next SG segment.<7> DC390: Start transfer: 0 bytes (address 1e64f198)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: DMA Blast aborted unfinished!
Apr 13 15:55:46 [kernel] Blast: Read 40960 times DMA_Status 00<7>Xfered: -16777198, Total: -16777198, Remaining: 16777198
Apr 13 15:55:46 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
Apr 13 15:55:46 [kernel] DC390: [4]dc390_Nop_0(1) (04)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped sense buffer at 1e64f198
Apr 13 15:55:46 [kernel]  SRBdone (00,08000000), SRB 000001001db7c468, pid 85
Apr 13 15:55:46 [kernel] DC390: Remove SRB 000001001db7c468 from Going
Apr 13 15:55:46 [kernel] DC390: Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: SRBdone: done pid 85
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Queue Cmd=25,Tgt=4,LUN=0 (pid=86), buffer=0000010000522000
Apr 13 15:55:46 [kernel] DC390: Get Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: Free SRB w/o Waiting
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped request buffer 0000010000522000 at 522000
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 25 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select w/DisCn for Cmd 86 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: Append SRB 000001001db7c468 to Going
Apr 13 15:55:46 [kernel]  ... command (pid 86) queued successfully.
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 15:55:46 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
Apr 13 15:55:46 [kernel] DC390: [4]dc390_Nop_0(1) (04)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 522000
Apr 13 15:55:46 [kernel]  SRBdone (02,00000000), SRB 000001001db7c468, pid 86
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped sense buffer 000001001e64f198 at 1e64f198
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 25 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select wo/DisCn for Cmd 86 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: AutoReqSense !
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: [1]dc390_DataInPhase(1) (81)
Apr 13 15:55:46 [kernel]  DC390: Next SG segment.<7> DC390: Start transfer: 0 bytes (address 1e64f198)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 15:55:46 [kernel] DC390: DMA Blast aborted unfinished!
Apr 13 15:55:46 [kernel] Blast: Read 40960 times DMA_Status 00<7>Xfered: -16777198, Total: -16777198, Remaining: 16777198
Apr 13 15:55:46 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
Apr 13 15:55:46 [kernel] DC390: [4]dc390_Nop_0(1) (04)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped sense buffer at 1e64f198
Apr 13 15:55:46 [kernel]  SRBdone (00,00000000), SRB 000001001db7c468, pid 86
Apr 13 15:55:46 [kernel] DC390: RETRY pid 86 (25), target 04-00
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped request buffer 0000010000522000 at 522000
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 25 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select w/DisCn for Cmd 86 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 15:55:46 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
Apr 13 15:55:46 [kernel] DC390: [4]dc390_Nop_0(1) (04)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 522000
Apr 13 15:55:46 [kernel]  SRBdone (02,08000000), SRB 000001001db7c468, pid 86
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped sense buffer 000001001e64f198 at 1e64f198
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 25 (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select wo/DisCn for Cmd 86 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: AutoReqSense !
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 15:55:46 [kernel]  DC390: Next SG segment.<7> DC390: Start transfer: 0 bytes (address 1e64f198)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 15:55:46 [kernel] DC390: DMA Blast aborted unfinished!
Apr 13 15:55:46 [kernel] Blast: Read 40960 times DMA_Status 00<7>Xfered: -16777198, Total: -16777198, Remaining: 16777198
Apr 13 15:55:46 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
Apr 13 15:55:46 [kernel] DC390: [4]dc390_Nop_0(1) (04)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped sense buffer at 1e64f198
Apr 13 15:55:46 [kernel] DC390: [4]dc390_Nop_0(1) (04)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped sense buffer at 1e64f198
Apr 13 15:55:46 [kernel]  SRBdone (00,08000000), SRB 000001001db7c468, pid 87
Apr 13 15:55:46 [kernel] DC390: Remove SRB 000001001db7c468 from Going
Apr 13 15:55:46 [kernel] DC390: Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: SRBdone: done pid 87
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] sda : READ CAPACITY failed.
Apr 13 15:55:46 [kernel] sda : status=1, message=00, host=0, driver=08 
Apr 13 15:55:46 [kernel] sd: sense =  0  0
Apr 13 15:55:46 [kernel] Non-extended sense class 0 code 0x0
Apr 13 15:55:46 [kernel] Raw sense data:0x00 0x00 0x00 0x00 
Apr 13 15:55:46 [kernel] DC390: Queue Cmd=1a,Tgt=4,LUN=0 (pid=88), buffer=0000010000522000
Apr 13 15:55:46 [kernel] DC390: Get Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: Free SRB w/o Waiting
Apr 13 15:55:46 [kernel] dc390_pci_map(): Mapped request buffer 0000010000522000 at 522000
Apr 13 15:55:46 [kernel] DC390: Start SCSI command: 1a (Sync:01)
Apr 13 15:55:46 [kernel] DC390: Select w/DisCn for Cmd 88 (SRB 000001001db7c468), No TagQ
Apr 13 15:55:46 [kernel] DC390: Append SRB 000001001db7c468 to Going
Apr 13 15:55:46 [kernel]  ... command (pid 88) queued successfully.
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 15:55:46 [kernel] DC390: [1]dc390_DataInPhase(1) (81)
Apr 13 15:55:46 [kernel]  DC390: Next SG segment.<7> DC390: Start transfer: 0 bytes (address 00522000)
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 15:55:46 [kernel] DC390: DMA Blast aborted unfinished!
Apr 13 15:55:46 [kernel] Blast: Read 40960 times DMA_Status 00<7>Xfered: -16777212, Total: -16777212, Remaining: 16777212
Apr 13 15:55:46 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
Apr 13 15:55:46 [kernel] DC390: [4]dc390_Nop_0(1) (04)
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 522000
Apr 13 15:55:46 [kernel]  SRBdone (00,00000000), SRB 000001001db7c468, pid 88
Apr 13 15:55:46 [kernel] DC390: Remove SRB 000001001db7c468 from Going
Apr 13 15:55:46 [kernel] DC390: Free SRB 000001001db7c468
Apr 13 15:55:46 [kernel] DC390: SRBdone: done pid 88
Apr 13 15:55:46 [kernel] .. IRQ returned
Apr 13 15:55:46 [kernel] sda: asking for cache data failed
Apr 13 15:55:46 [kernel] sda: assuming drive cache: write through
Apr 13 15:55:46 [kernel] Attached scsi disk sda at scsi1, channel 0, id 4, lun 0
Apr 13 15:55:46 [kernel] DC390: Irq (11) caught: .. IRQ returned
                - Last output repeated twice -
Apr 13 15:55:47 [kernel] parport0: PC-style at 0x278 (0x678) [PCSPP,TRISTATE]
Apr 13 15:55:47 [kernel] lp0: using parport0 (polling).
Apr 13 15:55:47 [kernel] DC390: Irq (11) caught: .. IRQ returned
                - Last output repeated 3 times -
Apr 13 15:55:49 [kernel] ip_tables: (C) 2000-2002 Netfilter core team
Apr 13 15:55:49 [kernel] ip_conntrack version 2.1 (2047 buckets, 16376 max) - 432 bytes per conntrack
Apr 13 15:55:52 [kernel] eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
Apr 13 15:55:52 [kernel] DC390: Irq (11) caught: .. IRQ returned
                - Last output repeated 23 times -
Apr 13 15:55:56 [kernel] bootsplash: status on console 0 changed to on
Apr 13 15:55:57 [kernel] DC390: Irq (11) caught: .. IRQ returned
Apr 13 15:55:57 [kernel] eth1: no IPv6 routers present
Apr 13 15:56:00 [kernel] agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
Apr 13 15:56:01 [kernel] DC390: Irq (11) caught: .. IRQ returned
Apr 13 15:56:02 [kernel] eth0: no IPv6 routers present
Apr 13 15:56:15 [kernel] DC390: Irq (11) caught: .. IRQ returned
                - Last output repeated 240 times -
Apr 13 16:03:09 [kernel] DC390: shutdown
Apr 13 16:03:16 [kernel] DC390(0): IO_PORT=9400,IRQ=b
Apr 13 16:03:16 [kernel] DC390_init: No EEPROM found! Trying default settings ...
Apr 13 16:03:16 [kernel] DC390: Used defaults: AdaptID=7, SpeedIdx=1 (8.0 MHz), DevMode=0x1f, AdaptMode=0x0f, TaggedCmnds=3 (16), DelayReset=1s
Apr 13 16:03:16 [kernel] DC390: pSH = 16470000, Index 00
Apr 13 16:03:16 [kernel] DC390: Adapter index 0, ID 7, IO 0x00009400, IRQ 0x0b
Apr 13 16:03:16 [kernel] DC390: pACB = 16470308, pDCBmap = 16470374, pSRB_array = 16470468
Apr 13 16:03:16 [kernel] DC390: ACB size= 1bf0, DCB size=   50, SRB size=   88
Apr 13 16:03:16 [kernel] DC390: 1 adapters found
Apr 13 16:03:16 [kernel] scsi4 : Tekram DC390/AM53C974 V2.0f 2000-12-20
Apr 13 16:03:16 [kernel] DC390: Queue Cmd=12,Tgt=0,LUN=0 (pid=89), buffer=0000010000522ec0
Apr 13 16:03:18 [kernel] DC390: Debug: Waiting queue woken up by timer!
Apr 13 16:03:18 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 522ec0
Apr 13 16:03:18 [kernel] DC390: Queue Cmd=12,Tgt=1,LUN=0 (pid=90), buffer=0000010000522ec0
Apr 13 16:03:18 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 522ec0
Apr 13 16:03:18 [kernel] DC390: Queue Cmd=12,Tgt=2,LUN=0 (pid=91), buffer=0000010000522ec0
Apr 13 16:03:18 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 522ec0
Apr 13 16:03:18 [kernel] DC390: Queue Cmd=12,Tgt=3,LUN=0 (pid=92), buffer=0000010000522ec0
Apr 13 16:03:19 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 522ec0
Apr 13 16:03:19 [kernel] DC390: Queue Cmd=12,Tgt=4,LUN=0 (pid=93), buffer=0000010000522ec0
Apr 13 16:03:19 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 16:03:19 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 16:03:19 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 522ec0
Apr 13 16:03:19 [kernel] DC390: Queue Cmd=00,Tgt=4,LUN=0 (pid=94), buffer=0000010000523e00
Apr 13 16:03:19 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 16:03:19 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC, SRBdone (02,00000000), SRB 0000010016470468, pid 94
Apr 13 16:03:19 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 16:03:19 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 16:03:19 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped sense buffer at 1e64f898
Apr 13 16:03:19 [kernel] DC390: Queue Cmd=03,Tgt=4,LUN=0 (pid=94), buffer=0000010000523e00
Apr 13 16:03:19 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 16:03:19 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 16:03:19 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 522dc0
Apr 13 16:03:19 [kernel] DC390: RESET ... done
Apr 13 16:03:19 [kernel] DC390: Queue Cmd=00,Tgt=4,LUN=0 (pid=95), buffer=0000010000523e00
Apr 13 16:03:22 [kernel] DC390: Debug: Waiting queue woken up by timer!
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 16:03:22 [kernel] DC390: [3]dc390_StatusPhase(1) (83)
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC, SRBdone (02,00000000), SRB 0000010016470468, pid 95
Apr 13 16:03:22 [kernel] dc390_pci_map(): Mapped sense buffer 000001001e64f898 at 1e64f898
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped sense buffer at 1e64f898
Apr 13 16:03:22 [kernel] DC390: Queue Cmd=00,Tgt=4,LUN=0 (pid=96), buffer=0000010000523e00
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC, SRBdone (02,00000000), SRB 0000010016470468, pid 96
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped sense buffer at 1e64f898
Apr 13 16:03:22 [kernel] sda: Unit Not Ready, sense:
Apr 13 16:03:22 [kernel] : sense =  0  0
Apr 13 16:03:22 [kernel] Non-extended sense class 0 code 0x0
Apr 13 16:03:22 [kernel] DC390: Queue Cmd=25,Tgt=4,LUN=0 (pid=97), buffer=0000010000523e00
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 523e00
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped sense buffer at 1e64f898
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 523e00
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped sense buffer at 1e64f898
Apr 13 16:03:22 [kernel] DC390: Queue Cmd=25,Tgt=4,LUN=0 (pid=98), buffer=0000010000523e00
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 523e00
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped sense buffer at 1e64f898
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 16:03:22 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 523e00
Apr 13 16:03:23 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 16:03:23 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 16:03:23 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped sense buffer at 1e64f898
Apr 13 16:03:23 [kernel] DC390: Queue Cmd=25,Tgt=4,LUN=0 (pid=99), buffer=0000010000523e00
Apr 13 16:03:23 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 16:03:23 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 523e00
Apr 13 16:03:23 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 16:03:23 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 16:03:23 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped sense buffer at 1e64f898
Apr 13 16:03:23 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
Apr 13 16:03:23 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 523e00
Apr 13 16:03:23 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 16:03:23 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 16:03:23 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped sense buffer at 1e64f898
Apr 13 16:03:23 [kernel] sda : READ CAPACITY failed.
Apr 13 16:03:23 [kernel] sd: sense =  0  0
Apr 13 16:03:23 [kernel] Non-extended sense class 0 code 0x0
Apr 13 16:03:23 [kernel] DC390: Queue Cmd=1a,Tgt=4,LUN=0 (pid=100), buffer=0000010000523e00
Apr 13 16:03:23 [kernel] DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
Apr 13 16:03:23 [kernel] DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
Apr 13 16:03:23 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 523e00
Apr 13 16:03:23 [kernel] sda: asking for cache data failed
Apr 13 16:03:23 [kernel] sda: assuming drive cache: write through
Apr 13 16:03:23 [kernel] Attached scsi disk sda at scsi4, channel 0, id 4, lun 0
Apr 13 16:03:23 [kernel] Attached scsi generic sg1 at scsi4, channel 0, id 4, lun 0,  type 0
Apr 13 16:03:23 [kernel] DC390: Queue Cmd=12,Tgt=5,LUN=0 (pid=101), buffer=0000010000522ec0
Apr 13 16:03:23 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 522ec0
Apr 13 16:03:23 [kernel] DC390: Queue Cmd=12,Tgt=6,LUN=0 (pid=102), buffer=0000010000522ec0
Apr 13 16:03:24 [kernel] DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,<6>DISC,dc390_pci_unmap(): Unmapped request buffer at 522ec0
Apr 13 16:03:24 [kernel] DC390: Irq (11) caught: .. IRQ returned

--Boundary-00=_HX/eAoH/rluCG5k--
