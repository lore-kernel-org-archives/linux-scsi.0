From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH] blk-mq: handle the single queue case in blk_mq_hctx_next_cpu
Date: Mon, 24 Nov 2014 08:02:32 -0700
Message-ID: <54734888.8020008@fb.com>
References: <1416817643-17888-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416817643-17888-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/24/2014 01:27 AM, Christoph Hellwig wrote:
> Don't duplicate the code to handle the not cpu bounce case in the
> caller, do it inside blk_mq_hctx_next_cpu instead.

Thanks, applied.

-- 
Jens Axboe
