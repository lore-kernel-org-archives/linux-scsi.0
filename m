From: John Garry <john.garry@huawei.com>
Subject: Re: [RFC] scsi: switch to scsi-mq by default
Date: Wed, 4 Jul 2018 09:18:23 +0100
Message-ID: <282521f4-762c-86a5-5ac8-f8cc33b050cc@huawei.com>
References: <20180703065413.6098-1-jthumshirn@suse.de>
 <7ab21471b799d2a60ccfd8579b2548f58915568a.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7ab21471b799d2a60ccfd8579b2548f58915568a.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, chenxiang <chenxiang66@hisilicon.com>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 04/07/2018 00:21, Bart Van Assche wrote:
> On Tue, 2018-07-03 at 08:54 +0200, Johannes Thumshirn wrote:
>> It has been more than one year since we tried to change the default
>> from legacy to multi queue in SCSI. Back then we had to retract the
>> change because of performance issues with rotating disks.
>>
>> In the meantime there have been a substantial amount of performance
>> improvements, thus we can re-enable scsi-mq without a significant
>> performance penalty.
>
> Hello Johannes,
>
> Please include references to commits cbe7dfa26eee ("Revert "scsi:
> default to scsi-mq"") and 5c279bd9e406 ("scsi: default to scsi-mq").
> I think it's a good idea to mention that suspend/resume now works
> with scsi-mq.
>
> Bart.

We were seeing performance drops previously for hisi_sas when originally 
enabled by default, but results on 4.18 seem almost identical with and 
without MQ default.

FWIW,

Acked-by: John Garry <john.garry@huawei.com>

>
>
>
>
>
>
>
>
