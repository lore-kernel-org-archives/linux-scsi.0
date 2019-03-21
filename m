From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: hisi_sas: Add softreset in
 hisi_sas_I_T_nexus_reset()
Date: Thu, 21 Mar 2019 10:27:15 +0000
Message-ID: <9f30134f-d9a8-4944-b5cc-46ef0bbf8f91@huawei.com>
References: <1553077294-129863-1-git-send-email-john.garry@huawei.com>
 <yq1k1gt8kt7.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1k1gt8kt7.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Luo Jiaxing <luojiaxing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 20/03/2019 18:25, Martin K. Petersen wrote:
>
> John,
>
>> We need to always follow an internal abort with a software reset, as
>> per HW programming flow, so add this.
>
> Mangled patch. Applied it by hand to 5.1/scsi-fixes but please use git
> send-email.
>

Hi Martin,

I'm not sure what happened. Patch 
https://patchwork.kernel.org/patch/10861283/mbox/ applied ok for me, and 
I did use git send-email.

Thanks,
John
