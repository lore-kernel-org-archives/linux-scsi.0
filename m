From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] blk_rq_unmap_user: remove superflous ulen argument
Date: Tue, 7 Nov 2006 18:42:12 +0100
Message-ID: <20061107174211.GX19471@kernel.dk>
References: <20061107173043.GA14371@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:31038 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S932748AbWKGRkA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2006 12:40:00 -0500
Content-Disposition: inline
In-Reply-To: <20061107173043.GA14371@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Tue, Nov 07 2006, Christoph Hellwig wrote:
> blk_rq_unmap_user does not use it's ulen argument at all, and a patch
> I'm working on can't easily provide it.  So let's just remove the
> argument.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Jens Axboe <jens.axboe@oracle.com>

I'll add this patch going upstream.

-- 
Jens Axboe

