From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/4] scsi: cleanup hardcoding by replacing 0 by HCTX_TYPE_DEFAULT
Date: Tue, 19 Mar 2019 14:44:10 -0400
Message-ID: <yq1tvfyd7r9.fsf@oracle.com>
References: <1552352431-18821-1-git-send-email-dongli.zhang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1552352431-18821-1-git-send-email-dongli.zhang@oracle.com>
        (Dongli Zhang's message of "Tue, 12 Mar 2019 09:00:27 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com, linux-kernel@vger.kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com, don.brace@microsemi.com, esc.storagedev@microsemi.com
List-Id: linux-scsi@vger.kernel.org


Dongli,

> As in commit 7d76f8562f4c ("blk-mq: use HCTX_TYPE_DEFAULT but not 0 to
> index blk_mq_tag_set->map"), this patch set cleanup driver/scsi/* to
> index blk_mq_tag_set->map[] with HCTX_TYPE_DEFAULT, but not 0.

Applied to 5.2/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
