From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/16] block: simplify blk_init_allocated_queue
Date: Tue, 24 Jan 2017 08:37:16 +0100
Message-ID: <cb49deea-e15f-aaca-60ef-7a642532c2e9@suse.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
 <1485185361-29786-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1485185361-29786-3-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 01/23/2017 04:29 PM, Christoph Hellwig wrote:
> Return an errno value instead of the passed in queue so that the callers
> don't have to keep track of two queues, and move the assignment of the
> request_fn and lock to the caller as passing them as argument doesn't
> simplify anything.  While we're at it also remove two pointless NULL
> assignments, given that the request structure is zeroed on allocation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-core.c       | 38 +++++++++++++++-----------------------
>  drivers/md/dm-rq.c     |  3 ++-
>  include/linux/blkdev.h |  3 +--
>  3 files changed, 18 insertions(+), 26 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
