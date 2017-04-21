From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2 0/5] Re-order scsi_remove_host and sas_remove_host in
 SAS HBA LLDDs
Date: Fri, 21 Apr 2017 12:54:26 +0100
Message-ID: <20cbbdde-736c-cef5-bf58-e467a2ff5fd8@huawei.com>
References: <cover.1492760075.git.jthumshirn@suse.de>
 <f101e42e-0aed-b8ce-2f36-cf16d1964f46@huawei.com>
 <20170421083938.GD26346@linux-x5ow.site>
 <9f6fa127-4ee5-70ed-19a8-1cb4f45af40a@huawei.com>
 <20170421112032.GB17971@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:5382 "EHLO
        dggrg02-dlp.huawei.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1037108AbdDUL4U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 07:56:20 -0400
In-Reply-To: <20170421112032.GB17971@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>, tj@kernel.org, wangyijing@huawei.com, Heyousong <heyousong@huawei.com>, "chenqilin (C)" <chenqilin2@huawei.com>, Linuxarm <linuxarm@huawei.com>

On 21/04/2017 12:20, Christoph Hellwig wrote:
> On Fri, Apr 21, 2017 at 09:57:37AM +0100, John Garry wrote:
>> On 21/04/2017 09:39, Johannes Thumshirn wrote:
>>>> wangyijing already sent an RFC for fixing this issue (mentioned above),
>>>>> which was a signifiagnt rewrite of some of libsas.
>>>>> I am hoping that he would retry, and that community would support/shepherd
>>>>> this activity, or at least say it will be accepted so effort is not wasted.
>>> Do you have a link to the series? No problem if not, I'll probably can find it
>>> in my archives. Anyways, if Wangyijing is re-sending his patches please Cc me
>>> on it.
>>>
>>
>> https://marc.info/?l=linux-scsi&m=147494612310529&w=2
>
> Please repost the series against the current tree.  Also a cover
> letter with a bit more explanation would be good.
>

Great, I think that my colleagues can send an updated version next week.

Much appreciated,
John

> .
>
