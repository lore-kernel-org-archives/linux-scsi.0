From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] hisi_sas: v2 hw ACPI support and fix lock
Date: Mon, 06 Jun 2016 23:16:19 -0400
Message-ID: <yq1eg89ofi4.fsf@sermon.lab.mkp.net>
References: <1464698331-228732-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464698331-228732-1-git-send-email-john.garry@huawei.com> (John
	Garry's message of "Tue, 31 May 2016 20:38:48 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "John" == John Garry <john.garry@huawei.com> writes:

John> This patchset introduces 2 separate features/fixes: - v2 hw ACPI
John> support: implemented the same as v1 hw - fix inconsistent lock:
John> remove unnecessary spinlock_irqsave() in broadcast interrupt
John> handler

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
