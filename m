From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 08:29:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0309220801330.1696-100000@home.osdl.org>
References: <Pine.LNX.4.44L0.0309221001090.1697-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:35764 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263183AbTIVPaK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 11:30:10 -0400
In-Reply-To: <Pine.LNX.4.44L0.0309221001090.1697-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>


On Mon, 22 Sep 2003, Alan Stern wrote:
>
> This problem has been cropping up with many, many USB storage devices.  

Interesting data-point: the device is a happy EHCI camper, and is totally 
able to read codepage 8 on EHCI.

However, if I put it behind a USB-1 hub on the EHCI port, I see the same 
problems I saw with OHCI.

So it is somehow related to USB-1 vs USB-2. I don't understand why the 
device would make a difference for something like mode page 8, but it 
looks like it transfers data fine for _small_ mode page requests under 
USB-1, and under USB-2 it works even for big ones.

		Linus

