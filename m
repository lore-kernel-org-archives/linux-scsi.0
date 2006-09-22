From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: [Bugme-new] [Bug 7180] New: aic94xx driver locks up on IBM
	x366 with Calgary IOMMU enabled
Date: Fri, 22 Sep 2006 17:26:40 -0500
Message-ID: <1158964000.3445.59.camel@mulgrave.il.steeleye.com>
References: <20060921182350.55cb2816.akpm@osdl.org>
	 <20060922060504.GD16501@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:35549 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965212AbWIVW1A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 18:27:00 -0400
In-Reply-To: <20060922060504.GD16501@rhun.haifa.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Andi Kleen <ak@muc.de>, alexisb@us.ibm.com, djwong@us.ibm.com, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, Jon Mason <jdmason@gmail.com>

On Fri, 2006-09-22 at 09:05 +0300, Muli Ben-Yehuda wrote:
> Thanks Andrew, we're looking into it.

Just to add to the complexity, this seems to be working for me on a maia
system with aic94xx boot drives

James

-----

PCI-DMA: Calgary IOMMU detected. TCE table spec is 6.
[...]
PCI-DMA: Using Calgary IOMMU
Calgary: enabling translation on PHB 0
Calgary: errant DMAs will now be prevented on this bus.
Calgary: enabling translation on PHB 1
Calgary: errant DMAs will now be prevented on this bus.
[...]
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.2 loaded
GSI 16 sharing vector 0xA9 and IRQ 16
ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 25 (level, low) -> IRQ 16
aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:01:02.0
scsi0 : aic94xx
aic94xx: BIOS present (1,1), 1548
aic94xx: ue num:1, ue size:88
aic94xx: 1Found FLASH(8) manuf:1, dev_id:0xda, sec_prot:0
aic94xx: manuf sect SAS_ADDR 5005076a0115a840
aic94xx: manuf sect PCBA SN 
aic94xx: ms: num_phy_desc: 8
aic94xx: ms: phy0: ENEBLEABLE
aic94xx: ms: phy1: ENEBLEABLE
aic94xx: ms: phy2: ENEBLEABLE
aic94xx: ms: phy3: ENEBLEABLE
aic94xx: ms: phy4: ENEBLEABLE
aic94xx: ms: phy5: ENEBLEABLE
aic94xx: ms: phy6: ENEBLEABLE
aic94xx: ms: phy7: ENEBLEABLE
aic94xx: ms: max_phys:0x8, num_phys:0x8
aic94xx: ms: enabled_phys:0xff
aic94xx: ctrla: phy0: sas_addr: 5005076a0115a840, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy1: sas_addr: 5005076a0115a840, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy2: sas_addr: 5005076a0115a840, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy3: sas_addr: 5005076a0115a840, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy4: sas_addr: 5005076a0115a840, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy5: sas_addr: 5005076a0115a840, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy6: sas_addr: 5005076a0115a840, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy7: sas_addr: 5005076a0115a840, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: max_scbs:512, max_ddbs:128
aic94xx: setting phy0 addr to 5005076a0115a840
aic94xx: setting phy1 addr to 5005076a0115a840
aic94xx: setting phy2 addr to 5005076a0115a840
aic94xx: setting phy3 addr to 5005076a0115a840
aic94xx: setting phy4 addr to 5005076a0115a840
aic94xx: setting phy5 addr to 5005076a0115a840
aic94xx: setting phy6 addr to 5005076a0115a840
aic94xx: setting phy7 addr to 5005076a0115a840
aic94xx: num_edbs:21
aic94xx: num_escbs:3
aic94xx: using sequencer V17/10c6
aic94xx: downloading CSEQ...
aic94xx: dma-ing 8192 bytes
aic94xx: verified 8192 bytes, passed
aic94xx: downloading LSEQs...
aic94xx: dma-ing 14336 bytes
aic94xx: LSEQ0 verified 14336 bytes, passed
aic94xx: LSEQ1 verified 14336 bytes, passed
aic94xx: LSEQ2 verified 14336 bytes, passed
aic94xx: LSEQ3 verified 14336 bytes, passed
aic94xx: LSEQ4 verified 14336 bytes, passed
aic94xx: LSEQ5 verified 14336 bytes, passed
aic94xx: LSEQ6 verified 14336 bytes, passed
aic94xx: LSEQ7 verified 14336 bytes, passed
aic94xx: max_scbs:446
aic94xx: first_scb_site_no:0x20
aic94xx: last_scb_site_no:0x1fe
aic94xx: First SCB dma_handle: 0x9000
aic94xx: device 0000:01:02.0: SAS addr 5005076a0115a840, PCBA SN , 8 phys, 8 enabled phys, flash present, BIOS build 1548
aic94xx: posting 3 escbs
aic94xx: escbs posted
aic94xx: posting 8 control phy scbs
aic94xx: enabled phys
aic94xx: control_phy_tasklet_complete: phy4, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy4: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 05 07 6a
aic94xx: 10: 00 00 2c 50
aic94xx: 14: 03 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: control_phy_tasklet_complete: phy0, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy0: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 05 07 6a
aic94xx: 10: 00 00 06 20
aic94xx: 14: 03 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: control_phy_tasklet_complete: phy1, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy1: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 05 07 6a
aic94xx: 10: 00 00 06 20
aic94xx: 14: 04 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: control_phy_tasklet_complete: phy6, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy6: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 05 07 6a
aic94xx: 10: 00 00 2c 50
aic94xx: 14: 07 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: control_phy_tasklet_complete: phy2, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy2: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 05 07 6a
aic94xx: 10: 00 00 06 20
aic94xx: 14: 07 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: control_phy_tasklet_complete: phy7, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy7: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 05 07 6a
aic94xx: 10: 00 00 2c 50
aic94xx: 14: 08 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: control_phy_tasklet_complete: phy3, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy3: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 05 07 6a
aic94xx: 10: 00 00 06 20
aic94xx: 14: 08 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: control_phy_tasklet_complete: phy5, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy5: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 05 07 6a
aic94xx: 10: 00 00 2c 50
aic94xx: 14: 04 00 00 00
aic94xx: 18: 00 00 00 00
sas: phy4 added to port0, phy_mask:0x10
sas: phy0 added to port1, phy_mask:0x1
sas: phy1 matched wide port1
sas: phy1 added to port1, phy_mask:0x3
sas: phy6 matched wide port0
sas: phy6 added to port0, phy_mask:0x50
sas: phy2 matched wide port1
sas: phy2 added to port1, phy_mask:0x7
sas: phy7 matched wide port0
sas: phy7 added to port0, phy_mask:0xd0
sas: phy3 matched wide port1
sas: phy3 added to port1, phy_mask:0xf
sas: phy5 matched wide port0
sas: phy5 added to port0, phy_mask:0xf0
sas: DOING DISCOVERY on port 0, pid:869
sas: ex 5005076a00002c50 phy00:D attached: 50010b9000001369
sas: ex 5005076a00002c50 phy01:T attached: 0000000000000000
sas: ex 5005076a00002c50 phy02:T attached: 0000000000000000
sas: ex 5005076a00002c50 phy03:S attached: 5005076a0115a840
sas: ex 5005076a00002c50 phy04:S attached: 5005076a0115a840
sas: ex 5005076a00002c50 phy05:T attached: 0000000000000000
sas: ex 5005076a00002c50 phy06:T attached: 0000000000000000
sas: ex 5005076a00002c50 phy07:S attached: 5005076a0115a840
sas: ex 5005076a00002c50 phy08:S attached: 5005076a0115a840
sas: ex 5005076a00002c50 phy09:T attached: 0000000000000000
sas: ex 5005076a00002c50 phy10:T attached: 0000000000000000
sas: ex 5005076a00002c50 phy11:T attached: 0000000000000000
sas: ex 5005076a00002c50 phy12:D attached: 5005076a00002c5d
scsi 0:0:0:0: Direct access     IBM-ESXS BBA036C3ESTT0Z N BH06 PQ: 0 ANSI: 5
SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
sda: Write Protect is off
sda: Mode Sense: d3 00 10 08
SCSI device sda: drive cache: write through w/ FUA
SCSI device sda: 71096640 512-byte hdwr sectors (36401 MB)
sda: Write Protect is off
sda: Mode Sense: d3 00 10 08
SCSI device sda: drive cache: write through w/ FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
scsi 0:0:1:0: Enclosure         IBM-ESXS VSC7160          1.01 PQ: 0 ANSI: 3
sas: device 5005076a00002c5d, LUN 0 doesn't support TCQ
sas: DONE DISCOVERY on port 0, pid:869, result:0
sas: DOING DISCOVERY on port 1, pid:869
sas: ex 5005076a00000620 phy00:T attached: 0000000000000000
sas: ex 5005076a00000620 phy01:T attached: 0000000000000000
sas: ex 5005076a00000620 phy02:T attached: 0000000000000000
sas: ex 5005076a00000620 phy03:S attached: 5005076a0115a840
sas: ex 5005076a00000620 phy04:S attached: 5005076a0115a840
sas: ex 5005076a00000620 phy05:T attached: 0000000000000000
sas: ex 5005076a00000620 phy06:T attached: 0000000000000000
sas: ex 5005076a00000620 phy07:S attached: 5005076a0115a840
sas: ex 5005076a00000620 phy08:S attached: 5005076a0115a840
sas: ex 5005076a00000620 phy09:T attached: 0000000000000000
sas: ex 5005076a00000620 phy10:T attached: 0000000000000000
sas: ex 5005076a00000620 phy11:T attached: 0000000000000000
sas: ex 5005076a00000620 phy12:D attached: 5005076a0000062d
scsi 0:0:2:0: Enclosure         IBM-ESXS VSC7160          1.01 PQ: 0 ANSI: 3
sas: device 5005076a0000062d, LUN 0 doesn't support TCQ
sas: DONE DISCOVERY on port 1, pid:869, result:0


