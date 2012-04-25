From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43164] FC card not detected/mounted via external multicard
 reader
Date: Wed, 25 Apr 2012 20:05:13 GMT
Message-ID: <201204252005.q3PK5D7K024855@bugzilla.kernel.org>
References: <bug-43164-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:59176 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab2DYUFN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2012 16:05:13 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q3PK5D2W024856
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2012 20:05:13 GMT
In-Reply-To: <bug-43164-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=43164





--- Comment #7 from Damjan <damjan.zemljic@gmail.com>  2012-04-25 20:05:12 ---
For some reasons syslog cannot be attached. Here it is as a comment.

>From syslog - entries when attached directly:
Apr 25 18:59:14 think kernel: [29252.633525] usb 3-1.4: new full speed USB
device number 6 using xhci_hcd
Apr 25 18:59:14 think kernel: [29252.660509] usb 3-1.4: not running at top
speed; connect to a high speed hub
Apr 25 18:59:15 think mtp-probe: checking bus 3, device 6:
"/sys/devices/pci0000:00/0000:00:1c.6/0000:0f:00.0/usb3/3-1/3-1.4"
Apr 25 18:59:15 think kernel: [29252.680751] scsi9 : usb-storage 3-1.4:1.0
Apr 25 18:59:15 think mtp-probe: bus: 3, device: 6 was not an MTP device
Apr 25 18:59:16 think kernel: [29253.683055] scsi 9:0:0:0: Direct-Access    
Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
Apr 25 18:59:16 think kernel: [29253.683684] scsi 9:0:0:1: Direct-Access    
Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
Apr 25 18:59:16 think kernel: [29253.684449] scsi 9:0:0:2: Direct-Access    
Generic  USB xD/SM Reader 1.02 PQ: 0 ANSI: 0
Apr 25 18:59:16 think kernel: [29253.685141] scsi 9:0:0:3: Direct-Access    
Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
Apr 25 18:59:16 think kernel: [29253.927310] sd 9:0:0:0: Attached scsi generic
sg2 type 0
Apr 25 18:59:16 think kernel: [29253.927484] sd 9:0:0:1: Attached scsi generic
sg3 type 0
Apr 25 18:59:16 think kernel: [29253.927642] sd 9:0:0:2: Attached scsi generic
sg4 type 0
Apr 25 18:59:16 think kernel: [29253.927803] sd 9:0:0:3: Attached scsi generic
sg5 type 0
Apr 25 18:59:16 think kernel: [29253.932498] sd 9:0:0:0: [sdb] Attached SCSI
removable disk
Apr 25 18:59:16 think kernel: [29253.932997] sd 9:0:0:1: [sdc] Attached SCSI
removable disk
Apr 25 18:59:16 think kernel: [29253.933442] sd 9:0:0:2: [sdd] Attached SCSI
removable disk
Apr 25 18:59:16 think kernel: [29253.933947] sd 9:0:0:3: [sde] Attached SCSI
removable disk
Apr 25 19:00:39 think kernel: [29337.196008] usb 3-1.4: reset full speed USB
device number 6 using xhci_hcd
Apr 25 19:00:39 think kernel: [29337.222992] xhci_hcd 0000:0f:00.0: xHCI
xhci_drop_endpoint called with disabled ep ffff880121af1c80
Apr 25 19:00:39 think kernel: [29337.222999] xhci_hcd 0000:0f:00.0: xHCI
xhci_drop_endpoint called with disabled ep ffff880121af1cc0
Apr 25 19:00:40 think kernel: [29337.735732] usb 3-1.4: reset full speed USB
device number 6 using xhci_hcd
Apr 25 19:00:40 think kernel: [29337.762773] xhci_hcd 0000:0f:00.0: xHCI
xhci_drop_endpoint called with disabled ep ffff880121af1c80
Apr 25 19:00:40 think kernel: [29337.762780] xhci_hcd 0000:0f:00.0: xHCI
xhci_drop_endpoint called with disabled ep ffff880121af1cc0
Apr 25 19:00:40 think kernel: [29337.959667] usb 3-1.4: reset full speed USB
device number 6 using xhci_hcd




