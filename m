From: Oliver Neukum <oneukum@suse.de>
Subject: Re: READ_CAPACITY_16 vs. READ_CAPACITY_10
Date: Tue, 10 Sep 2013 22:44:18 +0200
Message-ID: <1378845858.24378.1.camel@linux-fkkt.site>
References: <Pine.LNX.4.44L0.1309101322390.1075-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879Ab3IJUoU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Sep 2013 16:44:20 -0400
In-Reply-To: <Pine.LNX.4.44L0.1309101322390.1075-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: hare@suse.de, linux-scsi@vger.kernel.org

On Tue, 2013-09-10 at 13:25 -0400, Alan Stern wrote:
> On Tue, 10 Sep 2013, Oliver Neukum wrote:
> 
> > Hi Hannes,
> > 
> > you objected to this patch saying there's a possibilty that
> > HS devices may also need this feature, which would require
> > a quirk. Does this mean that the patch is acceptable only
> > with an additional predefined quirk, or do you insist that all
> > devices be handled with quirks?
> 
> Indeed, we already know of one or two high-speed devices that suffer
> from this bug:
> 
> 	http://marc.info/?l=linux-usb&m=133586313307042&w=2
> 
> This may influence your decision.  I'm not certain whether it is 
> important enough to merit a new quirk flag, but people experiencing the 
> problem may have some strong opinions.

What is the alternative?

I think we can be sure that no drive enclosure will crash
with READ_CAPACITY_16. I am not sure about card readers.
Does anybody know what Windows does?

	Regards
		Oliver




