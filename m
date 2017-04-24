From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 10/10] scsi: Implement blk_mq_ops.show_rq()
Date: Mon, 24 Apr 2017 17:35:08 -0400
Message-ID: <yq1k269ij5f.fsf@oracle.com>
References: <20170421234026.18970-1-bart.vanassche@sandisk.com>
        <20170421234026.18970-11-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33915 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1173307AbdDXVfe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 17:35:34 -0400
In-Reply-To: <20170421234026.18970-11-bart.vanassche@sandisk.com> (Bart Van
        Assche's message of "Fri, 21 Apr 2017 16:40:26 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Omar Sandoval <osandov@fb.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org


Bart,

> Show the SCSI CDB, .eh_eflags and .result for pending SCSI commands
> in /sys/kernel/debug/block/*/mq/*/dispatch and */rq_list.

Why not use SCSI tracing if you are interested in these?

-- 
Martin K. Petersen	Oracle Linux Engineering
