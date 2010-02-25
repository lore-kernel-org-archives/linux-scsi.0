From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 18:54:02 +0100
Message-ID: <20100225175402.GZ1025@kernel.dk>
References: <Pine.LNX.4.44L0.1002251132170.1686-100000@iolanthe.rowland.org> <yq14ol5mfa1.fsf@sermon.lab.mkp.net> <yq1zl2xl0j3.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40827 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933137Ab0BYRyD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Feb 2010 12:54:03 -0500
Content-Disposition: inline
In-Reply-To: <yq1zl2xl0j3.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Ramya Desai <ramya.desai@gmail.com>, James Bottomley <James.Bottomley@suse.de>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Thu, Feb 25 2010, Martin K. Petersen wrote:
> >>>>> "mkp" == Martin K Petersen <martin.petersen@oracle.com> writes:
> 
> mkp> This one is a runt that came in as part of the DM topology
> mkp> enablement.  DM ended up doing things differently and it is no
> mkp> longer used.  I already have a patch in my queue that removes it.
> 
> Here it is, btw...
> 
> 
> block: Remove blk_queue_max_hw_sectors
> 
> This function is no longer called by any subsystem and can be removed.
> 
> Also clarify test in blk_queue_max_sectors.

That works, we badly need to clean this crap up, I had not noticed it
had gone this wrong. I'll shove this into 2.6.34, thanks.

-- 
Jens Axboe

