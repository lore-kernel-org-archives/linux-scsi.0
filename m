From: Shanker Balan <shanu@exocore.com>
Subject: Re: aic7xxx: SCSI Bus Reset
Date: Thu, 26 Dec 2002 11:04:23 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021226053423.GA727@exocore.com>
References: <20021224112158.GA667@exocore.com> <2149895408.1040745297@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from godzilla.exocore.com (PPP-219-65-145-218.bng.vsnl.net.in [219.65.145.218])
	(authenticated)
	by premium.exocore.com (8.11.6/8.11.6) with ESMTP id gBQ5YWp27888
	for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2002 11:04:33 +0530
Content-Disposition: inline
In-Reply-To: <2149895408.1040745297@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>

Hello:

Justin T. Gibbs wrote,

> Can you provide the firmware revisions of these drives.  Anything less
> than B440 is suspect.  The behavior your report looks like the drives
> stop returning queued I/O.  I have seen this before on at least B120,
> although it was when running at U320/packetized and not U160.  My
> guess is that the bug in these early firmware revs is protocol
> agnostic.

Ok, here is a snip from dmesg:

SCSI subsystem driver Revision: 1.00
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.8
        <Adaptec 29160 Ultra160 SCSI adapter>
        aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
blk: queue c256e218, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: QUANTUM   Model: ATLAS10K3_18_SCA  Rev: 020W
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue dfd8be18, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: QUANTUM   Model: ATLAS10K3_73_SCA  Rev: 020W
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue dfd8ba18, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: QUANTUM   Model: ATLAS10K3_73_SCA  Rev: 020W
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue dfd8b618, I/O limit 4095Mb (mask 0xffffffff)
scsi0:A:0:0: Tagged Queuing enabled.  Depth 253
scsi0:A:1:0: Tagged Queuing enabled.  Depth 253
scsi0:A:2:0: Tagged Queuing enabled.  Depth 253
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi0, channel 0, id 1, lun 0
Attached scsi disk sdc at scsi0, channel 0, id 2, lun 0
(scsi0:A:0): 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
SCSI device sda: 35916548 512-byte hdwr sectors (18389 MB)
Partition check:
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
(scsi0:A:1): 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
SCSI device sdb: 143666192 512-byte hdwr sectors (73557 MB)
 sdb: sdb1 sdb2 sdb3
(scsi0:A:2): 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
SCSI device sdc: 143666192 512-byte hdwr sectors (73557 MB)
 sdc: sdc1 sdc2 sdc3

-- Shanu
http://shankerbalan.com/


-- 
It's a good thing we don't get all the government we pay for.
