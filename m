From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 02/12] blk-mq: Add blk_mq_unique_tag()
Date: Sat, 11 Oct 2014 04:08:41 -0700
Message-ID: <20141011110841.GA9593@infradead.org>
References: <5433E43D.3010107@acm.org>
 <5433E493.9030304@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47257 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaJKLIu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Oct 2014 07:08:50 -0400
Content-Disposition: inline
In-Reply-To: <5433E493.9030304@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

> +static inline u32 blk_mq_build_unique_tag(int hwq, int tag)
> +{
> +	return (hwq << BLK_MQ_UNIQUE_TAG_BITS) | (tag & BLK_MQ_UNIQUE_TAG_MASK);
> +}

Is there any value in having this as a separate helper?

