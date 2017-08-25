From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 17/26] imm: drop duplicate bus_reset handler
Date: Fri, 25 Aug 2017 13:57:12 +0200
Message-ID: <1503662241-127788-18-git-send-email-hare@suse.de>
References: <1503662241-127788-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49610 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756511AbdHYL6D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 07:58:03 -0400
In-Reply-To: <1503662241-127788-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

host_reset and bus_reset is the same function, so drop bus reset.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/imm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 9164ce12..87c9419 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -1106,7 +1106,6 @@ static int imm_adjust_queue(struct scsi_device *device)
 	.name			= "Iomega VPI2 (imm) interface",
 	.queuecommand		= imm_queuecommand,
 	.eh_abort_handler	= imm_abort,
-	.eh_bus_reset_handler	= imm_reset,
 	.eh_host_reset_handler	= imm_reset,
 	.bios_param		= imm_biosparam,
 	.this_id		= 7,
-- 
1.8.5.6
