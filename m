From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] some tmscsim consolidation
Date: Sun, 6 Jun 2004 22:22:41 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0406062148580.10742-100000@poirot.grange>
References: <20040606124156.GA30931@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:55252 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S264096AbUFFUat (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2004 16:30:49 -0400
In-Reply-To: <20040606124156.GA30931@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Sun, 6 Jun 2004, Christoph Hellwig wrote:

> I've looked through my old tmscsim patch queue and found this one:
>
>  - merge dc390_initDCB into dc390_slave_alloc
>  - merge DC390_release and dc390_shutdown into dc390_remove_one,
>    use del_timer_sync to make sure the timer is really deleted on
>    removal, adjust locking accordingly
>  - some tiny related cleanups

Thanks for the patch, Christoph. As you might have seen, I've already
submitted a patch, which merges _some_ of the functions above, following
your request:-). Is your patch based on something like vanilla 2.6.6, or
some bkX / preY? I'll try to find a version, to which it cleanly applies
and then re-diff with the current state.

Since you didn't sing-off for the patch, I guess, it's not yet
compulsory:-)

Thanks
Guennadi
---
Guennadi Liakhovetski


