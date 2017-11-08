From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-mq: Avoid that request queue removal can trigger list
 corruption
Date: Wed, 8 Nov 2017 11:32:42 -0700
Message-ID: <09b1199a-6ddf-ff5a-8f3b-99fc7a07937b@kernel.dk>
References: <20171108182345.8616-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171108182345.8616-1-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 11/08/2017 11:23 AM, Bart Van Assche wrote:
> Avoid that removal of a request queue sporadically triggers the
> following warning:
> 
> list_del corruption. next->prev should be ffff8807d649b970, but was 6b6b6b6b6b6b6b6b
> WARNING: CPU: 3 PID: 342 at lib/list_debug.c:56 __list_del_entry_valid+0x92/0xa0
> Call Trace:
>  process_one_work+0x11b/0x660
>  worker_thread+0x3d/0x3b0
>  kthread+0x129/0x140
>  ret_from_fork+0x27/0x40

Looks good to me, applied.

-- 
Jens Axboe
