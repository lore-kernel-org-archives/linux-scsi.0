From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security
 in usb-storage driver
Date: Mon, 7 Nov 2005 14:33:40 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0511071427580.5078-100000@iolanthe.rowland.org>
References: <436F97BE.1030406@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49821 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S964914AbVKGTdl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Nov 2005 14:33:41 -0500
In-Reply-To: <436F97BE.1030406@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: thomas schorpp <t.schorpp@gmx.de>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, Timothy Thelin <Timothy.Thelin@wdc.com>, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>

On Mon, 7 Nov 2005, thomas schorpp wrote:

> > I don't think blacklisting is a good way to do this.  In principle any USB 
> > mass storage device -- any SCSI device, in fact -- might have a 
> > vendor-specific pass-thru needing special handling.
> 
> no. that would be not industry best practice and uneconomical sw effort.

Adding vendor-specific codes to SCSI devices isn't industry best practice?  
I can't argue with that, but it is very common nevertheless.

Is it an uneconomical software effort?  Ridiculous -- it's not software at 
all, it's part of the firmware.

> remember this devices are mainly "designed for windows" and WHQL certification 
> is expensive for every single driver. and ms has only one driver for all usb storage 
> right now, all boxes and sticks i had here use it.

I think you have a very limited view of how devices are "designed".  
Besides, I specifically said I was talking about _all_ SCSI devices, not 
just USB ones.

> >  It doesn't have to be 
> > correlated with the vendor, the product, the SCSI level, the transport, or 
> > anything else.
> 
> yes. the sheet for design recommended cypress chips state all ATACB and ATA-Security.
> i would be make no sense to implement different behaviuors in chips for the same purpose.

That's what Cypress does, sure.  But who says that other vendors have to 
copy Cypress?  For the most part they don't.  Neither does T10.

As for whether it makes no sense -- you have your point of view.  Business 
people have a very different point of view; to them it might make 
excellent sense, to help secure a competitive advantage.

Alan Stern

