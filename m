From: "Bhanu, Yogesh" <yogesh@gsf.de>
Subject: RE: aic7xxx   slowness on 2.6.13
Date: Wed, 7 Sep 2005 14:09:14 +0200
Message-ID: <8306780C060A7D4790F8BA02CBA1B6910A949B@sw-rz010.gsf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta2.gsf.de ([146.107.4.111]:30389 "EHLO mta2.gsf.de")
	by vger.kernel.org with ESMTP id S1751205AbVIGMJW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 08:09:22 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: linux-scsi@vger.kernel.org

Hi Mathias ,
                   Sorry about this, I should have put this in first place .  Also these are two kernel versions .
I had big issues with adaptec drivers in kernel 2.6.11 and so I had switched to symbios card which I was using 
till the weekend.
 
hth
yogesh
 
 
Symbios kern messages  (kernel 2.6.12.2)
 sym0: <895> rev 0x2 at pci 0000:03:09.0 irq 27
 sym0: Symbios NVRAM, ID 15, Fast-40, LVD, parity checking
 sym0: open drain IRQ line driver, using on-chip SRAM
 sym0: using LOAD/STORE-based firmware.
 sym0: SCSI BUS has been reset.
 scsi1 : sym-2.2.0
   Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327I
   Type:   Direct-Access                      ANSI SCSI revision: 04
  target1:0:1: tagged command queuing enabled, command queue depth 16.
  target1:0:1: Beginning Domain Validation
  target1:0:1: asynchronous.
 WIDTH IS 1
  1:0:1:0: ODD transfer in DATA IN phase.
  1:0:1:0: COMMAND FAILED (87 0 10).
  target1:0:1: Wide Transfers Fail
  target1:0:1: asynchronous.
  target1:0:1: Domain Validation skipping write tests
  target1:0:1: FAST-40 SCSI 40.0 MB/s ST (25 ns, offset 31)
  target1:0:1: Ending Domain Validation
 SCSI device sdb: 3148468224 512-byte hdwr sectors (1612016 MB)
 SCSI device sdb: drive cache: write through
 SCSI device sdb: 3148468224 512-byte hdwr sectors (1612016 MB)
 SCSI device sdb: drive cache: write through
  sdb: sdb1 sdb2 < sdb5 >
 Attached scsi disk sdb at scsi1, channel 0, id 1, lun 0
 Attached scsi generic sg2 at scsi1, channel 0, id 1, lun 0,  type 0
   Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327I
   Type:   Direct-Access                      ANSI SCSI revision: 04
  target1:0:1: tagged command queuing enabled, command queue depth 16.
 SCSI device sdc: 2927063040 512-byte hdwr sectors (1498656 MB)
 SCSI device sdc: drive cache: write through
 SCSI device sdc: 2927063040 512-byte hdwr sectors (1498656 MB)
 SCSI device sdc: drive cache: write through
  sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 sdc8 >
 Attached scsi disk sdc at scsi1, channel 0, id 1, lun 1
 Attached scsi generic sg3 at scsi1, channel 0, id 1, lun 1,  type 0
   Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327I
   Type:   Direct-Access                      ANSI SCSI revision: 04
  target1:0:1: tagged command queuing enabled, command queue depth 16.
 SCSI device sdd: 585412608 512-byte hdwr sectors (299731 MB)
 SCSI device sdd: drive cache: write through
 SCSI device sdd: 585412608 512-byte hdwr sectors (299731 MB)
 SCSI device sdd: drive cache: write through
  sdd: sdd1

 
 
 
Adaptec kernel messages  (kernel 2.6.13)
ACPI: PCI Interrupt 0000:03:08.0[A] -> GSI 24 (level, low) -> IRQ 22

scsi2 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36

        <Adaptec 3960D Ultra160 SCSI adapter>

        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

 

  Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327I

  Type:   Direct-Access                      ANSI SCSI revision: 04

 target2:0:1: asynchronous.

scsi2:A:1:0: Tagged Queuing enabled.  Depth 2

 target2:0:1: Beginning Domain Validation

 target2:0:1: wide asynchronous.

 target2:0:1: Domain Validation skipping write tests

 target2:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)

 target2:0:1: Ending Domain Validation

SCSI device sdb: 3148468224 512-byte hdwr sectors (1612016 MB)

SCSI device sdb: drive cache: write through

SCSI device sdb: 3148468224 512-byte hdwr sectors (1612016 MB)

SCSI device sdb: drive cache: write through

 sdb: sdb1 sdb2 < sdb5 >

Attached scsi disk sdb at scsi2, channel 0, id 1, lun 0

Attached scsi generic sg2 at scsi2, channel 0, id 1, lun 0,  type 0

  Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327I

  Type:   Direct-Access                      ANSI SCSI revision: 04

scsi2:A:1:1: Tagged Queuing enabled.  Depth 2

SCSI device sdc: 2927063040 512-byte hdwr sectors (1498656 MB)

SCSI device sdc: drive cache: write through

SCSI device sdc: 2927063040 512-byte hdwr sectors (1498656 MB)

SCSI device sdc: drive cache: write through

 sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 sdc8 >

Attached scsi disk sdc at scsi2, channel 0, id 1, lun 1

Attached scsi generic sg3 at scsi2, channel 0, id 1, lun 1,  type 0

  Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327I

  Type:   Direct-Access                      ANSI SCSI revision: 04

scsi2:A:1:2: Tagged Queuing enabled.  Depth 2

SCSI device sdd: 585412608 512-byte hdwr sectors (299731 MB)

SCSI device sdd: drive cache: write through

SCSI device sdd: 585412608 512-byte hdwr sectors (299731 MB)

SCSI device sdd: drive cache: write through

 sdd: sdd1

Attached scsi disk sdd at scsi2, channel 0, id 1, lun 2

Attached scsi generic sg4 at scsi2, channel 0, id 1, lun 2,  type 0

 

 

 

 
