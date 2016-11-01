From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/3] blk-mq: export blk_mq_map_queues
Date: Tue, 1 Nov 2016 10:02:51 -0600
Message-ID: <20161101160251.GA9797@kernel.dk>
References: <1478009569-19026-1-git-send-email-hch@lst.de>
 <1478009569-19026-2-git-send-email-hch@lst.de>
 <yq1lgx319jl.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1lgx319jl.fsf@sermon.lab.mkp.net>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, don.brace@microsemi.com, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 01 2016, Martin K. Petersen wrote:
> >>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:
> 
> Christoph> This will allow SCSI to have a single blk_mq_ops structure
> Christoph> that either lets the LLDD map the queues to PCIe MSIx vectors
> Christoph> or use the default.
> 
> Jens, any objection to me funneling this change through the SCSI tree?

No, that's fine, you can add my reviewed-by.

-- 
Jens Axboe

