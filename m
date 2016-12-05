From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hisi_sas: fix free'ing in probe and remove
Date: Mon, 05 Dec 2016 16:55:23 -0500
Message-ID: <yq1fum2vy5w.fsf@sermon.lab.mkp.net>
References: <1480434357-63730-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480434357-63730-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Tue, 29 Nov 2016 23:45:57 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, john.garry2@mail.dcu.ie, lambert.quentin@gmail.com, xuwei5@hisilicon.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, zhangfei.gao@linaro.org, linuxarm@huawei.com, Xiaofei Tan <tanxiaofei@huawei.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "John" == John Garry <john.garry@huawei.com> writes:

John> This patch addresses 4 problems in the module probe/remove:
John> - When hisi_sas_shost_alloc() fails after we alloc shost memory,
John> we should free shost memory before the function returns.
John> - When hisi_sas_probe() fails after we alloc the HBA memories,
John> we should also free the HBA memories.
John> - We should free shost memory at the end of hisi_sas_remove().
John> - sha->core.shost is set twice, so remove extra set.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
