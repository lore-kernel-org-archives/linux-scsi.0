From: Markus Rathgeb <maggu2810@gmail.com>
Subject: Re: [PATCH] USB: storage: add "no SYNCHRONIZE CACHE" quirk
Date: Mon, 22 Jun 2015 23:32:14 +0200
Message-ID: <CAOcK=CPhLSG4FKB=KngqTdASWj3VEa=hf-gznYA6O3KfcZ=eNA@mail.gmail.com>
References: <CAOcK=COj7=akJUhsg2Pfr5aeh_tC9dEL3rZK1yKuvTN0KyJB1A@mail.gmail.com>
	<Pine.LNX.4.44L0.1506221615390.1799-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33616 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbbFVVcP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2015 17:32:15 -0400
In-Reply-To: <Pine.LNX.4.44L0.1506221615390.1799-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Greg KH <greg@kroah.com>, James Bottomley <JBottomley@parallels.com>, Jun Itou <itou_jun@infoseek.jp>, Matt <vickm78@hotmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

> Please test it now.  I'd like to know if it fixes your problem,
> regardless of how the discussion goes.

Seems to be working, I also attached the kernel log.
The "flush failed" will grow with disc activity (but that was to be expected).

Jun 22 23:24:50 m3800 kernel: usb 1-3: new high-speed USB device
number 6 using xhci_hcd
Jun 22 23:24:51 m3800 kernel: usb 1-3: New USB device found,
idVendor=04cf, idProduct=8818
Jun 22 23:24:51 m3800 kernel: usb 1-3: New USB device strings: Mfr=1,
Product=2, SerialNumber=3
Jun 22 23:24:51 m3800 kernel: usb 1-3: Product: USB Mass Storage Device
Jun 22 23:24:51 m3800 kernel: usb 1-3: Manufacturer: Myson Century, Inc.
Jun 22 23:24:51 m3800 kernel: usb 1-3: SerialNumber: 100
Jun 22 23:24:51 m3800 kernel: usb-storage 1-3:1.0: USB Mass Storage
device detected
Jun 22 23:24:51 m3800 kernel: scsi host6: usb-storage 1-3:1.0
Jun 22 23:24:51 m3800 kernel: usbcore: registered new interface driver
usb-storage
Jun 22 23:24:52 m3800 kernel: scsi 6:0:0:0: Direct-Access     SAMSUNG
MP0804H          UE10 PQ: 0 ANSI: 0 CCS
Jun 22 23:24:52 m3800 kernel: sd 6:0:0:0: Attached scsi generic sg1 type 0
Jun 22 23:24:52 m3800 kernel: sd 6:0:0:0: [sdb] 156368016 512-byte
logical blocks: (80.0 GB/74.5 GiB)
Jun 22 23:24:52 m3800 kernel: sd 6:0:0:0: [sdb] Write Protect is off
Jun 22 23:24:52 m3800 kernel: sd 6:0:0:0: [sdb] Mode Sense: 00 14 00 00
Jun 22 23:24:52 m3800 kernel: sd 6:0:0:0: [sdb] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Jun 22 23:24:52 m3800 kernel:  sdb: sdb1 sdb2
Jun 22 23:24:52 m3800 kernel: sd 6:0:0:0: [sdb] Attached SCSI disk
Jun 22 23:24:52 m3800 kernel: BTRFS: device label USB_BILDER devid 1
transid 9 /dev/sdb2
Jun 22 23:24:52 m3800 kernel: BTRFS info (device sdb2): disk space
caching is enabled
Jun 22 23:24:52 m3800 kernel: BTRFS: has skinny extents
Jun 22 23:24:52 m3800 kernel: FAT-fs (sdb1): Volume was not properly
unmounted. Some data may be corrupt. Please run fsck.
Jun 22 23:25:28 m3800 kernel: sdb: flush failed: data integrity problem
Jun 22 23:25:28 m3800 kernel: sdb: flush failed: data integrity problem
Jun 22 23:26:55 m3800 kernel: sdb: flush failed: data integrity problem
Jun 22 23:26:55 m3800 kernel: sdb: flush failed: data integrity problem
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
