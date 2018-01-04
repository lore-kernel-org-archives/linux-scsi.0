From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v5 3/7] scsi: libsas: make the event threshold
 configurable
Date: Thu, 4 Jan 2018 10:04:25 +0000
Message-ID: <f98751d7-5a95-5343-f51c-7d08a75f63fc@huawei.com>
References: <20171208094210.24887-1-yanaijie@huawei.com>
 <20171208094210.24887-4-yanaijie@huawei.com>
 <3fa0a96f-26d5-dbd7-8b8d-67e615ddf2b6@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3fa0a96f-26d5-dbd7-8b8d-67e615ddf2b6@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, Raj.Dinesh@microsemi.com, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, xiyou.wangcong@gmail.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 15/12/2017 12:19, Hannes Reinecke wrote:
> On 12/08/2017 10:42 AM, Jason Yan wrote:
>> Add a sysfs attr that LLDD can configure it for every host. We made
>> a example in hisi_sas. Other LLDDs using libsas can implement it if
>> they want.
>>
>> Suggested-by: Hannes Reinecke <hare@suse.com>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> CC: John Garry <john.garry@huawei.com>
>> CC: Johannes Thumshirn <jthumshirn@suse.de>
>> CC: Ewan Milne <emilne@redhat.com>
>> CC: Christoph Hellwig <hch@lst.de>
>> CC: Tomas Henzl <thenzl@redhat.com>
>> CC: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/scsi/hisi_sas/hisi_sas_main.c |  6 ++++++
>>  drivers/scsi/libsas/sas_init.c        | 31 +++++++++++++++++++++++++++++++
>>  include/scsi/libsas.h                 |  1 +
>>  3 files changed, 38 insertions(+)
>>
> Ah, here is it now.
> So ignore that part of my previous comment.
>

Hi Hannes,

Thanks for checking this.

Can you please re-review "[PATCH v5 2/7] scsi: libsas: shut down the PHY 
if events reached the threshold" to see if you are happy with it? We 
have no tag currently.

Very much appreciated,
John

> Reviewed-by: Hannes Reinecke <hare@suse.com>
>
> Cheers,
>
> Hannes
>
