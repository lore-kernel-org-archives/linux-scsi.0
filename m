From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: READ_CAPACITY_16 vs. READ_CAPACITY_10
Date: Wed, 11 Sep 2013 10:14:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1309111010500.1352-100000@iolanthe.rowland.org>
References: <1378845858.24378.1.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:58535 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752656Ab3IKOOt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Sep 2013 10:14:49 -0400
In-Reply-To: <1378845858.24378.1.camel@linux-fkkt.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: hare@suse.de, linux-scsi@vger.kernel.org

On Tue, 10 Sep 2013, Oliver Neukum wrote:

> On Tue, 2013-09-10 at 13:25 -0400, Alan Stern wrote:
> > On Tue, 10 Sep 2013, Oliver Neukum wrote:
> > 
> > > Hi Hannes,
> > > 
> > > you objected to this patch saying there's a possibilty that
> > > HS devices may also need this feature, which would require
> > > a quirk. Does this mean that the patch is acceptable only
> > > with an additional predefined quirk, or do you insist that all
> > > devices be handled with quirks?
> > 
> > Indeed, we already know of one or two high-speed devices that suffer
> > from this bug:
> > 
> > 	http://marc.info/?l=linux-usb&m=133586313307042&w=2
> > 
> > This may influence your decision.  I'm not certain whether it is 
> > important enough to merit a new quirk flag, but people experiencing the 
> > problem may have some strong opinions.
> 
> What is the alternative?

There are three possibilities: nothing, your proposed patch, and a new 
quirk flag.  The flag is safest, but also the hardest to maintain.

> I think we can be sure that no drive enclosure will crash
> with READ_CAPACITY_16.

I wouldn't count on it, but I don't know of any examples.

> I am not sure about card readers.

Or flash drives.

> Does anybody know what Windows does?

Not me.  It probably varies with different versions of Windows.

Alan Stern

