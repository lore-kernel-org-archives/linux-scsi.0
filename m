From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: use blk_mq_run_hw_queues in scsi_kick_queue
Date: Wed, 08 Aug 2018 22:02:44 -0400
Message-ID: <yq17el0qou3.fsf@oracle.com>
References: <1533709499-1661-1-git-send-email-jianchao.w.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533709499-1661-1-git-send-email-jianchao.w.wang@oracle.com>
        (Jianchao Wang's message of "Wed, 8 Aug 2018 14:24:59 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Jianchao Wang <jianchao.w.wang@oracle.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Jianchao,

> We don't use blk-mq start/stop hw queue any more, so no reason to
> use blk_mq_start_hw_queues which does clear_bit, replace it with
> blk_mq_run_hw_queues.

Applied to 4.19/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
