From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/28] imm: drop duplicate bus_reset handler
Date: Wed, 28 Jun 2017 10:25:05 +0200
Message-ID: <1498638316-44420-18-git-send-email-hare@suse.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53031 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751511AbdF1IbJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:31:09 -0400
In-Reply-To: <1498638316-44420-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

host_reset and bus_reset is the same function, so drop bus reset.

Signed-off-by: Hannes Reinecke <hare@suse.com>
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
