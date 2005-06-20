From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, scsi-block-2.6] ll_rw_blk.c kerneldoc fixups
Date: Mon, 20 Jun 2005 12:40:35 +0200
Message-ID: <20050620104035.GA4246@lst.de>
References: <20050619093211.GC16872@lst.de> <20050620104044.GC15021@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:6848 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261183AbVFTKkl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 06:40:41 -0400
Content-Disposition: inline
In-Reply-To: <20050620104044.GC15021@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Jun 20, 2005 at 12:40:44PM +0200, Jens Axboe wrote:
> On Sun, Jun 19 2005, Christoph Hellwig wrote:
> > @@ -2098,14 +2098,14 @@
> >   *    Data will be mapped directly for zero copy io, if possible. Otherwise
> >   *    a kernel bounce buffer is used.
> >   *
> > - *    A matching blk_rq_unmap_user() must be issued at the end of io, while
> > - *    still in process context.
> > + *    A matching blk_rq_unmap_user_iov() must be issued at the end of io,
> > + *    while still in process context.
> 
> ?

This is ontop of my patch to remove the non-iov variant.

> > @@ -2221,9 +2220,10 @@
> >  /**
> >   * blk_rq_map_kern - map kernel data to a request, for REQ_BLOCK_PC usage
> >   * @q:		request queue where request should be inserted
> > - * @rw:		READ or WRITE data
> > + * @rw:		request to fill
> 
> @rq
> 
> Rest looks good, care to rediff it?

Yeah, will do so later.

