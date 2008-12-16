From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12240] Disk errors sometimes ignored from the USB-SCSI layer
Date: Tue, 16 Dec 2008 13:22:38 -0800 (PST)
Message-ID: <20081216212238.AC55411D107@picon.linux-foundation.org>
References: <bug-12240-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322AbYLPVWl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2008 16:22:41 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mBGLMc25026374
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2008 13:22:39 -0800
In-Reply-To: <bug-12240-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12240





------- Comment #1 from kernel@roestock.demon.co.uk  2008-12-16 13:22 -------
Created an attachment (id=19330)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=19330&action=view)
Usbmon log for access to bad sector via usb-ide adaptor

These are the kernel messages from insertion of the usb drive to the end of the
dd command for one bad sector corresponding to the usbmon log attached:

Dec 12 15:26:49 daniel root: uname: Linux daniel 2.6.28-rc8 #1 PREEMPT Fri Dec
12 14:49:40 GMT 2008 i686 AMD Sempron(tm) Processor 2800+ AuthenticAMD
GNU/Linux
Dec 12 15:26:49 daniel root: About to insert disk
Dec 12 15:27:04 daniel usb 1-3: new high speed USB device using ehci_hcd and
address 4
Dec 12 15:27:04 daniel usb 1-3: configuration #1 chosen from 1 choice
Dec 12 15:27:04 daniel scsi6 : SCSI emulation for USB Mass Storage devices
Dec 12 15:27:04 daniel usb-storage: device found at 4
Dec 12 15:27:04 daniel usb-storage: waiting for device to settle before
scanning
Dec 12 15:27:04 daniel usb 1-3: New USB device found, idVendor=07ff,
idProduct=00ff
Dec 12 15:27:04 daniel usb 1-3: New USB device strings: Mfr=10, Product=11,
SerialNumber=5
Dec 12 15:27:04 daniel usb 1-3: Product: USB20
Dec 12 15:27:04 daniel usb 1-3: Manufacturer: USBID
Dec 12 15:27:04 daniel usb 1-3: SerialNumber: 7D5773691612
Dec 12 15:27:09 daniel scsi 6:0:0:0: Direct-Access     WDC AC22 000L           
 1N37 PQ: 0 ANSI: 2 CCS
Dec 12 15:27:09 daniel sd 6:0:0:0: [sdb] 3907008 512-byte hardware sectors:
(2.00 GB/1.86 GiB)
Dec 12 15:27:09 daniel sd 6:0:0:0: [sdb] Write Protect is off
Dec 12 15:27:09 daniel sd 6:0:0:0: [sdb] Mode Sense: 00 38 00 00
Dec 12 15:27:09 daniel sd 6:0:0:0: [sdb] Assuming drive cache: write through
Dec 12 15:27:09 daniel sd 6:0:0:0: [sdb] 3907008 512-byte hardware sectors:
(2.00 GB/1.86 GiB)
Dec 12 15:27:09 daniel sd 6:0:0:0: [sdb] Write Protect is off
Dec 12 15:27:09 daniel sd 6:0:0:0: [sdb] Mode Sense: 00 38 00 00
Dec 12 15:27:09 daniel sd 6:0:0:0: [sdb] Assuming drive cache: write through
Dec 12 15:27:09 daniel sdb: unknown partition table
Dec 12 15:27:09 daniel sd 6:0:0:0: [sdb] Attached SCSI disk
Dec 12 15:27:09 daniel sd 6:0:0:0: Attached scsi generic sg2 type 0
Dec 12 15:27:09 daniel usb-storage: device scan complete
Dec 12 15:27:16 daniel root: About to do dd of a known bad sector
Dec 12 15:27:27 daniel sd 6:0:0:0: [sdb] Sense Key : 0x0 [current] 
Dec 12 15:27:27 daniel sd 6:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Dec 12 15:27:46 daniel sd 6:0:0:0: [sdb] Sense Key : 0x0 [current] 
Dec 12 15:27:46 daniel sd 6:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Dec 12 15:28:00 daniel sd 6:0:0:0: [sdb] Sense Key : 0x0 [current] 
Dec 12 15:28:00 daniel sd 6:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Dec 12 15:28:05 daniel root: dd done


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
