From: "Right Effort" <righteffort@fastmail.fm>
Subject: Promise PDC20319 & Intel FWE6300ESB on PSCH-L: Which device?
Date: Thu, 31 Aug 2006 19:51:37 +0800
Message-ID: <1157025097.30407.269844897@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59883 "EHLO
	out1.smtp.messagingengine.com") by vger.kernel.org with ESMTP
	id S932120AbWHaLvi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 07:51:38 -0400
Received: from frontend3.internal (frontend3.internal [10.202.2.152])
	by frontend1.messagingengine.com (Postfix) with ESMTP id 49F35D9E0C4
	for <linux-scsi@vger.kernel.org>; Thu, 31 Aug 2006 07:51:37 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!

I have got no effective answer for my question from other lists
including the original hardware manufacturer. This list is my last
resort.

The main board's model name is PSCH-L from Asus. It glues two chips: 

Promise PDC20319 controlling 4 SATA slots for hard disks. 
Intel FWE6300ESB controlling 2 SATA slots for hard disks. 

The board also burns a firmware called FastTrak or FastBuild which
manages the Promise chip I guess. 

My problem is that I can't find the devices controlled by either of the
two chips:

# fdisk /dev/sda 

Unable to open /dev/sda 

Same to /dev/sdb, sdc, sdd, sde, etc... 

Drivers "Promise SATA SX4" and "ata-piix/ICH" are compiled in the boot
kernel. This is the excerpt from the output of dmesg: 
=====BEGIN===========
Linux version 2.6.14.3 (root@develop.internal.com) (gcc version 2.95.4
20011002 (Debian prerelease)) #2 PREEMPT Sat Aug 5 02:31:01 CST 2006

[snip]

Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with
idebus=xx
Probing IDE interface ide0...
hda: Maxtor 91021U2, ATA DISK drive
hdb: Maxtor 91021U2, ATA DISK drive
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 128KiB
hda: 20010816 sectors (10245 MB) w/512KiB Cache, CHS=19852/16/63
hda: cache flushes not supported
 hda: hda1
hdb: max request size: 128KiB
hdb: 20010816 sectors (10245 MB) w/512KiB Cache, CHS=19852/16/63
hdb: cache flushes not supported
 hdb: hdb1
libata version 1.12 loaded.
sata_promise version 1.02
PCI: Hardcoded IRQ 9 for device 0000:02:05.0
ata1: SATA max UDMA/133 cmd 0xF8800200 ctl 0xF8800238 bmdma 0x0 irq 9
ata2: SATA max UDMA/133 cmd 0xF8800280 ctl 0xF88002B8 bmdma 0x0 irq 9
ata3: SATA max UDMA/133 cmd 0xF8800300 ctl 0xF8800338 bmdma 0x0 irq 9
ata4: SATA max UDMA/133 cmd 0xF8800380 ctl 0xF88003B8 bmdma 0x0 irq 9
ata1: dev 0 cfg 49:2f00 82:7c6b 83:7b09 84:4003 85:7c69 86:3a01 87:4003
88:407f
ata1: dev 0 ATA, max UDMA/133, 240121728 sectors:
ata1: dev 0 configured for UDMA/133
scsi0 : sata_promise
ata2: dev 0 cfg 49:2f00 82:7c6b 83:7b09 84:4003 85:7c69 86:3a01 87:4003
88:407f
ata2: dev 0 ATA, max UDMA/133, 240121728 sectors:
ata2: dev 0 configured for UDMA/133
scsi1 : sata_promise
ata3: dev 0 cfg 49:2f00 82:7c6b 83:7b09 84:4003 85:7c69 86:3a01 87:4003
88:407f
ata3: dev 0 ATA, max UDMA/133, 240121728 sectors:
ata3: dev 0 configured for UDMA/133
scsi2 : sata_promise
ata4: dev 0 cfg 49:2f00 82:7c6b 83:7b09 84:4003 85:7c69 86:3a01 87:4003
88:407f
ata4: dev 0 ATA, max UDMA/133, 240121728 sectors:
ata4: dev 0 configured for UDMA/133
scsi3 : sata_promise
  Vendor: ATA       Model: Maxtor 6Y120M0    Rev: YAR5
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: ATA       Model: Maxtor 6Y120M0    Rev: YAR5
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: ATA       Model: Maxtor 6Y120M0    Rev: YAR5
  Type:   Direct-Access                      ANSI SCSI revision: 05
  Vendor: ATA       Model: Maxtor 6Y120M0    Rev: YAR5
  Type:   Direct-Access                      ANSI SCSI revision: 05
=====END===========

"fdisk -l" lists nothing except /dev/hda1. 

Where are the right /dev/ for these SATA disks? Your helps are much
appreciated. 

Regards, 

CN

-- 
http://www.fastmail.fm - Faster than the air-speed velocity of an
                          unladen european swallow

