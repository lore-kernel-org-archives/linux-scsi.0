From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND PATCH v2] scsi: Use vmemdup_user to replace the open code
Date: Tue, 25 Sep 2018 20:45:05 -0400
Message-ID: <yq17ej9hysu.fsf@oracle.com>
References: <1537286081-63081-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537286081-63081-1-git-send-email-zhongjiang@huawei.com> (zhong
        jiang's message of "Tue, 18 Sep 2018 23:54:41 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>
Cc: martin.petersen@oracle.com, don.brace@microsemi.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


zhong,

> vmemdup_user is better than duplicating its implementation, So just
> replace the open code.

Applied to 4.20/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
