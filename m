From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/8] qla2xxx: Fix "occured" spelling errors.
Date: Thu, 11 Sep 2008 21:22:51 -0700
Message-ID: <1221193374-77635-6-git-send-email-andrew.vasquez@qlogic.com>
References: <1221193374-77635-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46751 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbYILEXA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2008 00:23:00 -0400
In-Reply-To: <1221193374-77635-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>

From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Fix "occured" spelling errors.  Most of these are in comments, which
I wouldn't normally bother with, but a couple are in printks, which
irritate me more.  So I just fixed them all at the same time.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c   |    2 +-
 drivers/scsi/qla2xxx/qla_inline.h |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c   |    6 +++---
 drivers/scsi/qla2xxx/qla_isr.c    |    8 ++++----
 drivers/scsi/qla2xxx/qla_mbx.c    |    4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 20847fb..a470f2d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2022,7 +2022,7 @@ qla2x00_configure_loop(scsi_qla_host_t *ha)
 		DEBUG3(printk("%s: exiting normally\n", __func__));
 	}
 
-	/* Restore state if a resync event occured during processing */
+	/* Restore state if a resync event occurred during processing */
 	if (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)) {
 		if (test_bit(LOCAL_LOOP_UPDATE, &save_flags))
 			set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 92fafbd..e90afad 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -52,7 +52,7 @@ to_qla_parent(scsi_qla_host_t *ha)
  * @ha: HA context
  * @ha_locked: is function called with the hardware lock
  *
- * Returns non-zero if a failure occured, else zero.
+ * Returns non-zero if a failure occurred, else zero.
  */
 static inline int
 qla2x00_issue_marker(scsi_qla_host_t *ha, int ha_locked)
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 9778f0b..85bc0a4 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -267,7 +267,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
  * qla2x00_start_scsi() - Send a SCSI command to the ISP
  * @sp: command to send to the ISP
  *
- * Returns non-zero if a failure occured, else zero.
+ * Returns non-zero if a failure occurred, else zero.
  */
 int
 qla2x00_start_scsi(srb_t *sp)
@@ -412,7 +412,7 @@ queuing_error:
  *
  * Can be called from both normal and interrupt context.
  *
- * Returns non-zero if a failure occured, else zero.
+ * Returns non-zero if a failure occurred, else zero.
  */
 int
 __qla2x00_marker(scsi_qla_host_t *ha, uint16_t loop_id, uint16_t lun,
@@ -676,7 +676,7 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
  * qla24xx_start_scsi() - Send a SCSI command to the ISP
  * @sp: command to send to the ISP
  *
- * Returns non-zero if a failure occured, else zero.
+ * Returns non-zero if a failure occurred, else zero.
  */
 int
 qla24xx_start_scsi(srb_t *sp)
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 45a3b93..2a8db44 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -391,9 +391,9 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		break;
 
 	case MBA_LIP_OCCURRED:		/* Loop Initialization Procedure */
-		DEBUG2(printk("scsi(%ld): LIP occured (%x).\n", ha->host_no,
+		DEBUG2(printk("scsi(%ld): LIP occurred (%x).\n", ha->host_no,
 		    mb[1]));
-		qla_printk(KERN_INFO, ha, "LIP occured (%x).\n", mb[1]);
+		qla_printk(KERN_INFO, ha, "LIP occurred (%x).\n", mb[1]);
 
 		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
 			atomic_set(&ha->loop_state, LOOP_DOWN);
@@ -460,7 +460,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		DEBUG2(printk("scsi(%ld): Asynchronous LIP RESET (%x).\n",
 		    ha->host_no, mb[1]));
 		qla_printk(KERN_INFO, ha,
-		    "LIP reset occured (%x).\n", mb[1]);
+		    "LIP reset occurred (%x).\n", mb[1]);
 
 		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
 			atomic_set(&ha->loop_state, LOOP_DOWN);
@@ -543,7 +543,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 
 	case MBA_PORT_UPDATE:		/* Port database update */
 		/*
-		 * If PORT UPDATE is global (recieved LIP_OCCURED/LIP_RESET
+		 * If PORT UPDATE is global (received LIP_OCCURRED/LIP_RESET
 		 * event etc. earlier indicating loop is down) then process
 		 * it.  Otherwise ignore it and Wait for RSCN to come in.
 		 */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ef15ad5..36bc685 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -233,7 +233,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 			DEBUG2_3_11(printk("%s(%ld): timeout schedule "
 			    "isp_abort_needed.\n", __func__, ha->host_no));
 			qla_printk(KERN_WARNING, ha,
-			    "Mailbox command timeout occured. Scheduling ISP "
+			    "Mailbox command timeout occurred. Scheduling ISP "
 			    "abort.\n");
 			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 			qla2xxx_wake_dpc(ha);
@@ -244,7 +244,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *pvha, mbx_cmd_t *mcp)
 			DEBUG2_3_11(printk("%s(%ld): timeout calling "
 			    "abort_isp\n", __func__, ha->host_no));
 			qla_printk(KERN_WARNING, ha,
-			    "Mailbox command timeout occured. Issuing ISP "
+			    "Mailbox command timeout occurred. Issuing ISP "
 			    "abort.\n");
 
 			set_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
-- 
1.6.0.1.294.gda06a

