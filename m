From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] block: fix SG_[GS]ET_RESERVED_SIZE ioctl when
 max_sectors is huge
Date: Wed, 28 May 2014 03:38:34 -0700
Message-ID: <20140528103834.GB13542@infradead.org>
References: <1401021816-10423-1-git-send-email-akinobu.mita@gmail.com>
 <1401021816-10423-3-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53207 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaE1Kif (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 06:38:35 -0400
Content-Disposition: inline
In-Reply-To: <1401021816-10423-3-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

On Sun, May 25, 2014 at 09:43:34PM +0900, Akinobu Mita wrote:
> SG_GET_RESERVED_SIZE and SG_SET_RESERVED_SIZE ioctls access a reserved
> buffer in bytes as int type.  The value needs to be capped at the request
> queue's max_sectors.  But integer overflow is not correctly handled in
> the calculation when converting max_sectors from sectors to bytes.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
