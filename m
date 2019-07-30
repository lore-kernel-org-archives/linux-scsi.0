From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: aic94xx: Remove unnecessary null check
Date: Tue, 30 Jul 2019 12:13:40 -0400
Message-ID: <yq18ssfo5zf.fsf@oracle.com>
References: <20190711141539.13892-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190711141539.13892-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Thu, 11 Jul 2019 22:15:39 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, jthumshirn@suse.de, dan.carpenter@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


YueHaibing,

> kmem_cache_destroy() can handle NULL pointer correctly, so there is
> no need to check NULL pointer before calling kmem_cache_destroy().

Applied to 5.4/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
