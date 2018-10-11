From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/7] hisi_sas: Misc bugfixes and an optimisation patch
Date: Wed, 10 Oct 2018 21:58:25 -0400
Message-ID: <yq18t354532.fsf@oracle.com>
References: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537801594-207139-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Mon, 24 Sep 2018 23:06:27 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


John,

> However it does block us in future from enabling SCSI MQ in the driver.

We're going to remove the legacy I/O path so I'm not particularly keen
on merging something that's going in the opposite direction.

> This is because the IPTT index must be a unique value per HBA. However,
> if we switched to SCSI MQ, the block layer tag becomes unique per queue,
> and not per HBA.

That doesn't sound right.

-- 
Martin K. Petersen	Oracle Linux Engineering
