From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, scsi-block-2.6] remove bio_map_user
Date: Mon, 20 Jun 2005 12:36:57 +0200
Message-ID: <20050620103656.GA4164@lst.de>
References: <20050619092946.GA16872@lst.de> <20050620103709.GA15021@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:3008 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261165AbVFTKhD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 06:37:03 -0400
Content-Disposition: inline
In-Reply-To: <20050620103709.GA15021@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Jun 20, 2005 at 12:37:13PM +0200, Jens Axboe wrote:
> On Sun, Jun 19 2005, Christoph Hellwig wrote:
> > It's only used by blk_rq_map_user and that's the only sensible caller.
> 
> That's not really true, there is/are valid uses of bio_map_user() alone.

That would be?

> 
> > So do the iov wrapping there and kill bio_map_user.
> 
> While I do agree with the change, I know of external users of
> bio_map_user().

Who's that?

