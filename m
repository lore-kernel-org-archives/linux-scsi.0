From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH 0/8] block: per-distpatch_queue flush machinery
Date: Tue, 9 Sep 2014 23:38:32 +0800
Message-ID: <CACVXFVN3tTJGJqcykwBhS6fzRuQd-9kYmFQqKC_39Hdb9=N9GA@mail.gmail.com>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
	<20140909152028.GA13699@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140909152028.GA13699@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 9, 2014 at 11:20 PM, Christoph Hellwig <hch@lst.de> wrote:
> Hi Ming,
>
> thanks for doing this work!
>
> I've only taken a very cursory look at the series and I like most of it.
>
> But can you explain why you're not simply incrementing the number of
> allocated requests in the blk-mq request allocation code instead of
> allocating the flush request separately in the last patch?

Requests in tag_set may be shared by more than one queues, but flush
rq per hctx can't be shared by request queues at all.

Also it is simple to put it inside the introduce blk_flush_queue.

Thanks,
