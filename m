From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 1/2] scsi: hisi_sas: Add support for DIF feature for v2 hw
Date: Tue, 18 Dec 2018 23:35:35 -0500
Message-ID: <yq1pntygmlk.fsf@oracle.com>
References: <1545057608-89965-1-git-send-email-john.garry@huawei.com>
        <1545057608-89965-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545057608-89965-2-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Mon, 17 Dec 2018 22:40:07 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org


John,

> From: Xiang Chen <chenxiang66@hisilicon.com>
>
> For v3 hw, we support DIF operation for SAS, but not SATA.
>
> In addition, DIF CRC16 is supported.
>
> This patchset adds the SW support for the described features. The main
> components are as follows:
> - Get protection mask from module param
> - Fill PI fields
> - Fill related to DIF in DQ and protection iu memories

Applied to 4.21/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
