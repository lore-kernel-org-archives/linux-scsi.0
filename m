From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] sg: add SG_FLAG_Q_AT_TAIL flag
Date: Thu, 5 Jun 2014 02:24:10 -0700
Message-ID: <20140605092410.GA727@infradead.org>
References: <538F3416.5090306@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38501 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaFEJYK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2014 05:24:10 -0400
Content-Disposition: inline
In-Reply-To: <538F3416.5090306@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, James Bottomley <JBottomley@parallels.com>, openosd@gmail.com

On Wed, Jun 04, 2014 at 10:58:30AM -0400, Douglas Gilbert wrote:
> When the SG_IO ioctl was copied into the block layer and
> later into the bsg driver, subtle differences emerged.
> 
> One difference is the way injected commands are queued through
> the block layer (i.e. this is not SCSI device queueing nor SATA
> NCQ). Summarizing:
>   - SG_IO in the block layer: blk_exec*(at_head=false)
>   - sg SG_IO: at_head=true
>   - bsg SG_IO: at_head=true
> 
> Some time ago Boaz Harrosh introduced a sg v4 flag called
> BSG_FLAG_Q_AT_TAIL to override the bsg driver default.
> This patch does the equivalent for the sg driver.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Any chance to get a patch for the block-layer SG_IO code, too?

