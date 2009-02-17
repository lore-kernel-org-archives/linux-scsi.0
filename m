From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12730] USB memory stick moved to different device on error / may be due to problem with high concurrent load on two USB devices
Date: Tue, 17 Feb 2009 14:26:51 -0800 (PST)
Message-ID: <20090217222651.D28E810803F@picon.linux-foundation.org>
References: <bug-12730-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874AbZBQW1Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2009 17:27:24 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1HMQpuD022159
	for <linux-scsi@vger.kernel.org>; Tue, 17 Feb 2009 14:26:53 -0800
In-Reply-To: <bug-12730-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12730





------- Comment #1 from wagner@tik.ee.ethz.ch  2009-02-17 14:26 -------
from /var/log/messages. Sorry for the line mangling.

Feb 17 21:04:10 gate kernel: usb 1-1: new high speed USB device using
ehci_hcd and address 4
Feb 17 21:04:10 gate kernel: usb 1-1: configuration #1 chosen from 1 choice
Feb 17 21:04:10 gate kernel: scsi5 : SCSI emulation for USB Mass Storage
devices
Feb 17 21:04:16 gate kernel: scsi 5:0:0:0: Direct-Access     TDKMedia
Trans-It Drive   PMAP PQ: 0 ANSI: 0 CCS
Feb 17 21:04:17 gate kernel: sd 5:0:0:0: [sde] 31260672 512-byte hardware
sectors (16005 MB)
Feb 17 21:04:17 gate kernel: sd 5:0:0:0: [sde] Write Protect is off
Feb 17 21:04:20 gate kernel: sd 5:0:0:0: [sde] 31260672 512-byte hardware
sectors (16005 MB)
Feb 17 21:04:20 gate kernel: sd 5:0:0:0: [sde] Write Protect is off
Feb 17 21:04:20 gate kernel:  sde: sde1
Feb 17 21:04:20 gate kernel: sd 5:0:0:0: [sde] Attached SCSI removable disk
Feb 17 21:04:20 gate kernel: sd 5:0:0:0: Attached scsi generic sg4 type 0
Feb 17 22:07:04 gate kernel: usb 1-1: USB disconnect, address 4
Feb 17 22:07:04 gate kernel: sd 5:0:0:0: [sde] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Feb 17 22:07:05 gate last message repeated 9 times
Feb 17 22:07:05 gate kernel: usb 1-2: reset high speed USB device using
ehci_hcd and address 3
Feb 17 22:07:09 gate kernel: __ratelimit: 24335 callbacks suppressed
Feb 17 22:07:10 gate kernel: sd 4:0:0:0: [sdd] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK,SUGGEST_OK
Feb 17 22:07:10 gate last message repeated 4 times
Feb 17 22:07:10 gate kernel: usb 1-1: new high speed USB device using
ehci_hcd and address 5
Feb 17 22:07:10 gate kernel: usb 1-1: configuration #1 chosen from 1 choice
Feb 17 22:07:10 gate kernel: scsi6 : SCSI emulation for USB Mass Storage
devices
Feb 17 22:07:10 gate kernel: usb 1-2: USB disconnect, address 3
Feb 17 22:07:14 gate kernel: __ratelimit: 24767 callbacks suppressed
Feb 17 22:07:15 gate kernel: scsi 6:0:0:0: Direct-Access     TDKMedia
Trans-It Drive   PMAP PQ: 0 ANSI: 0 CCS
Feb 17 22:07:15 gate kernel: sd 6:0:0:0: [sdd] 31260672 512-byte hardware
sectors (16005 MB)
Feb 17 22:07:15 gate kernel: sd 6:0:0:0: [sdd] Write Protect is off
Feb 17 22:07:15 gate kernel: sd 6:0:0:0: [sdd] 31260672 512-byte hardware
sectors (16005 MB)
Feb 17 22:07:15 gate kernel: sd 6:0:0:0: [sdd] Write Protect is off
Feb 17 22:07:15 gate kernel:  sdd: unknown partition table
Feb 17 22:07:15 gate kernel: sd 6:0:0:0: [sdd] Attached SCSI removable disk
Feb 17 22:07:15 gate kernel: sd 6:0:0:0: Attached scsi generic sg3 type 0
Feb 17 22:07:19 gate kernel: __ratelimit: 24396 callbacks suppressed
Feb 17 22:07:24 gate kernel: __ratelimit: 23645 callbacks suppressed
Feb 17 22:07:29 gate kernel: __ratelimit: 21585 callbacks suppressed


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
