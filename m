From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v6 10/10] scsi: Implement blk_mq_ops.show_rq()
Date: Thu, 27 Apr 2017 08:42:03 +0200
Message-ID: <e0305eec-5ce4-d9c1-c896-cd15f133a87a@suse.de>
References: <20170426204757.18910-1-bart.vanassche@sandisk.com>
 <20170426204757.18910-11-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51411 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1162189AbdD0GmF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Apr 2017 02:42:05 -0400
In-Reply-To: <20170426204757.18910-11-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org

On 04/26/2017 10:47 PM, Bart Van Assche wrote:
> Show the SCSI CDB for pending SCSI commands in
> /sys/kernel/debug/block/*/mq/*/dispatch and */rq_list. An example
> of how SCSI commands are displayed by this code:
> 
> ffff8801703245c0 {.op=READ, .cmd_flags=META PRIO, .rq_flags=DONTPREP IO_STAT STATS, .tag=14, .internal_tag=-1, .cmd=Read(10) 28 00 2a 81 1b 30 00 00 08 00}
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Omar Sandoval <osandov@fb.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: <linux-scsi@vger.kernel.org>
> ---
>  drivers/scsi/Makefile       |  1 +
>  drivers/scsi/scsi_debugfs.c | 13 +++++++++++++
>  drivers/scsi/scsi_debugfs.h |  4 ++++
>  drivers/scsi/scsi_lib.c     |  4 ++++
>  4 files changed, 22 insertions(+)
>  create mode 100644 drivers/scsi/scsi_debugfs.c
>  create mode 100644 drivers/scsi/scsi_debugfs.h
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
