From: Matthew Schumacher <matt.s@aptalaska.net>
Subject: Problems getting linux-2.4.31 to detect logical drive on megaraid
 ATA card.
Date: Fri, 04 Nov 2005 00:05:15 -0900
Message-ID: <436B244B.8040506@aptalaska.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from larry.aptalaska.net ([64.186.96.3]:25504 "EHLO
	larry.aptalaska.net") by vger.kernel.org with ESMTP
	id S1161114AbVKDJFR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Nov 2005 04:05:17 -0500
Received: from [192.168.98.9] (rdbck-static-287.palmer.mtaonline.net [64.4.232.33])
	(authenticated bits=0)
	by larry.aptalaska.net (8.13.4/8.13.4) with ESMTP id jA495FtM025611
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 4 Nov 2005 00:05:16 -0900
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

List,

I have a problem I just can't seem to figure out. linux 2.4.27 can see
the logical drive just fine:

megaraid: v2.10.3 (Release Date: Thu Apr  8 16:16:05 EDT 2004)
megaraid: found 0x101e:0x1960:bus 0:slot 3:func 0
scsi0:Found MegaRAID controller at 0xf89c3000, IRQ:17
megaraid: [6.62:1.03] detected 1 logical drives.
megaraid: supports extended CDBs.
megaraid: channel[0] is raid.
megaraid: channel[1] is raid.
megaraid: channel[2] is raid.
megaraid: channel[3] is raid.
scsi0 : LSI Logic MegaRAID 6.62 254 commands 16 targs 7 chans 7 luns
scsi0: scanning scsi channel 0 for logical drives.
  Vendor: MegaRAID  Model: LD 0 RAID1  114G  Rev: 6.62
  Type:   Direct-Access                      ANSI SCSI revision: 02
scsi0: scanning scsi channel 1 for logical drives.
scsi0: scanning scsi channel 2 for logical drives.
scsi0: scanning scsi channel 4 [P0] for physical devices.
scsi0: scanning scsi channel 5 [P1] for physical devices.
scsi0: scanning scsi channel 6 [P2] for physical devices.
scsi0: scanning scsi channel 7 [P3] for physical devices.
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sda: 234348544 512-byte hdwr sectors (119986 MB)
Partition check:
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 >
usb.c: registered new driver usbdevfs

However linux-2.4.31 doesn't see it:

SCSI subsystem driver Revision: 1.00
megaraid: v2.10.8.2 (Release Date: Mon Jul 26 12:15:51 EDT 2004)
megaraid: found 0x101e:0x1960:bus 0:slot 3:func 0
scsi0:Found MegaRAID controller at 0xf8855000, IRQ:15
megaraid: [6.62:1.03] detected 1 logical drives.
megaraid: supports extended CDBs.
megaraid: channel[0] is raid.
megaraid: channel[1] is raid.
megaraid: channel[2] is raid.
megaraid: channel[3] is raid.
scsi0 : LSI Logic MegaRAID 6.62 254 commands 16 targs 7 chans 7 luns
scsi0: scanning scsi channel 0 for logical drives.
scsi0: scanning scsi channel 1 for logical drives.
scsi0: scanning scsi channel 2 for logical drives.
scsi0: scanning scsi channel 3 for logical drives.
scsi0: scanning scsi channel 4 [P0] for physical devices.
scsi0: scanning scsi channel 5 [P1] for physical devices.
scsi0: scanning scsi channel 6 [P2] for physical devices.
scsi0: scanning scsi channel 7 [P3] for physical devices.

The card is a LSI ATA megaraid controller sold by dell as a CERT card.
I have the latest firmware on it.

At this point I'm not sure what to do.  Any ideas on how to make the
newer megaraid driver see the logical drive?

schu
