From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: READ_CAPACITY_16 vs. READ_CAPACITY_10
Date: Wed, 11 Sep 2013 11:42:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1309111140240.1352-100000@iolanthe.rowland.org>
References: <1378911947.28160.18.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58714 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754495Ab3IKPmg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Sep 2013 11:42:36 -0400
In-Reply-To: <1378911947.28160.18.camel@linux-fkkt.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: hare@suse.de, linux-scsi@vger.kernel.org

On Wed, 11 Sep 2013, Oliver Neukum wrote:

> On Wed, 2013-09-11 at 10:14 -0400, Alan Stern wrote:
> 
> > There are three possibilities: nothing, your proposed patch, and a new
> 
> Nothing is feasible only if Windows uses READ_CAPACITY_10.

It seems clear that your patch isn't feasible either, as it doesn't 
help high-speed devices.

> > quirk flag.  The flag is safest, but also the hardest to maintain.
> 
> Again the same answer.
> 
> > > I think we can be sure that no drive enclosure will crash
> > > with READ_CAPACITY_16.
> > 
> > I wouldn't count on it, but I don't know of any examples.
> > 
> > > I am not sure about card readers.
> > 
> > Or flash drives.
> > 
> > > Does anybody know what Windows does?
> > 
> > Not me.  It probably varies with different versions of Windows.
> 
> I'll try to get a Windows machine for a trace.
> Can you suggest a tracer for Win7?

I don't know of any, offhand.  Maybe Google can help.

Alternatively, you could install Windows 7 in a virtual machine under 
Linux and use usbmon.

Alan Stern

