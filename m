From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.27-rc7-git1: usb-storage breakage with non-functional disk
Date: Tue, 8 Jul 2008 10:01:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0807080958160.2442-100000@iolanthe.rowland.org>
References: <13988.84.245.32.19.1215522030.squirrel@secure.samage.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33562 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752368AbYGHOBj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2008 10:01:39 -0400
In-Reply-To: <13988.84.245.32.19.1215522030.squirrel@secure.samage.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Indan Zupancic <indan@nul.nu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB development list <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Tue, 8 Jul 2008, Indan Zupancic wrote:

> Any idea why my cardreader doesn't work in the first place though?
> 
> The error is basically:
> 
> usb 1-5: new high speed USB device using ehci_hcd and address 22
> usb 1-5: device not accepting address 22, error -71
> usb 1-5: new high speed USB device using ehci_hcd and address 23
> usb 1-5: configuration #1 chosen from 1 choice
> scsi17 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 23
> usb-storage: waiting for device to settle before scanning
> usb 1-5: reset high speed USB device using ehci_hcd and address 23
> usb 1-5: reset high speed USB device using ehci_hcd and address 23
> usb 1-5: reset high speed USB device using ehci_hcd and address 23
> scsi 17:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
> usb 1-5: reset high speed USB device using ehci_hcd and address 23
> usb 1-5: device not accepting address 23, error -71
> usb 1-5: reset high speed USB device using ehci_hcd and address 23
> usb 1-5: reset high speed USB device using ehci_hcd and address 23
> usb 1-5: reset high speed USB device using ehci_hcd and address 23
> usb 1-5: reset high speed USB device using ehci_hcd and address 23
> usb 1-5: can't restore configuration #1 (error=-71)
> usb 1-5: USB disconnect, address 23
> sd 17:0:0:0: [sdb] READ CAPACITY failed
> sd 17:0:0:0: [sdb] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
> sd 17:0:0:0: [sdb] Sense not available.
> sd 17:0:0:0: [sdb] Write Protect is off
> sd 17:0:0:0: [sdb] Mode Sense: 00 00 00 00
> sd 17:0:0:0: [sdb] Assuming drive cache: write through
> sd 17:0:0:0: [sdb] Attached SCSI removable disk
> sd 17:0:0:0: Attached scsi generic sg2 type 0
> usb-storage: device scan complete
> usb 1-5: new high speed USB device using ehci_hcd and address 24
> usb 1-5: string descriptor 0 read error: -71
> usb 1-5: configuration #1 chosen from 1 choice
> usb 1-5: can't set config #1, error -71
> 
> It's a new Trust Mini Cardreader, model CR-1350p.

> It doesn't matter in which port I put the thing (front, back),
> and I've tried older kernels too (2.6.12), but I get the same
> error there. This is with an Intel 945G chipset.
> (I've no Windows to test if it works there.)
> 
> Is it just a crappy device which I should bring back, or is
> there more going on?

It could be a bad device or it could be a bad USB cable.  Have you 
tried using the card reader with a different computer?

A usb-storage verbose debugging log might reveal something useful.

Alan Stern

