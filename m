From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Linux-usb-users] usb-storage and Motorola Z6
Date: Fri, 7 Sep 2007 15:58:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709071549060.7123-100000@netrider.rowland.org>
References: <46E1A358.7030707@udgaard.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:1939 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758394AbXIGT6a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Sep 2007 15:58:30 -0400
In-Reply-To: <46E1A358.7030707@udgaard.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Rasmussen <plr@udgaard.com>
Cc: Andreas Koenecke <akoenecke@akoenecke.de>, SCSI development list <linux-scsi@vger.kernel.org>, USB users list <linux-usb-users@lists.sourceforge.net>

On Fri, 7 Sep 2007, Peter Rasmussen wrote:

> I'm sorry if this is a little late, but I had once had access to a Z6 
> and believe I had it successfully connected to my Linux host, and was 
> therefore puzzled by this message exchange.
> 
> I have now borrowed the device again for the weekend to check it out a 
> little more.
> 
> Using Alan's patch below, otherwise my kernel is a standard 2.6.23-rc5 
> (CONFIG_USB_STORAGE_DEBUG=y ) I got the following result after reboot 
> and connecting the Z6.:
...

In fact there was another patch from earlier in the email thread, which 
was needed to work around the PQ = 1 problem.  Since you didn't apply 
that patch, the SCSI disk driver wasn't bound to your Z6.

> What I can't understand, however, is that as this mobile phone 
> supposedly runs Linux. I can't see how Motorola could break it so badly 
> that the USB connection now doesn't work with a PC running Linux?

:-)  There's no necessary relation between the OS running on a device
like your phone and its interoperability with computers running the
same OS.

> And you say that this seems to be a more widespread problem with 
> Motorola devices? Do you remember which ones, and do they run Linux as well?

There were two problems.  First was the PQ = 1 problem; I have never
seen it before now (so only on the Z6).  The other problem was the
capacity, or last sector number; we know that the RAZR V3i and V3x both
suffer from it as well.  (I have no idea whether they run Linux.)  
Possibly other devices do too, and we just don't know about them.

> The following is from connecting a Z3 that supposedly isn't based on 
> Linux, but works all right (and this may have been the one I thought was 
> the Z6 that I claimed worked):
...

It looks normal.

> I hope perhaps it can provide some comparison info now with a device 
> that works and one that doesn't.
> 
> If Motorola actualy has made changes to the Linux kernel they use with 
> the Z6, I suppose we should be able to get the actual code. Should I 
> investigate that?

Sure, go ahead and try.  Maybe you can convince them to fix their bugs!  
Although that won't help all the units that have already been 
manufactured...

Alan Stern

