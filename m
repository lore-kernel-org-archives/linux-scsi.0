From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V5 00/14] blk-mq-sched: improve sequential I/O
 performance(part 1)
Date: Tue, 10 Oct 2017 14:34:39 +0200
Message-ID: <20171010123439.7lzndy5qcjtmd56y@linux-x5ow.site>
References: <20170930102720.30219-1-ming.lei@redhat.com>
 <1e56f7e1-2a2f-26c9-9c74-97e0d22bc98b@huawei.com>
 <20171009150439.GA30189@ming.t460p>
 <20171010014653.GA3247@ming.t460p>
 <cb622a02-5187-5ee0-bccd-e867e8e7ee7d@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cb622a02-5187-5ee0-bccd-e867e8e7ee7d@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Hi John,

On Tue, Oct 10, 2017 at 01:24:52PM +0100, John Garry wrote:
> It's using cfq (for non-mq) and mq-deadline (obviously for mq).

Please be aware that cfq and mq-deadline are _not_ comparable, for a realistic
comparasion please use deadline and mq-deadline or cfq and bfq.

> root@(none)$ pwd
> /sys/devices/platform/HISI0162:01/host0/port-0:0/expander-0:0/port-0:0:7/end_device-0:0:7
> root@(none)$ more ./target0:0:3/0:0:3:0/block/sdd/queue/scheduler
> noop [cfq]

Maybe missing CONFIG_IOSCHED_DEADLINE?

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
