From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, scsi-block-2.6] ll_rw_blk.c kerneldoc fixups
Date: Mon, 20 Jun 2005 14:38:12 +0200
Message-ID: <20050620123812.GA6313@lst.de>
References: <20050619093211.GC16872@lst.de> <20050620122425.GH15021@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:7362 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261242AbVFTMiP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 08:38:15 -0400
Content-Disposition: inline
In-Reply-To: <20050620122425.GH15021@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Jun 20, 2005 at 02:24:27PM +0200, Jens Axboe wrote:
> On Sun, Jun 19 2005, Christoph Hellwig wrote:
> 
> I've committed a modified patch based on this. There was a typo in the
> blk_execute_rq_nowait() kerneldoc update as well, you duplicated the
> name from blk_execute_rq().
> 
> It's committed to the rq-map branch of the linux-2.6-block.git tree.
> 
> (http://kernel.org/git/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=summary)

James, is this the branch you pull into scsi-block-2.6.git?  I try to
avoid getting lost in all those trees..

