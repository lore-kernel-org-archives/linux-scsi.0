From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 04/19] libfc: Source code comment spelling fixes
Date: Mon, 21 Oct 2013 11:00:47 -0700
Message-ID: <20131021180047.31563.49533.stgit@fritz>
References: <20131021180024.31563.89632.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:58022 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab3JUSAs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Oct 2013 14:00:48 -0400
In-Reply-To: <20131021180024.31563.89632.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>

From: Bart Van Assche <bvanassche@acm.org>

Change 'initiaive' into 'initiative', 'remainig' into 'remaining'
and change 'exected' into 'expected'.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c  |    5 +----
 drivers/scsi/libfc/fc_lport.c |    2 +-
 drivers/scsi/libfc/fc_rport.c |    6 +++---
 include/scsi/fc/fc_fc2.h      |    2 +-
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 5879929..b233a2d 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -303,10 +303,7 @@ static void fc_exch_setup_hdr(struct fc_exch *ep, struct fc_frame *fp,
 		fr_eof(fp) = FC_EOF_N;
 	}
 
-	/*
-	 * Initialize remainig fh fields
-	 * from fc_fill_fc_hdr
-	 */
+	/* Initialize remaining fh fields from fc_fill_fc_hdr */
 	fh->fh_ox_id = htons(ep->oxid);
 	fh->fh_rx_id = htons(ep->rxid);
 	fh->fh_seq_id = ep->seq.id;
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index f04d15c..a32f314 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -516,7 +516,7 @@ static void fc_lport_recv_rnid_req(struct fc_lport *lport,
  * @lport: The local port receiving the LOGO
  * @fp:	   The LOGO request frame
  *
- * Locking Note: The lport lock is exected to be held before calling
+ * Locking Note: The lport lock is expected to be held before calling
  * this function.
  */
 static void fc_lport_recv_logo_req(struct fc_lport *lport, struct fc_frame *fp)
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index c710d90..589ff9a 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1705,7 +1705,7 @@ reject:
  * @rdata: The remote port that sent the PRLI request
  * @rx_fp: The PRLI request frame
  *
- * Locking Note: The rport lock is exected to be held before calling
+ * Locking Note: The rport lock is expected to be held before calling
  * this function.
  */
 static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
@@ -1824,7 +1824,7 @@ drop:
  * @rdata: The remote port that sent the PRLO request
  * @rx_fp: The PRLO request frame
  *
- * Locking Note: The rport lock is exected to be held before calling
+ * Locking Note: The rport lock is expected to be held before calling
  * this function.
  */
 static void fc_rport_recv_prlo_req(struct fc_rport_priv *rdata,
@@ -1895,7 +1895,7 @@ drop:
  * @lport: The local port that received the LOGO request
  * @fp:	   The LOGO request frame
  *
- * Locking Note: The rport lock is exected to be held before calling
+ * Locking Note: The rport lock is expected to be held before calling
  * this function.
  */
 static void fc_rport_recv_logo_req(struct fc_lport *lport, struct fc_frame *fp)
diff --git a/include/scsi/fc/fc_fc2.h b/include/scsi/fc/fc_fc2.h
index f87777d..0b26714 100644
--- a/include/scsi/fc/fc_fc2.h
+++ b/include/scsi/fc/fc_fc2.h
@@ -104,7 +104,7 @@ struct fc_esb {
  * esb_e_stat - flags from FC-FS-2 T11/1619-D Rev 0.90.
  */
 #define ESB_ST_RESP         (1 << 31)   /* responder to exchange */
-#define ESB_ST_SEQ_INIT     (1 << 30)   /* port holds sequence initiaive */
+#define ESB_ST_SEQ_INIT     (1 << 30)   /* port holds sequence initiative */
 #define ESB_ST_COMPLETE     (1 << 29)   /* exchange is complete */
 #define ESB_ST_ABNORMAL     (1 << 28)   /* abnormal ending condition */
 #define ESB_ST_REC_QUAL     (1 << 26)   /* recovery qualifier active */

