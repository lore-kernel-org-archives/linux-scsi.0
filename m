From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 11:49:42 -0500
Message-ID: <yq14ol5mfa1.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.44L0.1002251132170.1686-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:40423 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758948Ab0BYQv3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 11:51:29 -0500
In-Reply-To: <Pine.LNX.4.44L0.1002251132170.1686-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Thu, 25 Feb 2010 11:37:49 -0500 (EST)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ramya Desai <ramya.desai@gmail.com>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <jens.axboe@oracle.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:

Alan> If they call blk_queue_max_sectors() then both the hard and soft
Alan> limits are affected, but at least the hard limit is set correctly.

Yep.


Alan> If they call blk_queue_max_hw_sectors() then only the hard limit
Alan> is affected, 

This one is a runt that came in as part of the DM topology enablement.
DM ended up doing things differently and it is no longer used.  I
already have a patch in my queue that removes it.

-- 
Martin K. Petersen	Oracle Linux Engineering
