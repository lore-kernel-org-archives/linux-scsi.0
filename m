From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH, scsi-block-2.6] remove bio_map_user
Date: Mon, 20 Jun 2005 12:41:14 +0200
Message-ID: <20050620104114.GD15021@suse.de>
References: <20050619092946.GA16872@lst.de> <20050620103709.GA15021@suse.de> <20050620103656.GA4164@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:36574 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261183AbVFTKj4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 06:39:56 -0400
Content-Disposition: inline
In-Reply-To: <20050620103656.GA4164@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Jun 20 2005, Christoph Hellwig wrote:
> On Mon, Jun 20, 2005 at 12:37:13PM +0200, Jens Axboe wrote:
> > On Sun, Jun 19 2005, Christoph Hellwig wrote:
> > > It's only used by blk_rq_map_user and that's the only sensible caller.
> > 
> > That's not really true, there is/are valid uses of bio_map_user() alone.
> 
> That would be?

Stacking drivers or file systems.

> > 
> > > So do the iov wrapping there and kill bio_map_user.
> > 
> > While I do agree with the change, I know of external users of
> > bio_map_user().
> 
> Who's that?

ocfs2, iirc.

-- 
Jens Axboe

