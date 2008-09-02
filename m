From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: WAS: "Re: [Bugme-new] [Bug 11302] New: I get a kernel OOPS! If
 I try to attach an usb card reader, SD, MMC, ecc.. to my Slamd64"
Date: Mon, 1 Sep 2008 22:20:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809012219001.6519-100000@netrider.rowland.org>
References: <1220313910.3353.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:3385 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752374AbYIBCUs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Sep 2008 22:20:48 -0400
In-Reply-To: <1220313910.3353.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: pinc_o@yahoo.it, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>, Andrew Morton <akpm@linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>, bugme-daemon@bugzilla.kernel.org, USB list <linux-usb@vger.kernel.org>

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

