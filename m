From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH, scsi-block-2.6] remove bio_map_user
Date: Mon, 20 Jun 2005 12:37:13 +0200
Message-ID: <20050620103709.GA15021@suse.de>
References: <20050619092946.GA16872@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:48092 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261153AbVFTKf7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 06:35:59 -0400
Content-Disposition: inline
In-Reply-To: <20050619092946.GA16872@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Sun, Jun 19 2005, Christoph Hellwig wrote:
> It's only used by blk_rq_map_user and that's the only sensible caller.

That's not really true, there is/are valid uses of bio_map_user() alone.

> So do the iov wrapping there and kill bio_map_user.

While I do agree with the change, I know of external users of
bio_map_user(). It's a really trivial piece of code, so I would rather
just let bio_map_user() stay as-is.


-- 
Jens Axboe

