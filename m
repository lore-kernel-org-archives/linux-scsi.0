From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Write same support
Date: Thu, 16 Feb 2012 16:09:17 -0500
Message-ID: <20120216210916.GA29691@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
 <20120216200202.GA27311@redhat.com>
 <yq1hayqa4ls.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab2BPVJV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2012 16:09:21 -0500
Content-Disposition: inline
In-Reply-To: <yq1hayqa4ls.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com

On Thu, Feb 16 2012 at  3:46pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> Given the feedback you've gotten so far I'd imagine you're well on
> Mike> your way with a new patchset (building on your discard merge
> Mike> cleanup, etc).
> 
> Yeah, tweaked a few things based on your comments.
> 
> 
> Mike> I think it'd be more appropriate to put patch 4 and 5 (scsi
> Mike> support) at the beginning of the patchset (block interfaces aren't
> Mike> functional without underlying scsi support).
> 
> The SCSI patches depend on the block layer ditto (topology parameters
> need to be present, etc.).

Ah ok, I missed the call to blk_queue_max_write_same_sectors().

> Also, we always do it this way so we can get the block layer changes in
> during the merge window and then add the SCSI bits to the post-merge
> tree.

Got it, thanks.
