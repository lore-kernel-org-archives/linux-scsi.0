From: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Subject: Adaptec AIC-9410W (AIC94xx) + SATA HDDs
Date: Wed, 26 Mar 2008 15:14:19 +0100
Message-ID: <47EA5A3B.1070200@ipax.at>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000103070904040509090707"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.ipax.at ([80.64.143.40]:54939 "EHLO mail.ipax.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbYCZOOY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Mar 2008 10:14:24 -0400
Received: from [192.168.1.110] (vie-078-142-128-152.dsl.sil.at [78.142.128.152])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ipax.at (Postfix) with ESMTP id AC16047743C
	for <linux-scsi@vger.kernel.org>; Wed, 26 Mar 2008 15:14:21 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000103070904040509090707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

hi,

can anyone point me out, why the adaptec aic-9410W sas controller
detects my sata drive but the kernel does not?

you will find the relevant dmesg parts attached.

cheers,
raoul
-- 
____________________________________________________________________
DI (FH) Raoul Bhatia M.Sc.          email.          r.bhatia@ipax.at
Technischer Leiter

IPAX - Aloy Bhatia Hava OEG         web.          http://www.ipax.at
Barawitzkagasse 10/2/2/11           email.            office@ipax.at
1190 Wien                           tel.               +43 1 3670030
FN 277995t HG Wien                  fax.            +43 1 3670030 15
____________________________________________________________________

--------------000103070904040509090707
Content-Type: text/plain;
 name="no_sata.dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="no_sata.dmesg.txt"

