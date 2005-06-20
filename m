From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH, scsi-block-2.6] ll_rw_blk.c kerneldoc fixups
Date: Mon, 20 Jun 2005 12:40:44 +0200
Message-ID: <20050620104044.GC15021@suse.de>
References: <20050619093211.GC16872@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:23262 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261177AbVFTKjY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 06:39:24 -0400
Content-Disposition: inline
In-Reply-To: <20050619093211.GC16872@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Sun, Jun 19 2005, Christoph Hellwig wrote:
> @@ -2098,14 +2098,14 @@
>   *    Data will be mapped directly for zero copy io, if possible. Otherwise
>   *    a kernel bounce buffer is used.
>   *
> - *    A matching blk_rq_unmap_user() must be issued at the end of io, while
> - *    still in process context.
> + *    A matching blk_rq_unmap_user_iov() must be issued at the end of io,
> + *    while still in process context.

?

>   *    Note: The mapped bio may need to be bounced through blk_queue_bounce()
>   *    before being submitted to the device, as pages mapped may be out of
>   *    reach. It's the callers responsibility to make sure this happens. The
> - *    original bio must be passed back in to blk_rq_unmap_user() for proper
> - *    unmapping.
> + *    original bio must be passed back in to blk_rq_unmap_user_iov() for
> + *    proper unmapping.
>   */

Ditto

> @@ -2221,9 +2220,10 @@
>  /**
>   * blk_rq_map_kern - map kernel data to a request, for REQ_BLOCK_PC usage
>   * @q:		request queue where request should be inserted
> - * @rw:		READ or WRITE data
> + * @rw:		request to fill

@rq

Rest looks good, care to rediff it?

-- 
Jens Axboe

