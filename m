From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 0/8] IB/srp: Add multichannel support
Date: Mon, 22 Sep 2014 07:37:31 -0700
Message-ID: <20140922143731.GA15377@infradead.org>
References: <541C27BF.6070609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54867 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbaIVOhc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2014 10:37:32 -0400
Content-Disposition: inline
In-Reply-To: <541C27BF.6070609@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>

Hi Bart,

I like these changes modulo the minor comments we had.

One thing that is missing is generation multiqueue-aware tags at the
blk-mq level, which should be as simple as always adding a queue
prefix in the tag allocation code.  Did you consider switching srp
to use the block layer provided tags?

Also do you have any performance numbers for just using multiple
queues inside srp vs using blk-mq exposed queues?
