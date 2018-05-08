From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/11] hisi_sas: some misc patches
Date: Tue, 08 May 2018 01:16:17 -0400
Message-ID: <yq1tvriybfi.fsf@oracle.com>
References: <1525276594-92173-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525276594-92173-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Wed, 2 May 2018 23:56:23 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


John,

> This patchset introduces some misc changes for the
> driver. These include:
> - fixes for potential problems related to SCSI EH
>   and device removal races
> - fix protection info size for all hw versions
> - some SoC bug workarounds
> - minor optimisations
> - other more minor things

Applied to 4.18/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
