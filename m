From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v5 1/2] scsi: hisi_sas: Add support for DIF feature for v2
 hw
Date: Wed, 19 Dec 2018 15:02:17 +0000
Message-ID: <66f049e4-912c-5e4d-5cd2-4e1586715b2e@huawei.com>
References: <1545057608-89965-1-git-send-email-john.garry@huawei.com>
 <1545057608-89965-2-git-send-email-john.garry@huawei.com>
 <yq1pntygmlk.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1pntygmlk.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 19/12/2018 04:35, Martin K. Petersen wrote:
>
> John,
>
>> From: Xiang Chen <chenxiang66@hisilicon.com>
>>
>> For v3 hw, we support DIF operation for SAS, but not SATA.
>>
>> In addition, DIF CRC16 is supported.
>>
>> This patchset adds the SW support for the described features. The main
>> components are as follows:
>> - Get protection mask from module param
>> - Fill PI fields
>> - Fill related to DIF in DQ and protection iu memories
>
> Applied to 4.21/scsi-queue, thanks!
>

Thanks, and we're still looking at the DIX issue.

John
