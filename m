From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: myrs: Fix uninitialized variable
Date: Mon, 13 May 2019 18:42:11 -0400
Message-ID: <yq1v9yef03g.fsf@oracle.com>
References: <20190509152247.26164-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190509152247.26164-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Thu, 9 May 2019 23:22:47 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: hare@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


YueHaibing,

> If ev->ev_code is not 0x1C, sshdr.sense_key may be used
> uninitialized. Fix this by initializing variable 'sshdr' to 0.

Applied to 5.2/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
