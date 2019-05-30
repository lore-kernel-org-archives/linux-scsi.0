From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: megaraid_sas: remove set but not used variables 'host' and 'wait_time'
Date: Wed, 29 May 2019 22:25:50 -0400
Message-ID: <yq15zpsy8y9.fsf@oracle.com>
References: <20190525124202.8120-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190525124202.8120-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Sat, 25 May 2019 20:42:02 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com
List-Id: linux-scsi@vger.kernel.org


YueHaibing,

> Fixes gcc '-Wunused-but-set-variable' warnings:
>
> drivers/scsi/megaraid/megaraid_sas_base.c: In function megasas_suspend:
> drivers/scsi/megaraid/megaraid_sas_base.c:7269:20: warning: variable host set but not used [-Wunused-but-set-variable]
> drivers/scsi/megaraid/megaraid_sas_base.c: In function megasas_aen_polling:
> drivers/scsi/megaraid/megaraid_sas_base.c:8397:15: warning: variable wait_time set but not used [-Wunused-but-set-variable]
>
> 'host' is never used since introduction in
> commit 31ea7088974c ("[SCSI] megaraid_sas: add hibernation support")
>
> 'wait_time' is not used since commit
> 11c71cb4ab7c ("megaraid_sas: Do not allow PCI access during OCR")

Applied to 5.3/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
