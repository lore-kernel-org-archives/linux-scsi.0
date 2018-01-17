From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: hisi_sas: make local symbol host_attrs static
Date: Wed, 17 Jan 2018 01:01:29 -0500
Message-ID: <yq1vag1t45i.fsf@oracle.com>
References: <1515669238-125768-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1515669238-125768-1-git-send-email-weiyongjun1@huawei.com> (Wei
        Yongjun's message of "Thu, 11 Jan 2018 11:13:58 +0000")
Sender: kernel-janitors-owner@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Cc: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Wei,

> Fixes the following sparse warning:
>
> drivers/scsi/hisi_sas/hisi_sas_main.c:1691:25: warning:
>  symbol 'host_attrs' was not declared. Should it be static?

Applied to 4.16/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
