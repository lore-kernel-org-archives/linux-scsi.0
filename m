From: Micah Anderson <micah@riseup.net>
Subject: Re: Cannot get device recognized on a megaraid
Date: Mon, 24 Nov 2003 17:10:58 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031124231058.GV4399@riseup.net>
References: <20031124163035.GK4399@riseup.net> <20031124143439.A18646@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="1SQmhf2mF2YjsYvc"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.riseup.net ([216.162.217.191]:36021 "EHLO mail.riseup.net")
	by vger.kernel.org with ESMTP id S261681AbTKXXLG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 18:11:06 -0500
Content-Disposition: inline
In-Reply-To: <20031124143439.A18646@lists.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: linux-scsi@vger.kernel.org


--1SQmhf2mF2YjsYvc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, 24 Nov 2003, Matt Domsch wrote:

> > I've been fighting a megaraid card with one device, just trying to get
> > it recognized. The card has the latest bios, the drive is in a RAID 0
> > container.
> 
> What kernel and version of the megaraid driver are you using?

Linux kernel 2.4.22, megaraid driver that is included in that
kernel... I looked around in the kernel source, but I could not find a
version number anywhere.

> What is the card type please?  What does lspci -vv and lspci -vvn
> show for it?

I need to look up what the card type is, but until then...

I am attaching to this email two files, the first is lspci -vv output
and the second is lspci -vvn output.

> 
> >  megaraid: no BIOS enabled.
> 
> That's fine, as long as you're not booting from it.

Nope, not booting.

> 
> With the above information, we can help.

Thanks!

Micah

--1SQmhf2mF2YjsYvc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lspci-vv
Content-Transfer-Encoding: quoted-printable

