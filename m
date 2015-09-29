From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/36] scsi_dh_alua: fixup description of stpg_endio()
Date: Tue, 29 Sep 2015 12:47:11 +0200
Message-ID: <1443523658-87622-10-git-send-email-hare@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934643AbbI2Krw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 06:47:52 -0400
In-Reply-To: <1443523658-87622-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

Fixup copy-and-paste error in the description of stpg_endio().

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index d4e5691..4ff9b90 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -171,13 +171,11 @@ done:
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

