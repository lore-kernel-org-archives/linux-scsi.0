From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] block: move flush initialized stuff to blk_flush_init
Date: Tue, 9 Sep 2014 11:37:21 -0700
Message-ID: <20140909183721.GC16750@infradead.org>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
 <1410267949-21904-4-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42274 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaIIShX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Sep 2014 14:37:23 -0400
Content-Disposition: inline
In-Reply-To: <1410267949-21904-4-git-send-email-ming.lei@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Tue, Sep 09, 2014 at 09:05:44PM +0800, Ming Lei wrote:
> These stuff is always used with flush req together, so
> we can do that safely.

Little wording nitpick:

in the subject s/initialized stuff/initialization/

and in the body:

These fields are always used with the flush request, so initialize them
together.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
