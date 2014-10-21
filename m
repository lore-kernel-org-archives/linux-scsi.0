From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 11/12] IB/srp: Eliminate free_reqs list
Date: Tue, 21 Oct 2014 01:49:21 -0700
Message-ID: <20141021084921.GA10407@infradead.org>
References: <5433E43D.3010107@acm.org>
 <5433E56E.6010600@acm.org>
 <20141017105939.GB7819@infradead.org>
 <5444F669.1020803@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49837 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaJUItZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2014 04:49:25 -0400
Content-Disposition: inline
In-Reply-To: <5444F669.1020803@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On Mon, Oct 20, 2014 at 01:47:53PM +0200, Bart Van Assche wrote:
> The only reason why patches 10/12 and 11/12 are separate patches
> is to reduce the size of individual patches and hence to make it
> easier to review these patches. If everyone agrees I'm fine with
> folding patch 11/12 into patch 10/12.

I would prefer to merge the two patches.

