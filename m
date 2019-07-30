From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 -next] scsi: qla2xxx: Remove unnecessary null check
Date: Tue, 30 Jul 2019 12:08:35 -0400
Message-ID: <yq1d0hro67w.fsf@oracle.com>
References: <20190711140908.26896-1-yuehaibing@huawei.com>
        <20190711141317.52192-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190711141317.52192-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Thu, 11 Jul 2019 22:13:17 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: qla2xxx-upstream@qlogic.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


YueHaibing,

> A null check before dma_pool_destroy is redundant,
> so remove it. This is detected by coccinelle.

Applied to 5.4/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
