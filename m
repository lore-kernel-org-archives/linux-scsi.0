From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Thu, 19 Jan 2017 18:57:46 +0800
Message-ID: <CACVXFVP=mdetwMds9W-YL22ghW3ra4R9=RAnWrKdb6G-jjuqFA@mail.gmail.com>
References: <20170111134312.GH6286@linux-x5ow.site> <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, linux-block <linux-block@vger.kernel.org>, Linux SCSI List <Linux-scsi@vger.kernel.org>, Sagi Grimberg <sagi@grimberg.me>, linux-nvme <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 11, 2017 at 11:07 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 01/11/2017 06:43 AM, Johannes Thumshirn wrote:
>> Hi all,
>>
>> I'd like to attend LSF/MM and would like to discuss polling for block drivers.
>>
>> Currently there is blk-iopoll but it is neither as widely used as NAPI in the
>> networking field and accoring to Sagi's findings in [1] performance with
>> polling is not on par with IRQ usage.
>>
>> On LSF/MM I'd like to whether it is desirable to have NAPI like polling in
>> more block drivers and how to overcome the currently seen performance issues.
>
> It would be an interesting topic to discuss, as it is a shame that blk-iopoll
> isn't used more widely.

I remembered that Keith and I discussed some issues of blk-iopoll:

    http://marc.info/?l=linux-block&m=147576999016407&w=2

seems which isn't addressed yet.


Thanks,
Ming Lei
