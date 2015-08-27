From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/23] scsi_dh_alua: fixup description of stpg_endio()
Date: Thu, 27 Aug 2015 14:41:04 +0200
Message-ID: <1440679281-13234-7-git-send-email-hare@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbbH0MlZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 08:41:25 -0400
In-Reply-To: <1440679281-13234-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Fixup copy-and-paste error in the description of stpg_endio().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index c41d662..25c2045 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -174,13 +174,11 @@ done:
 }
 
 /*
- * alua_stpg - Evaluate SET TARGET GROUP STATES
+ * stpg_endio - Evaluate SET TARGET GROUP STATES
  * @sdev: the device to be evaluated
  * @state: the new target group state
  *
- * Send a SET TARGET GROUP STATES command to the device.
- * We only have to test here if we should resubmit the command;
- * any other error is assumed as a failure.
+ * Evaluate a SET TARGET GROUP STATES command response.
  */
 static void stpg_endio(struct request *req, int error)
 {
-- 
1.8.5.6