Script started on Sun Nov 23 22:05:30 2003
=0D=1B[0m=1B[27m=1B[24m=1B[Jraven% =1B[K=07=07l=08lspci -vv=0D=0D
00:00.0 Host bridge: Intel Corp. 440GX - 82443GX Host bridge=0D
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B-=0D
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort+ >SERR- <PERR-=0D
	Latency: 64=0D
	Region 0: Memory at f4000000 (32-bit, prefetchable) [size=3D64M]=0D
	Capabilities: <available only to root>=0D
=0D
00:01.0 PCI bridge: Intel Corp. 440GX - 82443GX AGP bridge (prog-if 00 [Nor=
mal decode])=0D
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 64=0D
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D64=0D
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B+=0D
=0D
00:07.0 ISA bridge: Intel Corp. 82371AB PIIX4 ISA (rev 02)=0D
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B-=0D
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 0=0D
=0D
00:07.1 IDE interface: Intel Corp. 82371AB PIIX4 IDE (rev 01) (prog-if 80 [=
Master])=0D
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 64=0D
	Region 4: I/O ports at fcd0 [size=3D16]=0D
=0D
00:07.2 USB Controller: Intel Corp. 82371AB PIIX4 USB (rev 01) (prog-if 00 =
[UHCI])=0D
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 64=0D
	Interrupt: pin D routed to IRQ 19=0D
	Region 4: I/O ports at fce0 [size=3D32]=0D
=0D
00:07.3 Bridge: Intel Corp. 82371AB PIIX4 ACPI (rev 02)=0D
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Interrupt: pin ? routed to IRQ 9=0D
=0D
00:08.0 SCSI storage controller: Adaptec AIC-7880U (rev 01)=0D
	Subsystem: Adaptec AIC-7880P Ultra/Ultra Wide SCSI Chipset=0D
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 64 (2000ns min, 2000ns max), cache line size 08=0D
	Interrupt: pin A routed to IRQ 16=0D
	Region 0: I/O ports at f800 [disabled] [size=3D256]=0D
	Region 1: Memory at fedff000 (32-bit, non-prefetchable) [size=3D4K]=0D
	Expansion ROM at <unassigned> [disabled] [size=3D64K]=0D
	Capabilities: <available only to root>=0D
=0D
00:10.0 VGA compatible controller: Silicon Integrated Systems [SiS] 86C326 =
(rev 0b) (prog-if 00 [VGA])=0D
	Subsystem: Palit Microsystems Inc. SiS6326 GUI Accelerator=0D
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Interrupt: pin A routed to IRQ 17=0D
	Region 0: Memory at fe000000 (32-bit, prefetchable) [size=3D8M]=0D
	Region 1: Memory at fede0000 (32-bit, non-prefetchable) [size=3D64K]=0D
	Region 2: I/O ports at fc00 [size=3D128]=0D
	Expansion ROM at <unassigned> [disabled] [size=3D64K]=0D
	Capabilities: <available only to root>=0D
=0D
00:11.0 RAID bus controller: CMD Technology Inc: Unknown device 0680 (rev 0=
2)=0D
	Subsystem: LSI Logic / Symbios Logic (formerly NCR): Unknown device 0524=0D
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 64, cache line size 08=0D
	Interrupt: pin A routed to IRQ 18=0D
	Region 0: I/O ports at fca8 [size=3D8]=0D
	Region 1: I/O ports at fcb8 [size=3D4]=0D
	Region 2: I/O ports at fcb0 [size=3D8]=0D
	Region 3: I/O ports at fcbc [size=3D4]=0D
	Region 4: I/O ports at fcc0 [size=3D16]=0D
	Region 5: Memory at fedfec00 (32-bit, non-prefetchable) [size=3D256]=0D
	Expansion ROM at <unassigned> [disabled] [size=3D512K]=0D
	Capabilities: <available only to root>=0D
=0D
00:13.0 PCI bridge: Digital Equipment Corporation DECchip 21152 (rev 03) (p=
rog-if 00 [Normal decode])=0D
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 64, cache line size 08=0D
	Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D68=0D
	I/O behind bridge: 0000e000-0000efff=0D
	Memory behind bridge: fbf00000-fbffffff=0D
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-=0D
	Capabilities: <available only to root>=0D
=0D
02:04.0 SCSI storage controller: LSI Logic / Symbios Logic (formerly NCR) 5=
3c875 (rev 26)=0D
	Subsystem: LSI Logic / Symbios Logic (formerly NCR): Unknown device 1000=0D
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 72 (4250ns min, 16000ns max), cache line size 08=0D
	Interrupt: pin A routed to IRQ 19=0D
	Region 0: I/O ports at e800 [size=3D256]=0D
	Region 1: Memory at fbfff800 (32-bit, non-prefetchable) [size=3D256]=0D
	Region 2: Memory at fbffe000 (32-bit, non-prefetchable) [size=3D4K]=0D
	Expansion ROM at <unassigned> [disabled] [size=3D256K]=0D
	Capabilities: <available only to root>=0D
=0D
02:05.0 Ethernet controller: Advanced Micro Devices [AMD] 79c970 [PCnet LAN=
CE] (rev 36)=0D
	Subsystem: Hewlett-Packard Company Ethernet with LAN remote power Adapter=
=0D
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 64 (6000ns min, 6000ns max)=0D
	Interrupt: pin A routed to IRQ 16=0D
	Region 0: I/O ports at ece0 [size=3D32]=0D
	Region 1: Memory at fbfff400 (32-bit, non-prefetchable) [size=3D32]=0D
	Expansion ROM at <unassigned> [disabled] [size=3D1M]=0D
	Capabilities: <available only to root>=0D
=0D
=0D=1B[0m=1B[27m=1B[24m=1B[Jraven% =1B[K=0D=0D

Script done on Sun Nov 23 22:05:37 2003

--1SQmhf2mF2YjsYvc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lspci-vvn
Content-Transfer-Encoding: quoted-printable

Script started on Sun Nov 23 22:05:45 2003
=0D=1B[0m=1B[27m=1B[24m=1B[Jraven% =1B[Kl=08lspci -vvn=0D=0D
00:00.0 Class 0600: 8086:71a0=0D
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B-=0D
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort+ >SERR- <PERR-=0D
	Latency: 64=0D
	Region 0: Memory at f4000000 (32-bit, prefetchable) [size=3D64M]=0D
	Capabilities: <available only to root>=0D
=0D
00:01.0 Class 0604: 8086:71a1=0D
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 64=0D
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D64=0D
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B+=0D
=0D
00:07.0 Class 0601: 8086:7110 (rev 02)=0D
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR+ FastB2B-=0D
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 0=0D
=0D
00:07.1 Class 0101: 8086:7111 (rev 01) (prog-if 80 [Master])=0D
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 64=0D
	Region 4: I/O ports at fcd0 [size=3D16]=0D
=0D
00:07.2 Class 0c03: 8086:7112 (rev 01)=0D
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 64=0D
	Interrupt: pin D routed to IRQ 19=0D
	Region 4: I/O ports at fce0 [size=3D32]=0D
=0D
00:07.3 Class 0680: 8086:7113 (rev 02)=0D
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Interrupt: pin ? routed to IRQ 9=0D
=0D
00:08.0 Class 0100: 9004:8078 (rev 01)=0D
	Subsystem: 9004:7880=0D
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 64 (2000ns min, 2000ns max), cache line size 08=0D
	Interrupt: pin A routed to IRQ 16=0D
	Region 0: I/O ports at f800 [disabled] [size=3D256]=0D
	Region 1: Memory at fedff000 (32-bit, non-prefetchable) [size=3D4K]=0D
	Expansion ROM at <unassigned> [disabled] [size=3D64K]=0D
	Capabilities: <available only to root>=0D
=0D
00:10.0 Class 0300: 1039:6326 (rev 0b)=0D
	Subsystem: 1569:6326=0D
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Interrupt: pin A routed to IRQ 17=0D
	Region 0: Memory at fe000000 (32-bit, prefetchable) [size=3D8M]=0D
	Region 1: Memory at fede0000 (32-bit, non-prefetchable) [size=3D64K]=0D
	Region 2: I/O ports at fc00 [size=3D128]=0D
	Expansion ROM at <unassigned> [disabled] [size=3D64K]=0D
	Capabilities: <available only to root>=0D
=0D
00:11.0 Class 0104: 1095:0680 (rev 02)=0D
	Subsystem: 1000:0524=0D
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 64, cache line size 08=0D
	Interrupt: pin A routed to IRQ 18=0D
	Region 0: I/O ports at fca8 [size=3D8]=0D
	Region 1: I/O ports at fcb8 [size=3D4]=0D
	Region 2: I/O ports at fcb0 [size=3D8]=0D
	Region 3: I/O ports at fcbc [size=3D4]=0D
	Region 4: I/O ports at fcc0 [size=3D16]=0D
	Region 5: Memory at fedfec00 (32-bit, non-prefetchable) [size=3D256]=0D
	Expansion ROM at <unassigned> [disabled] [size=3D512K]=0D
	Capabilities: <available only to root>=0D
=0D
00:13.0 Class 0604: 1011:0024 (rev 03)=0D
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 64, cache line size 08=0D
	Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D68=0D
	I/O behind bridge: 0000e000-0000efff=0D
	Memory behind bridge: fbf00000-fbffffff=0D
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-=0D
	Capabilities: <available only to root>=0D
=0D
02:04.0 Class 0100: 1000:000f (rev 26)=0D
	Subsystem: 1000:1000=0D
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 72 (4250ns min, 16000ns max), cache line size 08=0D
	Interrupt: pin A routed to IRQ 19=0D
	Region 0: I/O ports at e800 [size=3D256]=0D
	Region 1: Memory at fbfff800 (32-bit, non-prefetchable) [size=3D256]=0D
	Region 2: Memory at fbffe000 (32-bit, non-prefetchable) [size=3D4K]=0D
	Expansion ROM at <unassigned> [disabled] [size=3D256K]=0D
	Capabilities: <available only to root>=0D
=0D
02:05.0 Class 0200: 1022:2000 (rev 36)=0D
	Subsystem: 103c:106e=0D
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B-=0D
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR-=0D
	Latency: 64 (6000ns min, 6000ns max)=0D
	Interrupt: pin A routed to IRQ 16=0D
	Region 0: I/O ports at ece0 [size=3D32]=0D
	Region 1: Memory at fbfff400 (32-bit, non-prefetchable) [size=3D32]=0D
	Expansion ROM at <unassigned> [disabled] [size=3D1M]=0D
	Capabilities: <available only to root>=0D
=0D
=0D=1B[0m=1B[27m=1B[24m=1B[Jraven% =1B[K=0D=0D

Script done on Sun Nov 23 22:05:52 2003

--1SQmhf2mF2YjsYvc--
