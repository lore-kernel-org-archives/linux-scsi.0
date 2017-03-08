From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/4] block: Make del_gendisk() safer for disks without
 queues
Date: Wed, 8 Mar 2017 17:57:24 -0500
Message-ID: <20170308225724.GD21117@htj.duckdns.org>
References: <20170308164834.14302-1-jack@suse.cz>
 <20170308164834.14302-4-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170308164834.14302-4-jack@suse.cz>
Sender: linux-block-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Omar Sandoval <osandov@osandov.com>, Arthur Marsh <arthur.marsh@internode.on.net>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 08, 2017 at 05:48:33PM +0100, Jan Kara wrote:
> Commit 165a5e22fafb "block: Move bdi_unregister() to del_gendisk()"
> added disk->queue dereference to del_gendisk(). Although del_gendisk()
> is not supposed to be called without disk->queue valid and
> blk_unregister_queue() warns in that case, this change will make it oops
> instead. Return to the old more robust behavior of just warning when
> del_gendisk() gets called for gendisk with disk->queue being NULL.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
