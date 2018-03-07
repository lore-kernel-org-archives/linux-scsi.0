From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V4] scsi: core: use blk_mq_requeue_request in __scsi_queue_insert
Date: Tue, 06 Mar 2018 21:16:51 -0500
Message-ID: <yq1fu5cpr3g.fsf@oracle.com>
References: <1520042049-8874-1-git-send-email-jianchao.w.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520042049-8874-1-git-send-email-jianchao.w.wang@oracle.com>
        (Jianchao Wang's message of "Sat, 3 Mar 2018 09:54:09 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Jianchao Wang <jianchao.w.wang@oracle.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, Bart.VanAssche@wdc.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org


Jianchao,

> In scsi core, __scsi_queue_insert should just put request back on
> the queue and retry using the same command as before. However, for
> blk-mq, scsi_mq_requeue_cmd is employed here which will unprepare
> the request. To align with the semantics of __scsi_queue_insert,
> use blk_mq_requeue_request with kick_requeue_list == true and put
> the reference of scsi_device.

Applied to 4.17/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
