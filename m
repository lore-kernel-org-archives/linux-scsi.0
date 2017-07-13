From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH v3 6/7] libsas: add wait-complete support to sync
 discovery event
Date: Thu, 13 Jul 2017 10:19:44 +0800
Message-ID: <5966D8C0.4090908@huawei.com>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
 <1499670369-44143-7-git-send-email-wangyijing@huawei.com>
 <afd1b55c-c5d2-237d-7727-31f7305decaa@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <afd1b55c-c5d2-237d-7727-31f7305decaa@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, Johannes Thumshirn <jthumshirn@suse.de>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org



在 2017/7/12 21:51, John Garry 写道:
> On 10/07/2017 08:06, Yijing Wang wrote:
>>
>>  static void sas_chain_event(int event, unsigned long *pending,
>> @@ -592,9 +596,9 @@ int sas_discover_event(struct asd_sas_port *port, enum discover_event ev)
>>  {
>>      struct sas_discovery *disc;
>>
>> +    disc = &port->disc;
>>      if (!port)
>>          return 0;
>> -    disc = &port->disc;
>>
>>      BUG_ON(ev >= DISC_NUM_EVENTS);
>>
>> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
>> index 570b2cb..9d26c28 1
> 
> I was just looking through the code and I noticed this, above. Is there a specific reason to move the NULL check, or was it modified accidentally?
> 
> I mean, if port is NULL I don't think we would get as far as checking it as we would have already de-referenced it.

Oh, sorry, it's a accidental change, good catch, thanks!

> 
> 
> 
> .
> 
