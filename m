From: Christian Roessner <info@roessner-net.com>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Sun, 11 Apr 2004 11:20:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404111120.17574.info@roessner-net.com>
References: <Pine.LNX.4.44.0404102308270.6949-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_R3QeAf3hjcNeXmi"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p15112047.pureserver.info ([217.160.169.118]:30920 "EHLO
	mail.wim-media.de") by vger.kernel.org with ESMTP id S262176AbUDKJUN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Apr 2004 05:20:13 -0400
In-Reply-To: <Pine.LNX.4.44.0404102308270.6949-100000@poirot.grange>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>


--Boundary-00=_R3QeAf3hjcNeXmi
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

first problem I have is, I can not compile the 2.6.5 kernel without IOMMU 
support, ecause ioapic failes while compiling and the process aborts. I am 
using make menuconfig and under Processor-Type and Features, IO-APIC is not 
listed, so I only could disable it in .config, but I think turning off APIC 
is not a good idea.

I patched tmscsi.c and turned on DEBUG1. Both results are attached to this 
mail.

Regards

Christian

Am Samstag, 10. April 2004 23:14 schrieben Sie:
> On Sat, 10 Apr 2004, Guennadi Liakhovetski wrote:
> > Ok, sorry, forget (at least for now) about all that debugging I asked you
> > about. Just tell me how much RAM you have. And, please, send me your
> > complete dmesg from the start-up, and, maybe, related to your scsi-card.
>
> I reviewed the dma-stuff in tmscsim, and so far I cannot see big problems
> there, except if you have more than ~4GB RAM, or, at least, if you have
> HIGHMEM64 set in your configuration. Looks like you are using a gentoo
> kernel. Could you check in their configuration, if this option is set? If
> you don't find the file itself, you might be lucky and find it in
> /proc/config.gz. In any case, could you, please, try to enable DEBUG1,
> i.e. in file drivers/scsi/tmscsim.c modify the line 178 (approx.) from
> //#define DC390_DEBUG1
> to
> #define DC390_DEBUG1
> . Recompile, and send the kernel messages.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski

-- 
Roessner Network Solutions (R.N.S.)

Tel.: 0641-2097252, Fax: 0641-2097253, Mobil: 0171-3611230
URL: http://www.roessner-net.com/
PGP: http://www.roessner-nat.com/kontakt/0x6A549505.asc


--Boundary-00=_R3QeAf3hjcNeXmi
Content-Type: application/x-gzip;
  name="current.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="current.gz"

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
lx7Sl3clTOnDVhuF+T9aBDil2HwAAA==

--Boundary-00=_R3QeAf3hjcNeXmi
Content-Type: text/x-log;
  charset="iso-8859-1";
  name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.log"

23 (SRB 0000010018e76468), No TagQ
DC390: AutoReqSense !
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
DC390: [1]dc390_DataInPhase(1) (81)
 DC390: Next SG segment.<7> DC390: Start transfer: 0 bytes (address 1e7bc898)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
DC390: DMA Blast aborted unfinished!
Blast: Read 40960 times DMA_Status 00<7>Xfered: -16777198, Total: -16777198, Remaining: 16777198
DC390: [3]dc390_StatusPhase(1) (83)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
DC390: [4]dc390_Nop_0(1) (04)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped sense buffer at 1e7bc898
.. IRQ returned
dc390_pci_map(): Mapped request buffer 0000010000b52e00 at b52e00
DC390: Start SCSI command: 25 (Sync:01)
DC390: Select w/DisCn for Cmd 124 (SRB 0000010018e76468), No TagQ
 ... command (pid 124) queued successfully.
DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
DC390: [3]dc390_StatusPhase(1) (83)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
DC390: [4]dc390_Nop_0(1) (04)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at b52e00
dc390_pci_map(): Mapped sense buffer 000001001e7bc898 at 1e7bc898
DC390: Start SCSI command: 25 (Sync:01)
DC390: Select wo/DisCn for Cmd 124 (SRB 0000010018e76468), No TagQ
DC390: AutoReqSense !
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
DC390: [1]dc390_DataInPhase(1) (81)
 DC390: Next SG segment.<7> DC390: Start transfer: 0 bytes (address 1e7bc898)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
DC390: DMA Blast aborted unfinished!
Blast: Read 40960 times DMA_Status 00<7>Xfered: -16777198, Total: -16777198, Remaining: 16777198
DC390: [3]dc390_StatusPhase(1) (83)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
DC390: [4]dc390_Nop_0(1) (04)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped sense buffer at 1e7bc898
dc390_pci_map(): Mapped request buffer 0000010000b52e00 at b52e00
DC390: Start SCSI command: 25 (Sync:01)
DC390: Select w/DisCn for Cmd 124 (SRB 0000010018e76468), No TagQ
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
DC390: [3]dc390_StatusPhase(1) (83)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
DC390: [4]dc390_Nop_0(1) (04)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at b52e00
dc390_pci_map(): Mapped sense buffer 000001001e7bc898 at 1e7bc898
DC390: Start SCSI command: 25 (Sync:01)
DC390: Select wo/DisCn for Cmd 124 (SRB 0000010018e76468), No TagQ
DC390: AutoReqSense !
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
DC390: [1]dc390_DataInPhase(1) (81)
 DC390: Next SG segment.<7> DC390: Start transfer: 0 bytes (address 1e7bc898)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
