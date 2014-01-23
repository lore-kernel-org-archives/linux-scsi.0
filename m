From: Alan Stern <stern@rowland.harvard.edu>
Subject: =?utf-8?q?Re=3A_=5Busb=2Dstorage=5D_Re=3A_usb_disk_recognized_but_fails?=
Date: Thu, 23 Jan 2014 11:54:39 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401231143360.891-100000@iolanthe.rowland.org>
References: <20140123130811.E313AD9F@centrum.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:41082 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753552AbaAWQyk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jan 2014 11:54:40 -0500
In-Reply-To: <20140123130811.E313AD9F@centrum.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?q?Milan_Svoboda?= <milan.svoboda@centrum.cz>
Cc: =?utf-8?q?Sarah_Sharp?= <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, =?utf-8?q?USB_Storage_List?= <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Thu, 23 Jan 2014, Milan Svoboda wrote:

> Whoaa!!
> 
> I recompiled the master again, but now with a little bit modified configuration, mainly I disabled the CONFIG_USB_STORAGE_CYPRESS_ATACB and
> it works like a charm! Disk is properly and immediately detected and works!

I don't see how that could have made any difference.  The Cypress-ATACB 
driver works just like the default driver, except for two commands
(ATA(12) and ATA(16)) neither of which appeared in the usbmon trace.

Your new config enables CONFIG_USB_STORAGE_DEBUG.  More likely that is 
the reason for the improvement.  Try taking out that one setting (don't 
change anything else) and see what happens.

> I also tried to boot to standard kernel and disable loading ums_cypress by putting it on the blacklist but it didn't worked out. The
> disk wasn't detected at all (no message about plug-in event nor report about disk size).
> 
> I strongly belive that it is Linux kernel problem, not the disk's (apart it might need some quirks). If I remember correctly there hasn't
> been the ums_cypress from the begining, right? So, perhaps the time when it was added corresponds with the time when it
> worked for me last time.

What do you mean by "from the beginning"?  The ums-cypress driver was
added in 2008.

Alan Stern

