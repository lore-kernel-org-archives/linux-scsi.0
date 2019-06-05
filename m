From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: lpfc: Remove set but not used variables 'qp'
Date: Tue, 04 Jun 2019 22:30:23 -0400
Message-ID: <yq1muiwrcg0.fsf@oracle.com>
References: <20190531152745.7928-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190531152745.7928-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Fri, 31 May 2019 23:27:45 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com, jsmart2021@gmail.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


YueHaibing,

> Fixes gcc '-Wunused-but-set-variable' warnings:
>
> drivers/scsi/lpfc/lpfc_init.c: In function lpfc_setup_cq_lookup:
> drivers/scsi/lpfc/lpfc_init.c:9359:30: warning: variable qp set but not used [-Wunused-but-set-variable]

Applied to 5.3/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
