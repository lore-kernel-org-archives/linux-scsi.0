From: Christoph Hellwig <hch@lst.de>
Subject: Re: boot stall regression due to blk-mq: use percpu_ref for mq
	usage count
Date: Tue, 23 Sep 2014 07:55:54 +0200
Message-ID: <20140923055554.GA10189@lst.de>
References: <20140919113815.GA10791@lst.de> <541C8047.80705@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <541C8047.80705@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jens,

can we simply get these commits reverted from now if there's no better
fix?  I'd hate to have this boot stall in the first kernel with blk-mq
support for scsi.
