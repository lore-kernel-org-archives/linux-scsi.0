From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 8/8] scsi: Implement blk_mq_ops.show_rq()
Date: Wed, 19 Apr 2017 19:25:21 -0400
Message-ID: <yq1efworndq.fsf@oracle.com>
References: <20170418232949.5228-1-bart.vanassche@sandisk.com>
        <20170418232949.5228-9-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170418232949.5228-9-bart.vanassche@sandisk.com> (Bart Van
        Assche's message of "Tue, 18 Apr 2017 16:29:49 -0700")
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Omar Sandoval <osandov@fb.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart,

> Show the SCSI CDB, .eh_eflags and .result for pending SCSI commands
> in /sys/kernel/debug/block/*/mq/*/dispatch and */rq_list.

SCSI_EH_CANCEL_CMD is no more (as of a06586325f37).

-- 
Martin K. Petersen	Oracle Linux Engineering
