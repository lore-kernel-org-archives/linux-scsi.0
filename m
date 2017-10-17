From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH 0/2] block/SCSI MQ: two RESTART related patches
Date: Tue, 17 Oct 2017 13:12:10 +0800
Message-ID: <20171017051209.GF15996@ming.t460p>
References: <20171017050418.22555-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171017050418.22555-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 17, 2017 at 01:04:16PM +0800, Ming Lei wrote:
> Hi Jens,
> 
> The 1st patch runs idle hctx after dealy in scsi_mq_get_budget(),
> so that we can keep same behaviour with before, and it can be
> thought as a fix.
> 
> The 2nd patch cleans up RESTART, and removes handling for TAG_SHARED
> from current blk-mq's RESTART mechanism because SCSI_MQ can covers its
> restart by itself, so that no need to handle TAG_SHARED in blk-mq
> RESTART. And >20% IOPS boost is observed in my rand read test over
> scsi_debug.
> 
> John, please test this two patches and see if it may improve your SAS
> IO performance, and you can find the two patches in the following branch:
> 
> 	https://github.com/ming1/linux/commits/blk_mq_improve_restart_V1

Forget to mention, you need to either pull the above branch directly
or apply the two patches against for-next branch of Jens' block
tree:

	git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git #for-next

-- 
Ming