sata_svw 0000:01:0e.0: version 2.3
ACPI: PCI Interrupt 0000:01:0e.0[A] -> GSI 11 (level, low) -> IRQ 11
scsi0 : sata_svw
scsi1 : sata_svw
scsi2 : sata_svw
scsi3 : sata_svw
ata1: SATA max UDMA/133 mmio m8192@0xff2fe000 port 0xff2fe000 irq 11
ata2: SATA max UDMA/133 mmio m8192@0xff2fe000 port 0xff2fe100 irq 11
ata3: SATA max UDMA/133 mmio m8192@0xff2fe000 port 0xff2fe200 irq 11
ata4: SATA max UDMA/133 mmio m8192@0xff2fe000 port 0xff2fe300 irq 11
ata1: SATA link down (SStatus 4 SControl 300)
ata2: SATA link down (SStatus 4 SControl 300)
ata3: SATA link down (SStatus 4 SControl 300)
ata4: SATA link down (SStatus 4 SControl 300)
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
ACPI: PCI Interrupt 0000:03:07.0[A] -> GSI 25 (level, low) -> IRQ 25
aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:03:07.0
scsi4 : aic94xx
aic94xx: BIOS present (1,1), 1820
aic94xx: ue num:2, ue size:88
aic94xx: manuf sect SAS_ADDR 500e08100001b6b8
aic94xx: manuf sect PCBA SN 
aic94xx: ms: no phy parameters found
aic94xx: ms: Creating default phy parameters
aic94xx: ms: num_phy_desc: 8
aic94xx: ms: phy0: ENABLED
aic94xx: ms: phy1: ENABLED
aic94xx: ms: phy2: ENABLED
aic94xx: ms: phy3: ENABLED
aic94xx: ms: phy4: ENABLED
aic94xx: ms: phy5: ENABLED
aic94xx: ms: phy6: ENABLED
aic94xx: ms: phy7: ENABLED
aic94xx: ms: max_phys:0x8, num_phys:0x8
aic94xx: ms: enabled_phys:0xff
aic94xx: ms: no connector map found
aic94xx: ctrla: phy0: sas_addr: 500e08100001b6b8, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy1: sas_addr: 500e08100001b6b8, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy2: sas_addr: 500e08100001b6b8, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy3: sas_addr: 500e08100001b6b8, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy4: sas_addr: 500e08100001b6b8, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy5: sas_addr: 500e08100001b6b8, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy6: sas_addr: 500e08100001b6b8, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy7: sas_addr: 500e08100001b6b8, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: max_scbs:512, max_ddbs:128
aic94xx: setting phy0 addr to 500e08100001b6b8
aic94xx: setting phy1 addr to 500e08100001b6b8
aic94xx: setting phy2 addr to 500e08100001b6b8
aic94xx: setting phy3 addr to 500e08100001b6b8
aic94xx: setting phy4 addr to 500e08100001b6b8
aic94xx: setting phy5 addr to 500e08100001b6b8
aic94xx: setting phy6 addr to 500e08100001b6b8
aic94xx: setting phy7 addr to 500e08100001b6b8
aic94xx: num_edbs:21
aic94xx: num_escbs:3
aic94xx: Found sequencer Firmware version 1.1 (V32A4)
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
aic94xx: First SCB dma_handle: 0x13dca8000
aic94xx: device 0000:03:07.0: SAS addr 500e08100001b6b8, PCBA SN , 8 phys, 8 enabled phys, flash present, BIOS build 1820
aic94xx: posting 3 escbs
aic94xx: escbs posted
aic94xx: posting 8 control phy scbs
aic94xx: control_phy_tasklet_complete: phy5, lrate:0x8, proto:0xe
aic94xx: control_phy_tasklet_complete: phy4, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy4: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 10 00 00 08
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 00 c5 00
aic94xx: 10: 07 92 fb dd
aic94xx: 14: 00 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x10 for phy4
sas: phy-4:4 added to port-4:0, phy_mask:0x10 (5000c5000792fbdd)
sas: DOING DISCOVERY on port 0, pid:956
scsi 4:0:0:0: Direct-Access     SEAGATE  ST373455SS       0002 PQ: 0 ANSI: 5
sas: DONE DISCOVERY on port 0, pid:956, result:0
sas: DONE DISCOVERY on port 0, pid:956, result:0
aic94xx: control_phy_tasklet_complete: phy0: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy1: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy2: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy3: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy6: no device present: oob_status:0x0
aic94xx: control_phy_tasklet_complete: phy7: no device present: oob_status:0x0
aic94xx: escb_tasklet_complete: phy5: BYTES_DMAED
aic94xx: STP proto device-to-host FIS:
aic94xx: 00: 34 00 50 01
aic94xx: 04: 01 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 01 00 00 00
aic94xx: 10: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x20 for phy5
sas: phy-4:5 added to port-4:1, phy_mask:0x20 (500e08100001b6cd)
sas: DOING DISCOVERY on port 1, pid:956
sas: unhandled device 5
sas: DONE DISCOVERY on port 1, pid:956, result:-6
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: ACPI0007:02 is registered as cooling_device2
ACPI: ACPI0007:03 is registered as cooling_device3
Driver 'sd' needs updating - please use bus_type methods
sd 4:0:0:0: [sda] 143374744 512-byte hardware sectors (73408 MB)
sd 4:0:0:0: [sda] Write Protect is off
sd 4:0:0:0: [sda] Mode Sense: b3 00 10 08
sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 4:0:0:0: [sda] 143374744 512-byte hardware sectors (73408 MB)
sd 4:0:0:0: [sda] Write Protect is off
sd 4:0:0:0: [sda] Mode Sense: b3 00 10 08
sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda2 sda3
sd 4:0:0:0: [sda] Attached SCSI disk
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 16 (level, low) -> IRQ 16
e100: eth0: e100_probe: addr 0xff6eb000, irq 16, MAC addr 00:e0:81:4b:5b:4b
tg3.c:v3.87 (December 20, 2007)
ACPI: PCI Interrupt 0000:04:04.0[A] -> GSI 26 (level, low) -> IRQ 26
scsi5 : pata_serverworks
scsi6 : pata_serverworks
ata5: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata6: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
ata5.01: ATAPI: DV-28E-R, 1.8A, max UDMA/33
ata5.01: configured for UDMA/33
scsi 5:0:1:0: CD-ROM            TEAC     DV-28E-R         1.8A PQ: 0 ANSI: 5
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
...
sd 4:0:0:0: Attached scsi generic sg0 type 0
scsi 5:0:1:0: Attached scsi generic sg1 type 5
...


--------------000103070904040509090707--