DC390: DMA Blast aborted unfinished!
Blast: Read 40960 times DMA_Status 00<7>Xfered: -16777198, Total: -16777198, Remaining: 16777198
DC390: [3]dc390_StatusPhase(1) (83)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
DC390: [4]dc390_Nop_0(1) (04)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped sense buffer at 1e7bc898
.. IRQ returned
dc390_pci_map(): Mapped request buffer 0000010000b52e00 at b52e00
DC390: Start SCSI command: 25 (Sync:01)
DC390: Select w/DisCn for Cmd 125 (SRB 0000010018e76468), No TagQ
 ... command (pid 125) queued successfully.
DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
DC390: [3]dc390_StatusPhase(1) (83)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
DC390: [4]dc390_Nop_0(1) (04)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at b52e00
dc390_pci_map(): Mapped sense buffer 000001001e7bc898 at 1e7bc898
DC390: Start SCSI command: 25 (Sync:01)
DC390: Select wo/DisCn for Cmd 125 (SRB 0000010018e76468), No TagQ
DC390: AutoReqSense !
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
DC390: [1]dc390_DataInPhase(1) (81)
 DC390: Next SG segment.<7> DC390: Start transfer: 0 bytes (address 1e7bc898)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
DC390: DMA Blast aborted unfinished!
Blast: Read 40960 times DMA_Status 00<7>Xfered: -16777198, Total: -16777198, Remaining: 16777198
DC390: [3]dc390_StatusPhase(1) (83)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
DC390: [4]dc390_Nop_0(1) (04)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped sense buffer at 1e7bc898
dc390_pci_map(): Mapped request buffer 0000010000b52e00 at b52e00
DC390: Start SCSI command: 25 (Sync:01)
DC390: Select w/DisCn for Cmd 125 (SRB 0000010018e76468), No TagQ
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (83)
DC390: [3]dc390_StatusPhase(1) (83)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
DC390: [4]dc390_Nop_0(1) (04)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at b52e00
dc390_pci_map(): Mapped sense buffer 000001001e7bc898 at 1e7bc898
DC390: Start SCSI command: 25 (Sync:01)
DC390: Select wo/DisCn for Cmd 125 (SRB 0000010018e76468), No TagQ
DC390: AutoReqSense !
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
DC390: [1]dc390_DataInPhase(1) (81)
 DC390: Next SG segment.<7> DC390: Start transfer: 0 bytes (address 1e7bc898)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
DC390: DMA Blast aborted unfinished!
Blast: Read 40960 times DMA_Status 00<7>Xfered: -16777198, Total: -16777198, Remaining: 16777198
DC390: [3]dc390_StatusPhase(1) (83)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
DC390: [4]dc390_Nop_0(1) (04)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped sense buffer at 1e7bc898
.. IRQ returned
sda : READ CAPACITY failed.
sda : status=1, message=00, host=0, driver=08 
sd: sense =  0  0
Non-extended sense class 0 code 0x0
Raw sense data:0x00 0x00 0x00 0x00 
dc390_pci_map(): Mapped request buffer 0000010000b52e00 at b52e00
DC390: Start SCSI command: 1a (Sync:01)
DC390: Select w/DisCn for Cmd 126 (SRB 0000010018e76468), No TagQ
 ... command (pid 126) queued successfully.
DC390: Irq (11) caught: <7>sstatus=81,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=18,<6>DC390: [5]dc390_Nop_0(0) (81)
DC390: [1]dc390_DataInPhase(1) (81)
 DC390: Next SG segment.<7> DC390: Start transfer: 0 bytes (address 00b52e00)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=83,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=10,<6>DC390: [1]dc390_DataIn_0(0) (83)
DC390: DMA Blast aborted unfinished!
Blast: Read 40960 times DMA_Status 00<7>Xfered: -16777212, Total: -16777212, Remaining: 16777212
DC390: [3]dc390_StatusPhase(1) (83)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=87,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=08,<6>DC390: [3]dc390_Status_0(0) (87)
DC390: [4]dc390_Nop_0(1) (04)
.. IRQ returned
DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at b52e00
.. IRQ returned
sda: asking for cache data failed
sda: assuming drive cache: write through
Attached scsi disk sda at scsi5, channel 0, id 4, lun 0
Attached scsi generic sg1 at scsi5, channel 0, id 4, lun 0,  type 0
dc390_pci_map(): Mapped request buffer 0000010000b53e80 at b53e80
DC390: Start SCSI command: 12 (Sync:01)
DC390: Select w/DisCn for Cmd 127 (SRB 0000010018e76468), No TagQ
 ... command (pid 127) queued successfully.
DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at b53e80
.. IRQ returned
dc390_pci_map(): Mapped request buffer 0000010000b53e80 at b53e80
DC390: Start SCSI command: 12 (Sync:01)
DC390: Select w/DisCn for Cmd 128 (SRB 0000010018e76468), No TagQ
 ... command (pid 128) queued successfully.
DC390: Irq (11) caught: <7>sstatus=80,<6>Istatus(Res,Inv,Dis,Serv,Succ,ReS,SelA,Sel)=20,dc390_pci_unmap(): Unmapped request buffer at b53e80
.. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned
DC390: Irq (11) caught: .. IRQ returned

--Boundary-00=_R3QeAf3hjcNeXmi--
