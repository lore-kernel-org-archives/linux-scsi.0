From: Ruud Linders <rkmp@xs4all.nl>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Wed, 24 Sep 2003 18:40:29 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F71C8FD.2050109@xs4all.nl>
References: <Pine.LNX.4.44.0309231114050.15373-100000@home.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from node-c-7b4b.a2000.nl ([62.194.123.75]:10624 "EHLO
	wsprwl.xs4all.nl") by vger.kernel.org with ESMTP id S261447AbTIXQka
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 12:40:30 -0400
In-Reply-To: <Pine.LNX.4.44.0309231114050.15373-100000@home.osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Patrick Mansfield <patmans@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, Andries.Brouwer@cwi.nl



Linus Torvalds wrote:
> On Tue, 23 Sep 2003, Ruud Linders wrote:
> 
>>I tried the patch but it doesn't work for me using an USB-2 Memory stick
>>"DiskonKey" on an USB-2 port (with uhci_hcd & ehci_hcd loaded).
>>
>>After a 3 minute time-out I get
>>     "SCSI device sda: drive cache: write through"
>>and the device starts working just fine.
> 
> 
> Is this different from a plain kernel _without_ the patch?
> 

No difference.

> 
>>Unloading the ehci_hcd module doesn't make any difference.
>>Only when ripping out the whole mode-sense call it works immediately :-)
>>so it appears the device is just unhappy about the sd_do_mode_sense.
> 
> 
> Yes, I think we might want to mark USB devices as being write-through by 
> default. That said, I think the patch is still better than what we have 
> now (which just doesn't make any sense at all).
> 

Fully agree here, 2.4.2x doesn't appear to do this mode_sense checking
and works with all the usb-mass-storage devices I tried.


> 		Linus
> 
> 


_
Ruud

