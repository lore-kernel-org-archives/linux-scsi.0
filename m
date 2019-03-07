From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/6] hisi_sas: Some misc patches
Date: Wed, 06 Mar 2019 19:27:37 -0500
Message-ID: <yq14l8fwmti.fsf@oracle.com>
References: <1551365462-128193-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1551365462-128193-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Thu, 28 Feb 2019 22:50:56 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


John,

> The patchset contains some misc patches for the driver, including:
> - Workaround for acute scenario of SMP/internal IO timeout and reset racing
> - Clear Affiliation for STP target port (from Luo Jiaxing and Xiang Chen)
> - Fix PHY negotiated linkrate value for when PHY down
> - Some init reg config changes
> - Add support to coalesce and print PHY errors
> - A tidy-up patch

Applied to 5.1/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
