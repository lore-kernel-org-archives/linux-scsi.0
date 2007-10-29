From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices (fwd)
Date: Mon, 29 Oct 2007 13:04:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0710291303380.11432-100000@iolanthe.rowland.org>
References: <1193676321.3383.53.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44851 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756706AbXJ2REx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 13:04:53 -0400
In-Reply-To: <1193676321.3383.53.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Hannes Reinecke <hare@suse.de>, Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 29 Oct 2007, James Bottomley wrote:

> On Mon, 2007-10-29 at 12:38 -0400, Alan Stern wrote:
> > No, that's not what happens.  The genhd's parent is the scsi_device
> > and 
> > the queue's parent is the genhd.  You can see this immediately from
> > the 
> > directory layout in sysfs.  Thus:
> 
> How has this happened?  The scsi_device doesn't know anything about the
> genhd; how can it hold a reference to it?

No, no -- it's the other way around.  The scsi_device is the parent of 
the genhd, so the genhd holds a reference to the scsi_device, not vice 
versa.

Alan Stern

