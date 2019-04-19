From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: lpfc: Make lpfc_sli4_oas_verify static
Date: Thu, 18 Apr 2019 20:37:16 -0400
Message-ID: <yq1o952bzk3.fsf@oracle.com>
References: <20190417150554.34844-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190417150554.34844-1-yuehaibing@huawei.com> (Yue Haibing's
        message of "Wed, 17 Apr 2019 23:05:54 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Yue Haibing <yuehaibing@huawei.com>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Yue,

> Fix sparse warning:
>
> drivers/scsi/lpfc/lpfc_init.c:13091:1: warning:
>  symbol 'lpfc_sli4_oas_verify' was not declared. Should it be static?

Applied to 5.2/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
