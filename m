From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: mvumi: Using plain integer as NULL pointer
Date: Tue, 19 Mar 2019 17:46:48 -0400
Message-ID: <yq136nibkqf.fsf@oracle.com>
References: <20190216100130.19396-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190216100130.19396-1-yuehaibing@huawei.com> (YueHaibing's
        message of "Sat, 16 Feb 2019 18:01:30 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


YueHaibing,

> Fix following sparse warning:
>
> drivers/scsi/mvumi.c:1797:48: warning: Using plain integer as NULL pointer
> drivers/scsi/mvumi.c:2143:50: warning: Using plain integer as NULL pointer
> drivers/scsi/mvumi.c:755:58: warning: Using plain integer as NULL pointer

Applied to 5.2/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
