From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH v3 2/7] libsas: remove unused port_gone_completion
Date: Wed, 12 Jul 2017 10:18:31 +0800
Message-ID: <596586F7.80307@huawei.com>
References: <1499670369-44143-1-git-send-email-wangyijing@huawei.com>
 <1499670369-44143-3-git-send-email-wangyijing@huawei.com>
 <e76b392c-8fd7-9907-9a10-87b8c5b737dc@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e76b392c-8fd7-9907-9a10-87b8c5b737dc@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chenqilin2@huawei.com, hare@suse.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, yanaijie@huawei.com, hch@lst.de, dan.j.williams@intel.com, emilne@redhat.com, thenzl@redhat.com, wefu@redhat.com, charles.chenxin@huawei.com, chenweilong@huawei.com, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org



在 2017/7/11 23:54, John Garry 写道:
> On 10/07/2017 08:06, Yijing Wang wrote:
>> No one uses the port_gone_completion in struct asd_sas_port,
>> clean it out.
> 
> This seems like a reasonable tidy-up patch which could be taken in isolation, having no dependency on the rest of the series.

Yes.

> 
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  include/scsi/libsas.h | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
>> index c41328d..628f48b 100644
>> --- a/include/scsi/libsas.h
>> +++ b/include/scsi/libsas.h
>> @@ -263,8 +263,6 @@ struct sas_discovery {
>>  /* The port struct is Class:RW, driver:RO */
>>  struct asd_sas_port {
>>  /* private: */
>> -    struct completion port_gone_completion;
>> -
>>      struct sas_discovery disc;
>>      struct domain_device *port_dev;
>>      spinlock_t dev_list_lock;
>>
> 
> 
> 
> .
> 
