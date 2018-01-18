From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: qedf: Fix error return code in __qedf_probe()
Date: Wed, 17 Jan 2018 21:44:26 -0500
Message-ID: <yq1o9lrrilx.fsf@oracle.com>
References: <1516192961-52789-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1516192961-52789-1-git-send-email-weiyongjun1@huawei.com> (Wei
        Yongjun's message of "Wed, 17 Jan 2018 12:42:41 +0000")
Sender: kernel-janitors-owner@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@cavium.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Wei,

> Fix to return error code -ENOMEM from the error handling
> case instead of 0, as done elsewhere in this function.

Applied to 4.16/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
