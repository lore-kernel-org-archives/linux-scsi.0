From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: hisi_sas: Remove set but not used variable 'dq_list'
Date: Mon, 05 Nov 2018 22:44:05 -0500
Message-ID: <yq1zhum6fay.fsf@oracle.com>
References: <20181026070731.20024-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181026070731.20024-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Fri, 26 Oct 2018 15:07:31 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: john.garry@huawei.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


YueHaibing,

> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c: In function 'start_delivery_v1_hw':
> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:907:20: warning:
>  variable 'dq_list' set but not used [-Wunused-but-set-variable]

Applied to 4.20/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
