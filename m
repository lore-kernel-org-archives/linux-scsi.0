From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Date: Tue, 24 Jun 2008 18:59:55 +0200
Message-ID: <8db1092f0806240959x3a811942s673f344e0967a5fa@mail.gmail.com>
References: <804dabb00806232025m31ba0826lbddac040428e974f@mail.gmail.com>
	 <Pine.LNX.4.44L0.0806241057430.2160-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:26037 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbYFXQ75 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jun 2008 12:59:57 -0400
Received: by py-out-1112.google.com with SMTP id p76so1428062pyb.10
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2008 09:59:56 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.0806241057430.2160-100000@iolanthe.rowland.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Teoh <htmldeveloper@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

2008/6/24 Alan Stern <stern@rowland.harvard.edu>:

>
> How about you, Maciej?  I want to make sure it fixes your problem too
> before submitting the patch.
>

Works great on 2.6.26-rc7:

usb 3-1: new high speed USB device using ehci_hcd and address 4
usb 3-1: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi2 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
USB Mass Storage support registered.
scsi 2:0:0:0: Direct-Access     Initio   MHV2080BH PL     3.01 PQ: 0 ANSI: 0
usb-storage: device scan complete
Driver 'sd' needs updating - please use bus_type methods
sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 00 00 00
sd 2:0:0:0: [sda] Assuming drive cache: write through
sd 2:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 00 00 00
sd 2:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1
sd 2:0:0:0: [sda] Attached SCSI disk

maciek@zlom:~$ ntfsmount /dev/sda1 ~/mnt/ntfs/
maciek@zlom:~$ mount | grep sda1
/dev/sda1 on /home/maciek/mnt/ntfs type fuseblk
(rw,nosuid,nodev,default_permissions,allow_other,blksize=4096,user=maciek)

Thanks very much :-)

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
