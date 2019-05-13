From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: qedi: remove memset/memcpy to nfunc and use func instead
Date: Mon, 13 May 2019 18:31:29 -0400
Message-ID: <yq1d0kmgf5q.fsf@oracle.com>
References: <20190412094829.15868-1-colin.king@canonical.com>
        <20190420040554.41888-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190420040554.41888-1-yuehaibing@huawei.com> (Yue Haibing's
        message of "Sat, 20 Apr 2019 12:05:54 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Yue Haibing <yuehaibing@huawei.com>
Cc: QLogic-Storage-Upstream@cavium.com, jejb@linux.ibm.com, martin.petersen@oracle.com, mojha@codeaurora.org, skashyap@marvell.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Yue,

> KASAN report this:
>
> BUG: KASAN: global-out-of-bounds in qedi_dbg_err+0xda/0x330 [qedi]
> Read of size 31 at addr ffffffffc12b0ae0 by task syz-executor.0/2429

Applied to 5.2/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
