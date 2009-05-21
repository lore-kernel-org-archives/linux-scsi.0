From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/2 version 4] osdblk: a Linux block device for OSD objects
Date: Thu, 21 May 2009 18:41:07 -0400
Message-ID: <4A15D883.1060104@garzik.org>
References: <4A155FF6.3060005@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50262 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbZEUWlM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 May 2009 18:41:12 -0400
In-Reply-To: <4A155FF6.3060005@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, Jens Axboe <jens.axboe@oracle.com>

Boaz Harrosh wrote:
> I'm posting for review a new version of the osdblk driver. What's new?
> 
> * Once block/for-2.6.31 and all pending osd patches hit mainline. this new version
>   is ready for submission.
>   - The relevant osd patches have been posted on the mailing list, but I'll send an orderly
>     set for scsi-misc and scsi-post-merge on Sunday.
>   - All the prerequisite block patches are already in Jens's tree.
> 
> * Below is the diff from Jeff's last version of the patch. these things have changed:
>  {SQUASHME: osdblk} Block and OSD Api fixups and bug fixes
> 
>  - Block API changes from Tejuns revamps
>  - OSD Api changes for supporting bio-chaining
>  - do_flush requests do not need bio clonning
>    (And might not have any so prevent such a crash)
>  - osdblk_make_credential is here to stay
>  - Use bio_kmalloc and avoid the bio_alloc dead/live locks.
>    TODO: Split request into smaller chunks if allocations fail.
>  - Only use __GFP_WAIT on first bio allocation. (Not relevant since
>    __GFP_WAIT is not used)
> 
> * Added an extra patch:
>  - [PATCH 2/2] osdblk: Adjust queue limits to lower device's limits
> 
> This is ontop of the post-merge tree. Jeff? will you push this driver
> through your tree?
> 
> What is left is to bang some serious testing on this driver. I'll do
> that next.

The changes look reasonable to me...   if you wanted to get it into your 
tree and push it with other OSD stuff, that would be fine to me.

I think you are in a better position to deal with all the pre-req's, and 
in a better position to test osdblk more completely.

Have you messed around with the user tools yet?  osdblk needs a tool 
that creates an OSD object of a specified size, etc.

	Jeff




