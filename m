From: David Zeuthen <david@fubar.dk>
Subject: Re: scsi "target1:0:0"
Date: Tue, 16 Nov 2004 12:40:14 -0500
Message-ID: <1100626815.4546.12.camel@davidz>
References: <1100622096.8606.104.camel@localhost.localdomain>
	 <1100622800.2574.41.camel@mulgrave>
	 <1100624154.8606.122.camel@localhost.localdomain>
	 <20041116171018.GK26623@parcelfarce.linux.theplanet.co.uk>
	 <1100625783.4546.4.camel@davidz>  <1100625933.2770.45.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:2735 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262052AbUKPRi2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 12:38:28 -0500
In-Reply-To: <1100625933.2770.45.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Kay Sievers <kay.sievers@vrfy.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-11-16 at 11:25 -0600, James Bottomley wrote:
> On Tue, 2004-11-16 at 11:23, David Zeuthen wrote:
> > Please explain how you expect userspace to keep track of the device tree
> > and enforce policy if we don't get hotplug events for things in the
> > middle of the tree?
> 
> The full path to the device is part of the environment of the event. 
> Can't you simply parse this?
> 

I suppose that userspace can just ascent up the tree and ignore devices
inbetween instead of assuming that every device in the middle has a bus
or class? That would probably work, yeah.

> I'm already getting complaints in the other direction (too many SCSI
> hotplug events) from the large system people.  I'm really loth to
> introduce more simply as a convenience for a user space daemon.
> 
> Really, I think there should only be hot plug events from real entities
> (which, more often than not are only the leaf nodes of the sysfs trees).
> 

That makes sense to me. Which leads me to ask: are there any
documentation spelling out what userspace should expect and what sorts
of guarantees there is in general for sysfs ABI? That would be useful to
prevent situations like this.

Thanks,
David


