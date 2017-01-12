From: "Stephen Bates" <sbates@raithlin.com>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Wed, 11 Jan 2017 22:36:51 -0600
Message-ID: <43b3038b57ed5c00a73ebc5457d048d5.squirrel@webmail.raithlin.com>
References: <20170111134312.GH6286@linux-x5ow.site>
    <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Keith Busch <keith.busch@intel.com>
List-Id: linux-scsi@vger.kernel.org

>>
>> I'd like to attend LSF/MM and would like to discuss polling for block
>> drivers.
>>
>> Currently there is blk-iopoll but it is neither as widely used as NAPI
>> in the networking field and accoring to Sagi's findings in [1]
>> performance with polling is not on par with IRQ usage.
>>
>> On LSF/MM I'd like to whether it is desirable to have NAPI like polling
>> in more block drivers and how to overcome the currently seen performance
>> issues.
>
> It would be an interesting topic to discuss, as it is a shame that
> blk-iopoll isn't used more widely.
>
> --
> Jens Axboe
>

I'd also be interested in this topic. Given that iopoll only really makes
sense for low-latency, low queue depth environments (i.e. down below
10-20us) I'd like to discuss which drivers we think will need/want to be
upgraded (aside from NVMe ;-)).

I'd also be interested in discussing how best to enable and disable
polling. In the past some of us have pushed for a "big hammer" to turn
polling on for a given device or HW queue [1]. I'd like to discuss this
again as well as looking at other methods above and beyond the preadv2
system call and the HIPRI flag.

Stephen

[1] http://marc.info/?l=linux-block&m=146307410101827&w=2

> _______________________________________________
> Linux-nvme mailing list
> Linux-nvme@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-nvme
>
>
