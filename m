From: Jurgen Kramer <gtm.kramer@inter.nl.net>
Subject: 3w-9xxx no read cache?
Date: Fri, 02 Jul 2004 20:39:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1088793581.11320.10.camel@paragon.slim>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from slimnet.xs4all.nl ([194.109.194.192]:43981 "EHLO slimnas.slim")
	by vger.kernel.org with ESMTP id S264900AbUGBSiB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2004 14:38:01 -0400
Received: from [192.168.100.26] (paragon.slim [192.168.100.26])
	by slimnas.slim (8.12.8/8.12.8) with ESMTP id i62I8Xug031950
	for <linux-scsi@vger.kernel.org>; Fri, 2 Jul 2004 20:08:33 +0200
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI List <linux-scsi@vger.kernel.org>

When inserting the 3ware 9000 kernel module the
output messages suggest there's now read cache. Is this correct?

3ware 9000 Storage Controller device driver for Linux v2.26.00.009fw.
3w-9xxx: scsi5: Found a 3ware 9000 Storage Controller at 0xfeaff400,
IRQ: 22.
3w-9xxx: scsi5: Firmware FE9X 2.02.00.011, BIOS BE9X 2.02.01.037, Ports:
4.
scsi5 : 3ware 9000 Storage Controller
  Vendor: 3ware     Model: Logical Disk 00   Rev: 1.00
  Type:   Direct-Access                      ANSI SCSI revision: 00
SCSI device sdf: 937433088 512-byte hdwr sectors (479966 MB)
SCSI device sdf: drive cache: write back, no read (daft)
 sdf: sdf1
Attached scsi disk sdf at scsi5, channel 0, id 0, lun 0

Jurgen


