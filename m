From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] usb-storage / scsi : new scsi host on each
 plug
Date: Wed, 29 Oct 2003 10:24:34 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0310291020430.874-100000@ida.rowland.org>
References: <E1AEoQX-0005kQ-Cz@mail.holoclan.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:9220 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261743AbTJ2PYe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 10:24:34 -0500
In-Reply-To: <E1AEoQX-0005kQ-Cz@mail.holoclan.de>
List-Id: linux-scsi@vger.kernel.org
To: martin@lorenz.eu.org
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 29 Oct 2003 martin@lorenz.eu.org wrote:

> Dear friends in the C-Source,
> 
> I am currently setting up my new toy, a Sharp PC-MM10, 
> banning the preinstalled XP and using a real System...
> 
> I compiled a 2.6.0-test9 kernel with USB compiled in or as module (same thing happens) and I experience the following problem:
> 
> no matter which USB-storage-device I attach (tried CD-ROM, 
> Flash Card Reader and memory stick) I get a new scsi host
> every time i plug a device in.
> 
> so when changing devices for several times I finally end up
> with /dev/scsi/host0 to 17 or more (diden't go on)
> 
> I would like to provide more debug information and also help digging down the problem. I just need a hint, where to start searching. Is it the SCSI-driver, is it usb-storage or anywhere else?
> 
> greets and thanks
> martin

This is a SCSI issue, not a USB one.  Maybe someone on the 
SCSI development list can enlighten us.  As far as I can tell, the host 
number is simply incremented every time a new host, of whatever sort, is 
added.  The numbers never get reused.

Alan Stern

