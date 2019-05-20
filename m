From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: libsas: no need to join wide port again in
 sas_ex_discover_dev()
Date: Mon, 20 May 2019 13:39:00 +0100
Message-ID: <83a50fae-78f4-d236-a007-7e8d95553415@huawei.com>
References: <20190518094057.18046-1-yanaijie@huawei.com>
 <1860c624-1216-bb84-7091-d41a4d43f244@huawei.com>
 <61b6d28d-7b5f-f078-c035-77e855fbe8bf@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <61b6d28d-7b5f-f078-c035-77e855fbe8bf@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, miaoxie@huawei.com, zhaohongjiang@huawei.com
List-Id: linux-scsi@vger.kernel.org

On 20/05/2019 13:06, Jason Yan wrote:
> OK.
>
>>
>> In case of "second fanout expander...", before this, we don't attempt
>> to discover, and just disable the PHY. In that case, is the log proper?
>>
>
> In that case the log is not proper. I think we can directly return in
> the case of "second fanout expander..."? Actually nothing to do after
> the phy is disabled.

Yeah, that looks fine.

>
>> And, if indeed proper, it would seem to merit a higher log level than
>> debug, maybe notice is better.
