From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hisi_sas: Fix spin lock management in slot_index_alloc_quirk_v2_hw()
Date: Tue, 16 Oct 2018 17:51:09 -0400
Message-ID: <yq136t5sgqa.fsf@oracle.com>
References: <1539702036-191138-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539702036-191138-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Tue, 16 Oct 2018 23:00:36 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, julia.lawall@lip6.fr, linuxarm@huawei.com
List-Id: linux-scsi@vger.kernel.org


John,

> Currently a spin_unlock_irqrestore() call is missing on the error path, so
> add it.

Applied to 4.20/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
