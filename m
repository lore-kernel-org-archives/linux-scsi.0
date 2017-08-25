From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 18/26] ppa: drop duplicate bus_reset handler
Date: Fri, 25 Aug 2017 13:57:13 +0200
Message-ID: <1503662241-127788-19-git-send-email-hare@suse.de>
References: <1503662241-127788-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49644 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756518AbdHYL6E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 07:58:04 -0400
In-Reply-To: <1503662241-127788-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

bus_reset and host_reset are the same functions, so drop bus_reset.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/ppa.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index f6ad579..7be5823 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -970,7 +970,6 @@ static int ppa_adjust_queue(struct scsi_device *device)
 	.name			= "Iomega VPI0 (ppa) interface",
 	.queuecommand		= ppa_queuecommand,
 	.eh_abort_handler	= ppa_abort,
-	.eh_bus_reset_handler	= ppa_reset,
 	.eh_host_reset_handler	= ppa_reset,
 	.bios_param		= ppa_biosparam,
 	.this_id		= -1,
-- 
1.8.5.6
