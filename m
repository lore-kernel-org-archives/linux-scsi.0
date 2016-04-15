From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 0/5] hisi_sas: v2 hw SATA fixes
Date: Fri, 15 Apr 2016 09:04:10 +0100
Message-ID: <5710A07A.3080104@huawei.com>
References: <1460107395-24501-1-git-send-email-john.garry@huawei.com>
 <yq14mb3txym.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq14mb3txym.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@linux.vnet.ibm.com, linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 15/04/2016 03:20, Martin K. Petersen wrote:
>>>>>> "John" == John Garry <john.garry@huawei.com> writes:
>
> John> This patchset introduces SATA support fixes for the HiSilicon v2
> John> hw SAS controller.
>
> John> Fixes include: - attach issue for SATA disk attached through
> John> expander - intermittent issue for directly attaching multiple SATA
> John> disks - add support for directly attaching SATA disk to phy index
> John> 4+ - ITCT config issue
>
> Applied to 4.7/scsi-queue.
>

Hi Martin,

Could these also be applied to 4.6 fixes branch? Maybe I should have 
explicitly asked.

Thanks,
John
