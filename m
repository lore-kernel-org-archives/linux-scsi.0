From: Micah Anderson <micah@riseup.net>
Subject: Cannot get device recognized on a megaraid
Date: Mon, 24 Nov 2003 10:30:35 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031124163035.GK4399@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.riseup.net ([216.162.217.191]:34983 "EHLO mail.riseup.net")
	by vger.kernel.org with ESMTP id S263766AbTKXQal (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 11:30:41 -0500
Received: from pond (adsl-68-73-117-216.dsl.emhril.ameritech.net [68.73.117.216])
	(using TLSv1 with cipher EDH-RSA-DES-CBC3-SHA (168/168 bits))
	(No client certificate requested)
	by mail.riseup.net (Postfix) with ESMTP id 27694711D9
	for <linux-scsi@vger.kernel.org>; Mon, 24 Nov 2003 08:30:40 -0800 (PST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I've been fighting a megaraid card with one device, just trying to get
it recognized. The card has the latest bios, the drive is in a RAID 0
container. Boot up doesn't show it at all:

 megaraid: no BIOS enabled.
 
 There are two other scsi devices that we have on the machine, they are
 recognized fine:
 
 Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
 Attached scsi disk sdb at scsi1, channel 0, id 2, lun 0
 SCSI device sda: 17783240 512-byte hdwr sectors (9105 MB)
 Partition check:
  sda: sda1 sda2 sda3 sda4
 sym53c875-0-<2,*>: FAST-20 SCSI 20.0 MB/s (50.0 ns, offset 15)
 SCSI device sdb: 8888924 512-byte hdwr sectors (4551 MB)
  sdb: sdb1

What do we need to do to get the drive attached to the megaraid card
recognized? 

Thanks,
micah


 
