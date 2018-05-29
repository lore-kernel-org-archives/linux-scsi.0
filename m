From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/13] hisi_sas: Misc improvements, bugfixes, etc.
Date: Mon, 28 May 2018 22:47:50 -0400
Message-ID: <yq1wovn2n55.fsf@oracle.com>
References: <1526897365-228549-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526897365-228549-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Mon, 21 May 2018 18:09:12 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


John,

> This patchset introduces some misc improvements, bugfixes,
> and SoC workarounds for the driver, including:

> - workaround for v2 hw reset with SATA disks attached
> - LED SGPIO support for v3 hw
> - Fix for error path in task_prep function
> - change slot and disk allocation method to avoid
>   unknown SoC bugs
> - fix potential problem of removing the driver when
>   a disk is mounted
> - other more minor stuff

Applied to 4.18/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
