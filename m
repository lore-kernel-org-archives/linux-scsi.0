From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] Fix spelling - change hsot into host
Date: Sun, 12 Jun 2011 13:36:20 +0200
Message-ID: <201106121336.21017.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:60946 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab1FLMHp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jun 2011 08:07:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aic7xxx_old/aic7xxx.seq |    2 +-
 drivers/scsi/scsi_error.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx_old/aic7xxx.seq b/drivers/scsi/aic7xxx_old/aic7xxx.seq
index 823ff28..dc3bb81 100644
--- a/drivers/scsi/aic7xxx_old/aic7xxx.seq
+++ b/drivers/scsi/aic7xxx_old/aic7xxx.seq
@@ -693,7 +693,7 @@ p_status:
  * it's own message.
  * 
  * If MSG_OUT is == HOST_MSG, also interrupt the host and take a message.
- * This is done to allow the hsot to send messages outside of an identify
+ * This is done to allow the host to send messages outside of an identify
  * sequence while protecting the seqencer from testing the MK_MESSAGE bit
  * on an SCB that might not be for the current nexus. (For example, a
  * BDR message in response to a bad reselection would leave us pointed to
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a4b9cdb..87521b1 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -510,7 +510,7 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
 
 /**
  * scsi_try_host_reset - ask host adapter to reset itself
- * @scmd:	SCSI cmd to send hsot reset.
+ * @scmd:	SCSI cmd to send host reset.
  */
 static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
-- 
1.7.3.4

