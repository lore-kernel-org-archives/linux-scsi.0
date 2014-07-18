From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] blk-mq: pass along blk_mq_alloc_tag_set return
	values
Date: Fri, 18 Jul 2014 11:45:59 +0200
Message-ID: <20140718094559.GB2121@lst.de>
References: <20140717193707.1924.87867.stgit@beardog.cce.hp.com> <20140717193915.1924.24620.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140717193915.1924.24620.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert Elliott <elliott@hp.com>
Cc: axboe@kernel.dk, abhijit.mahajan@avagotech.com, kmo@datarainc.com, nagalakshmi.nandigama@avagotech.com, asamymuthupa@micron.com, snitzer@redhat.com, JBottomley@parallels.com, relliott@beardog.cce.hp.com, sreekanth.reddy@avagotech.com, praveen.krishnamoorthy@avagotech.com, agordeev@redhat.com, scameron@beardog.cce.hp.com, tom.leiming@gmail.com, sbradshaw@micron.com, hch@lst.de, m@bjorling.me, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 17, 2014 at 02:39:21PM -0500, Robert Elliott wrote:
> Two of the blk-mq based drivers do not pass back the return value
> from blk_mq_alloc_tag_set, instead just returning -ENOMEM.
> 
> blk_mq_alloc_tag_set returns -EINVAL if the number of queues or
> queue depth is bad.  -ENOMEM implies that retrying after freeing some
> memory might be more successful, but that won't ever change
> in the -EINVAL cases.
> 
> Change the null_blk and mtip32xx drivers to pass along
> the return value.
> 
> Signed-off-by: Robert Elliott <elliott@hp.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
