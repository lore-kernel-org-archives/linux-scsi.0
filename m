From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/18] scsi_dh_alua: fixup description of stpg_endio()
Date: Tue,  1 Dec 2015 10:16:49 +0100
Message-ID: <1448961418-29013-10-git-send-email-hare@suse.de>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050AbbLAJRK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 04:17:10 -0500
In-Reply-To: <1448961418-29013-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Fixup copy-and-paste error in the description of stpg_endio().

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 50fe87c..ea626732 100644
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

