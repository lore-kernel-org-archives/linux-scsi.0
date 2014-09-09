From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] blk-mq: allocate flush_rq in blk_mq_init_flush()
Date: Tue, 9 Sep 2014 11:35:23 -0700
Message-ID: <20140909183523.GA16750@infradead.org>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
 <1410267949-21904-2-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1410267949-21904-2-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 09, 2014 at 09:05:42PM +0800, Ming Lei wrote:
> It is reasonable to allocate flush req in blk_mq_init_flush().
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
