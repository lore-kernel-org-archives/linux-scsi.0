From: Jens Axboe <axboe@suse.de>
Subject: Re: Sysfs attribute file for max_sectors
Date: Tue, 6 Jan 2004 22:14:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040106211424.GS3483@suse.de>
References: <1073413440.2221.47.camel@mulgrave> <Pine.LNX.4.44L0.0401061427230.6168-100000@ida.rowland.org> <20040106131105.A12358@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:16517 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S265115AbUAFVOn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2004 16:14:43 -0500
Content-Disposition: inline
In-Reply-To: <20040106131105.A12358@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Tue, Jan 06 2004, Patrick Mansfield wrote:
> Alan -
> 
> Given that we currently don't have any user level intitiated scanning, how
> can you modify max_sectors in user space prior to the scsi_alloc_queue()
> call done during scan?
> 
> Is there a block interface to modify max_sectors?

No. As James very clearly stated (and that I back 100%), max_sectors is
a driver template setting. It doesn't make sense to expose it, it's not
a configurable item.

-- 
Jens Axboe

