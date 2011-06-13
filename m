From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] scsi/trivial: Spelling hsot -> host
Date: Mon, 13 Jun 2011 20:20:17 +0200
Message-ID: <1307989217-22004-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Jiri Kosina <trivial@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
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
1.7.0.4