>From syslog - when attached via docking station:
Apr 25 19:05:15 think kernel: [29613.270278] usb 1-1.5.3: new high speed USB
device number 13 using ehci_hcd
Apr 25 19:05:15 think kernel: [29613.365414] scsi20 : usb-storage 1-1.5.3:1.0
Apr 25 19:05:15 think mtp-probe: checking bus 1, device 13:
"/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3"
Apr 25 19:05:15 think mtp-probe: bus: 1, device: 13 was not an MTP device
Apr 25 19:05:16 think kernel: [29614.363383] scsi 20:0:0:0: Direct-Access    
Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
Apr 25 19:05:16 think kernel: [29614.364124] scsi 20:0:0:1: Direct-Access    
Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
Apr 25 19:05:16 think kernel: [29614.364813] scsi 20:0:0:2: Direct-Access    
Generic  USB xD/SM Reader 1.02 PQ: 0 ANSI: 0
Apr 25 19:05:16 think kernel: [29614.365566] scsi 20:0:0:3: Direct-Access    
Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
Apr 25 19:05:16 think kernel: [29614.466797] sd 20:0:0:0: Attached scsi generic
sg2 type 0
Apr 25 19:05:16 think kernel: [29614.466952] sd 20:0:0:1: Attached scsi generic
sg3 type 0
Apr 25 19:05:16 think kernel: [29614.467115] sd 20:0:0:2: Attached scsi generic
sg4 type 0
Apr 25 19:05:16 think kernel: [29614.467270] sd 20:0:0:3: Attached scsi generic
sg5 type 0
Apr 25 19:05:17 think kernel: [29614.590409] usb 1-1.5.3: USB disconnect,
device number 13
Apr 25 19:05:17 think kernel: [29614.590795] sd 20:0:0:0: [sdb] Attached SCSI
removable disk
Apr 25 19:05:17 think kernel: [29614.590824] sd 20:0:0:3: [sde] READ CAPACITY
failed
Apr 25 19:05:17 think kernel: [29614.590829] sd 20:0:0:3: [sde]  Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Apr 25 19:05:17 think kernel: [29614.590834] sd 20:0:0:3: [sde] Sense not
available.
Apr 25 19:05:17 think kernel: [29614.590871] sd 20:0:0:1: [sdc] READ CAPACITY
failed
Apr 25 19:05:17 think kernel: [29614.590876] sd 20:0:0:3: [sde] Write Protect
is off
Apr 25 19:05:17 think kernel: [29614.590881] sd 20:0:0:3: [sde] Mode Sense: 00
00 00 00
Apr 25 19:05:17 think kernel: [29614.590886] sd 20:0:0:1: [sdc]  Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Apr 25 19:05:17 think kernel: [29614.590891] sd 20:0:0:1: [sdc] Sense not
available.
Apr 25 19:05:17 think kernel: [29614.590917] sd 20:0:0:2: [sdd] READ CAPACITY
failed
Apr 25 19:05:17 think kernel: [29614.590922] sd 20:0:0:3: [sde] Asking for
cache data failed
Apr 25 19:05:17 think kernel: [29614.590926] sd 20:0:0:3: [sde] Assuming drive
cache: write through
Apr 25 19:05:17 think kernel: [29614.590931] sd 20:0:0:2: [sdd]  Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Apr 25 19:05:17 think kernel: [29614.590935] sd 20:0:0:2: [sdd] Sense not
available.
Apr 25 19:05:17 think kernel: [29614.590958] sd 20:0:0:1: [sdc] Write Protect
is off
Apr 25 19:05:17 think kernel: [29614.590962] sd 20:0:0:1: [sdc] Mode Sense: 00
00 00 00
Apr 25 19:05:17 think kernel: [29614.590974] sd 20:0:0:2: [sdd] Write Protect
is off
Apr 25 19:05:17 think kernel: [29614.590977] sd 20:0:0:2: [sdd] Mode Sense: 00
00 00 00
Apr 25 19:05:17 think kernel: [29614.590996] sd 20:0:0:2: [sdd] Asking for
cache data failed
Apr 25 19:05:17 think kernel: [29614.591000] sd 20:0:0:2: [sdd] Assuming drive
cache: write through
Apr 25 19:05:17 think kernel: [29614.591176] sd 20:0:0:3: [sde] Attached SCSI
removable disk
Apr 25 19:05:17 think kernel: [29614.591219] sd 20:0:0:1: [sdc] Asking for
cache data failed
Apr 25 19:05:17 think kernel: [29614.591222] sd 20:0:0:1: [sdc] Assuming drive
cache: write through
Apr 25 19:05:17 think kernel: [29614.591454] sd 20:0:0:2: [sdd] Attached SCSI
removable disk
Apr 25 19:05:17 think kernel: [29614.591461] sd 20:0:0:1: [sdc] Attached SCSI
removable disk
Apr 25 19:05:17 think kernel: [29615.125628] usb 1-1.5.3: new high speed USB
device number 14 using ehci_hcd
Apr 25 19:05:17 think kernel: [29615.220958] scsi21 : usb-storage 1-1.5.3:1.0
Apr 25 19:05:17 think mtp-probe: checking bus 1, device 14:
"/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.5/1-1.5.3"
Apr 25 19:05:17 think mtp-probe: bus: 1, device: 14 was not an MTP device

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
