From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] block: fix BLKSECTGET ioctl when max_sectors is
 greater than USHRT_MAX
Date: Wed, 28 May 2014 03:38:18 -0700
Message-ID: <20140528103818.GA13542@infradead.org>
References: <1401021816-10423-1-git-send-email-akinobu.mita@gmail.com>
 <1401021816-10423-2-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52849 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaE1KiT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 06:38:19 -0400
Content-Disposition: inline
In-Reply-To: <1401021816-10423-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

On Sun, May 25, 2014 at 09:43:33PM +0900, Akinobu Mita wrote:
> BLKSECTGET ioctl loads the request queue's max_sectors as unsigned
> short value to the argument pointer.  So if the max_sector is greater
> than USHRT_MAX, the upper 16 bits of that is just discarded.
> 
> In such case, USHRT_MAX is more preferable than the lower 16 bits of
> max_sectors.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
