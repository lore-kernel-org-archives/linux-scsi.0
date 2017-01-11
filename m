From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 01/15] virtio_blk: avoid DMA to stack for the sense buffer
Date: Wed, 11 Jan 2017 09:26:46 +0100
Message-ID: <20170111082646.GA6286@linux-x5ow.site>
References: <1484060780-15592-1-git-send-email-hch@lst.de>
 <1484060780-15592-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484060780-15592-2-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 10, 2017 at 04:06:06PM +0100, Christoph Hellwig wrote:
> Most users of BLOCK_PC requests allocate the sense buffer on the stack,
> so to avoid DMA to the stack copy them to a field in the heap allocated
> virtblk_req structure.  Without that any attempt at SCSI passthrough I/O,
> including the SG_IO ioctl from userspace will crash the kernel.  Note that
> this includes running tools like hdparm even when the host does not have
> SCSI passthrough enabled.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Isn't that one already queued in Jens' tree?

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
