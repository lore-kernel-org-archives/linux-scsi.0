From: Andrei Loukinykh <avl@seavenue.net>
Subject: ide-scsi fails with kernels > 2.4.1
Date: Thu, 30 Jan 2003 10:47:49 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.20.0301301047240.24862-100000@users.evp.sf.ukrtel.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from users.evp.sf.ukrtel.net (users.evp.sf.ukrtel.net [195.5.3.162])
	by users.evp.sf.ukrtel.net (8.11.5/8.11.5) with ESMTP id h0U8lnn27405
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2003 10:47:49 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


 Hi all
  Being a sort of god damn tired (sorry), i decided to ask here

 In short:
   My CDRW refuses to work with any kernel bigger than 2.4.1.

It is IDE-CDRW . I use ide-scsi driver for this.
With 2.4.1 - all o'k.
 Then I tried 2.4.7 ... 2.4.9 ... 2.4.19.. 2.4.20 ( i dont remember al of
them) - none works. I get the following:

hdc: SAMSUNG CD-R/RW SW-408B, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
blk: queue c030e544, I/O limit 4095Mb (mask 0xffffffff)
hda: 12672450 sectors (6488 MB), CHS=788/255/63, UDMA(33)
hdc: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
hdc: set_drive_speed_status: error=0x04


Someone please help
 I desperately need 2.4.20 for my devices to work, but I also need CDR..



Best regards,
Andrei V. Loukinykh , Evpatoria Ukrtelecom ISP, +380 6569 29376
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"UNIX is like a vigvam - no Windows, no Gates and an Apache inside"




