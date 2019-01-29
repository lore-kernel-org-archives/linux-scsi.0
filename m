From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: fnic: Remove set but not used variable 'vdev'
Date: Tue, 29 Jan 2019 01:16:49 -0500
Message-ID: <yq1ef8wdm3y.fsf@oracle.com>
References: <20190125020014.11184-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190125020014.11184-1-yuehaibing@huawei.com> (YueHaibing's
        message of "Fri, 25 Jan 2019 10:00:14 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


YueHaibing,

> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/scsi/fnic/vnic_wq.c: In function 'vnic_wq_alloc_bufs':
> drivers/scsi/fnic/vnic_wq.c:50:19: warning:
>  variable 'vdev' set but not used [-Wunused-but-set-variable]
>
> drivers/scsi/fnic/vnic_rq.c: In function 'vnic_rq_alloc_bufs':
> drivers/scsi/fnic/vnic_rq.c:30:19: warning:
>  variable 'vdev' set but not used [-Wunused-but-set-variable]

Applied to 5.1/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
