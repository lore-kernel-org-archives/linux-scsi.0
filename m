From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: megaraid_sas: remove set but not used variables 'buff_addr' and 'ci_h'
Date: Fri, 07 Jun 2019 09:14:30 -0400
Message-ID: <yq1lfydleq1.fsf@oracle.com>
References: <20190525124006.21284-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190525124006.21284-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Sat, 25 May 2019 20:40:06 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com
List-Id: linux-scsi@vger.kernel.org


YueHaibing,

> Fixes gcc '-Wunused-but-set-variable' warnings:
>
> drivers/scsi/megaraid/megaraid_sas_base.c: In function megasas_fw_crash_buffer_show:
> drivers/scsi/megaraid/megaraid_sas_base.c:3138:16: warning: variable buff_addr set but not used [-Wunused-but-set-variable]
> drivers/scsi/megaraid/megaraid_sas_base.c: In function megasas_get_pd_list:
> drivers/scsi/megaraid/megaraid_sas_base.c:4426:13: warning: variable ci_h set but not used [-Wunused-but-set-variable]
>
> 'buff_addr' is never used since inroduction in
> commit fc62b3fc9021 ("megaraid_sas : Firmware crash dump feature support")
>
> 'ci_h' is not used since commit 9b3d028f3468 ("scsi: megaraid_sas:
> Pre-allocate frequently used DMA buffers")

Applied to 5.3/scsi-queue. Thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
