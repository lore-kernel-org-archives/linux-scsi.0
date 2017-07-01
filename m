From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: hisi_sas: optimise DMA slot memory
Date: Sat, 01 Jul 2017 17:07:22 -0400
Message-ID: <yq137afx3w5.fsf@oracle.com>
References: <1498741334-171060-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498741334-171060-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Thu, 29 Jun 2017 21:02:14 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>
List-Id: linux-scsi@vger.kernel.org


John,

> Currently we allocate 3 sets of DMA memories from separate
> pools for each slot. This is inefficient in terms of memory usage
> (buffers are less than 1 page in size, so we lose due to alignment),
> and also time spent in doing 3 allocations + de-allocations per slot,
> instead of 1.
>
> To optimise, combine the 3 DMA buffers into a single buffer from a
> single pool.

Applied to 4.13/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
