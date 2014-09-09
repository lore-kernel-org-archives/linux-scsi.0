From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] block: introduce blk_init_flush and its pair
Date: Tue, 9 Sep 2014 11:36:07 -0700
Message-ID: <20140909183607.GB16750@infradead.org>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
 <1410267949-21904-3-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42228 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaIISgI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Sep 2014 14:36:08 -0400
Content-Disposition: inline
In-Reply-To: <1410267949-21904-3-git-send-email-ming.lei@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Tue, Sep 09, 2014 at 09:05:43PM +0800, Ming Lei wrote:
> These two functions are introduced to initialize and de-initialize
> flush stuff centrally.
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
