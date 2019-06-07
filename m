From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: megaraid_sas: remove set but not used variable 'sge_sz'
Date: Fri, 07 Jun 2019 09:14:14 -0400
Message-ID: <yq1pnnpleqh.fsf@oracle.com>
References: <20190525123705.8588-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190525123705.8588-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Sat, 25 May 2019 20:37:05 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com
List-Id: linux-scsi@vger.kernel.org


YueHaibing,

> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/scsi/megaraid/megaraid_sas_base.c: In function megasas_create_frame_pool:
> drivers/scsi/megaraid/megaraid_sas_base.c:4124:6: warning: variable sge_sz set but not used [-Wunused-but-set-variable]
>
> It's not used any more since
> commit 200aed582d61 ("megaraid_sas: endianness related bug fixes and code optimization")

Applied to 5.3/scsi-queue. Thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
