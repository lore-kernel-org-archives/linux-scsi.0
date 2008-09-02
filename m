From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11302] I get a kernel OOPS! If I try to attach an usb card reader, SD, MMC, ecc.. to my Slamd64
Date: Mon,  1 Sep 2008 19:21:23 -0700 (PDT)
Message-ID: <20080902022123.1D40E108059@picon.linux-foundation.org>
References: <bug-11302-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbYIBCVy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Sep 2008 22:21:54 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m822LNuU013442
	for <linux-scsi@vger.kernel.org>; Mon, 1 Sep 2008 19:21:24 -0700
In-Reply-To: <bug-11302-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11302





------- Comment #8 from stern@rowland.harvard.edu  2008-09-01 19:21 -------
On Mon, 1 Sep 2008, James Bottomley wrote:

> On Mon, 2008-09-01 at 23:30 +0000, pinco pallino wrote:
> > Hi Andrew,
> > 
> > with the new kernel 2.6.26.3 the SD are now read and wrote correctly, but SDHC are not read! The kernel repeat the error. Follow the error:
> > 
> > Sep  1 22:08:20 athos -- MARK --
> > Sep  1 22:19:12 athos kernel: usb 1-6: new high speed USB device using ehci_hcd and address 5
> > Sep  1 22:19:12 athos kernel: usb 1-6: configuration #1 chosen from 1 choice
> > Sep  1 22:19:12 athos kernel: scsi5 : SCSI emulation for USB Mass Storage devices
> > Sep  1 22:19:17 athos kernel: scsi 5:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
> > Sep  1 22:19:47 athos kernel: usb 1-6: reset high speed USB device using ehci_hcd and address 5
> > Sep  1 22:20:14 athos last message repeated 3 times
> 
> This is definitely a USB issue (correct cc's added).  It looks like some
> attempted reset finally ...
> 
> > Sep  1 22:20:14 athos kernel: sd 5:0:0:0: Device offlined - not ready after error recovery
> > Sep  1 22:20:14 athos kernel: usb 1-6: USB disconnect, address 5
> 
> ... leads to disconnection here.

Try building a kernel with CONFIG_USB_STORAGE_DEBUG enabled and post or 
attach the dmesg log showing what happens when you plug in the device.

Alan Stern


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
