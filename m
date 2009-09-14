From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/7] block: use blkdev_issue_discard in
	blk_ioctl_discard
Date: Mon, 14 Sep 2009 11:40:27 +0200
Message-ID: <20090914094027.GY14984@kernel.dk>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231121.385741993@bombadil.infradead.org> <20090911222644.GA7197@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:54565 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbZINJkY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Sep 2009 05:40:24 -0400
Content-Disposition: inline
In-Reply-To: <20090911222644.GA7197@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca, matthew@wil.cx, dwmw2@infradead.org

On Fri, Sep 11 2009, Christoph Hellwig wrote:
> Jens, can we put this one and possible Dave's treat discard requests
> as writes patch in early for 2.6.32?  That'll make the discard patch
> queue quite a bit smaller and will allow easier experimenting.

Looks fine from a review, I'll include it in the for-2.6.32 branch. I
plan on asking for a pull of that tomorrow.

-- 
Jens Axboe

