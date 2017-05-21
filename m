From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/18] block: Introduce blk_queue_cmd_size()
Date: Sun, 21 May 2017 08:54:21 +0200
Message-ID: <20170521065421.GA13004@lst.de>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com> <20170519183016.12646-2-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170519183016.12646-2-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Omar Sandoval <osandov@fb.com>, Hannes Reinecke <hare@suse.com>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, May 19, 2017 at 11:29:59AM -0700, Bart Van Assche wrote:
> This function will be used by later patches in this series.

And it could already be used to simplify blk_alloc_flush_queue a bit..

Reviewed-by: Christoph Hellwig <hch@lst.de>
