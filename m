From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: qla2xxx: Remove useless set memory to zero use memset()
Date: Wed, 03 Apr 2019 23:41:41 -0400
Message-ID: <yq1r2aisah6.fsf@oracle.com>
References: <20190323132753.22508-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190323132753.22508-1-yuehaibing@huawei.com> (Yue Haibing's
        message of "Sat, 23 Mar 2019 21:27:53 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Yue Haibing <yuehaibing@huawei.com>
Cc: qla2xxx-upstream@qlogic.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Yue,

> The memory return by kzalloc() has already be set to zero, so remove
> useless memset(0).

Applied to 5.2/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
