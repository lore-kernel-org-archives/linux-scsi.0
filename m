From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v4 2/5] scsi: hisi_sas: Relocate some code to reduce
 complexity
Date: Fri, 7 Dec 2018 11:53:35 +0100
Message-ID: <320284bd-bae4-f54f-ec4d-2c44df0f69b4@suse.de>
References: <1544103284-100497-1-git-send-email-john.garry@huawei.com>
 <1544103284-100497-3-git-send-email-john.garry@huawei.com>
 <c7ec9e23-6da8-35e0-1996-02db3d640f4b@suse.de>
 <2da87e22-1bbc-aff9-c0be-85a3fd8f4393@huawei.com>
 <778770d5-b377-2aaa-c2a0-9c548de74f17@suse.de>
 <0cfe35c7-89c4-b65a-ba25-dfcf5d59a564@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0cfe35c7-89c4-b65a-ba25-dfcf5d59a564@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 07/12/2018 11:07, John Garry wrote:
> On 06/12/2018 16:20, Johannes Thumshirn wrote:
>> On 06/12/2018 16:37, John Garry wrote:
>>> which is important. Let me know if you disagree and I can change it.
>>
>> Sure, it's your driver. It was just because the patch is even titled
>> "Relocate some code to reduce complexity", so I thought of reducing the
>> complexity for readers even further (like you don't need the line wrap
>> at 80 chars, and so on).
>>
>> Byte,
>>     Johannes
>>
> 
> I would rather not change if you don't mind. When we say "reduce
> complexity", we are talking about moving the DMA mapping code from the
> task prep function, as, when we add the DIX-related DMA mapping code,
> leaving all the DMA mapping code in the task prep function would make it
> a monster.

Sure


-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
