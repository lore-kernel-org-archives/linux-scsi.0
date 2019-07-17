From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: lpfc: Remove unnecessary null check before kfree
Date: Tue, 16 Jul 2019 22:46:09 -0400
Message-ID: <yq17e8hz8cu.fsf@oracle.com>
References: <20190711141037.57880-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190711141037.57880-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Thu, 11 Jul 2019 22:10:37 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


YueHaibing,

> A null check before a kfree is redundant, so remove it.
> This is detected by coccinelle.

Applied to 5.4/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
