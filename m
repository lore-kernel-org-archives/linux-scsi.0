From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH] blk-mq drivers: untangle 0 and BLK_MQ_RQ_QUEUE_OK
Date: Mon, 14 Nov 2016 20:54:56 -0700
Message-ID: <f9b19a2b-6424-d8c7-d243-113af2b5fde5@fb.com>
References: <6ac81fdd561e008fec1f31e9a4530358737389a6.1479167141.git.osandov@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <6ac81fdd561e008fec1f31e9a4530358737389a6.1479167141.git.osandov@fb.com>
Sender: linux-block-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>, linux-block@vger.kernel.org
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, kernel-team@fb.com
List-Id: linux-scsi@vger.kernel.org

On 11/14/2016 04:49 PM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> Let's not depend on any of the BLK_MQ_RQ_QUEUE_* constants having
> specific values. No functional change.
>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> Hi, Jens,
>
> Some more trivial cleanup, feel free to apply or not if it's too intrusive.

I think we should clean it up. But you should split this patch in two -
one for NVMe, and one for SCSI.

And it should be against for-4.10/block, the nvme parts don't apply
without fuzz.

-- 
Jens Axboe

