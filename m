From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: usb storage traces
Date: 05 Dec 2003 09:11:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070640667.12411.32.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0312051049040.850-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:40444 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264265AbTLEQLS
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2003 11:11:18 -0500
In-Reply-To: <Pine.LNX.4.44L0.0312051049040.850-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, Patrick Mansfield <patmans@us.ibm.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, David Brownell <david-b@pacbell.net>

> > What is FSG?
> ...
> ... File-backed Storage Gadget.  
> It's a driver for a Linux-based USB _device_ (as opposed to _host_) that 
> emulates a USB Mass Storage device, using a file or block device as 
> backing storage in somewhat the same manner as the loop driver.
> ... Unfortunately, ...

Wow, our lead FSG developer has no Linux USB _device_.

Ouch.  Some sponsor with money should fix that.

> ...

Mostly I'm writing to mention, recently one of the semi-private
usb-storage ancestors of this thread also gave me:

http://www.linux-usb.org/gadget/

explained as follows.

Pat LaVarre

-----Forwarded Message-----
Subject: Re: [usb-storage] g_file_storage logs for Windows hosts
Date: 04 Dec 2003 15:59:45 -0700

Pat LaVarre wrote:

> What I lack is (a) free time and (b) a tutorial I can rapidly
> assimilate for how I fetch and deploy current fsg to h/w I own.

See www.linux-usb.org/gadget for the bare info.  Clone kernel from BK
(or just pull into your own repository), configure your kernel, build
and install with the file storage gadget; "modprobe g_file_storage ..."
as shown on that page.  That assumes you have appropriate hardware.

> Possibly the only appropriate hardware I have is a once-free-with-msdn
> "ViewSonic" "Pocket PC V37".  On that, Windows --> Settings --> System
> --> About reports "Intel PXA255" "36.45 MB".

Hardware that will run ... FSG code includes 2.4 or 2.6 systems
running Linux is less common than generic PCs or USB disks:

  - PXA 2xx hardware, which tends to be semi-custom.  www.handhelds.org
    is a good source of info.  (They don't list that ViewSonic, and
    focus on iPaqs even though Zaurii run Linux too.)

  - PCI-based hardware with a net2280 (www.netchip.com); simplest as
    a PCI card in a generic PC.  (This is the high speed option.)

  - PCI-based hardware with a Toshiba TC86c001 chip, includes some
    MIPS systems; a PCI card version needs a 3.3V slot.

  - ... can probably say something about the SuperH hardware
    that runs it; this support is 2.4-only for now.

I understand there are drivers for some other device-side USB
controllers which are in development, or otherwise not widely
circulated.  Such as some other NetChip hardware, Cypress SX2, some
other ARM-based SOCs, and more.
...


