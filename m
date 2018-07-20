From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/9] hisi_sas: Some misc patches
Date: Thu, 19 Jul 2018 22:05:10 -0400
Message-ID: <yq1in5a8xwp.fsf@oracle.com>
References: <1531923273-193768-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1531923273-193768-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Wed, 18 Jul 2018 22:14:24 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


John,

> This patchset introduces some misc patches, generally more minor in
> importance.
>
> However there is a patch to add a CPU barrier to the delivery path for
> each hw version. We only saw this issue on v3 hw in hip08 chipset,
> where the host CPU exhibits a looser memory model than in
> predecessors, and software must enforce SMP coherency.

Applied to 4.19/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
