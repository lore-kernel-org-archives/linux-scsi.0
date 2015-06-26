From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] USB: storage: add "no SYNCHRONIZE CACHE" quirk
Date: Fri, 26 Jun 2015 13:05:05 +0200
Message-ID: <20150626130505.3918c5a9@kant>
References: <Pine.LNX.4.44L0.1506221324110.1799-100000@iolanthe.rowland.org>
	<1434994588.2237.90.camel@HansenPartnership.com>
	<20150626114308.7b5b8006@kant>
	<1435313657.2211.70.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:55437 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbbFZLGB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2015 07:06:01 -0400
In-Reply-To: <1435313657.2211.70.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>, James Bottomley <JBottomley@Parallels.com>, Jun Itou <itou_jun@infoseek.jp>, Markus Rathgeb <maggu2810@gmail.com>, Matt <vickm78@hotmail.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On Jun 26 James Bottomley wrote:
> On Fri, 2015-06-26 at 11:43 +0200, Stefan Richter wrote:
> > On Jun 22 James Bottomley wrote:
[...]
> > > Perhaps it might be wise to do this to every USB device ... for external
> > > devices, the small performance gain doesn't really make up for the
> > > potential data loss.
> > 
> > Just a small note on the assumption of externally (and in extension,
> > temporarily) attached devices:  Not all USB-attached devices are external,
> > and not all external devices are used as removable devices.
> 
> The problems don't depend on the connection type: internal devices which
> have a writeback cache and don't accept flush commands have data
> integrity problems too.  I can't really think of many situations where
> you'd be willing to sacrifice data integrity for performance.

Sure; writeback caches are prone to more issues besides sudden connection
loss.  (E.g. sudden power loss is but one of several more potential issues
of course.)

I merely wanted to remind that the bus type of a device (USB or whatever)
does not say much about the risk of sudden connection loss to that device,
since such devices may have physical protection against sudden connection
loss too.  I was not particularly commenting on the topic at hand, i.e.
on presence of writeback cache without working flush command.
-- 
Stefan Richter
-=====-===== -==- ==-=-
http://arcgraph.de/sr/
