From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v4 2/5] scsi: hisi_sas: Relocate some code to reduce
 complexity
Date: Fri, 7 Dec 2018 10:07:13 +0000
Message-ID: <0cfe35c7-89c4-b65a-ba25-dfcf5d59a564@huawei.com>
References: <1544103284-100497-1-git-send-email-john.garry@huawei.com>
 <1544103284-100497-3-git-send-email-john.garry@huawei.com>
 <c7ec9e23-6da8-35e0-1996-02db3d640f4b@suse.de>
 <2da87e22-1bbc-aff9-c0be-85a3fd8f4393@huawei.com>
 <778770d5-b377-2aaa-c2a0-9c548de74f17@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <778770d5-b377-2aaa-c2a0-9c548de74f17@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 06/12/2018 16:20, Johannes Thumshirn wrote:
> On 06/12/2018 16:37, John Garry wrote:
>> which is important. Let me know if you disagree and I can change it.
>
> Sure, it's your driver. It was just because the patch is even titled
> "Relocate some code to reduce complexity", so I thought of reducing the
> complexity for readers even further (like you don't need the line wrap
> at 80 chars, and so on).
>
> Byte,
> 	Johannes
>

I would rather not change if you don't mind. When we say "reduce 
complexity", we are talking about moving the DMA mapping code from the 
task prep function, as, when we add the DIX-related DMA mapping code, 
leaving all the DMA mapping code in the task prep function would make it 
a monster.

Thanks,
John
