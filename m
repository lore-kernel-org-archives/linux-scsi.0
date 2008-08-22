From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [patch] qla2xxx: Fix "occured" spelling errors
Date: Fri, 22 Aug 2008 13:17:06 -0600
Message-ID: <200808221317.07173.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:5972 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbYHVTRK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Aug 2008 15:17:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-driver@qlogic.com, linux-scsi@vger.kernel.org

Fix "occured" spelling errors.  Most of these are in comments, which
I wouldn't normally bother with, but a couple are in printks, which
irritate me more.  So I just fixed them all at the same time.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/scsi/qla2xxx/qla_init.c   |    2 +-
 drivers/scsi/qla2xxx/qla_inline.h |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c   |    6 +++---
 drivers/scsi/qla2xxx/qla_isr.c    |    8 ++++----
 drivers/scsi/qla2xxx/qla_mbx.c    |    4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)


diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 601a6b2..6b0dde4 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2015,7 +2015,7 @@ qla2x00_configure_loop(scsi_qla_host_t *ha)
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
index d57669a..fcd8fd8 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -262,7 +262,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
  * qla2x00_start_scsi() - Send a SCSI command to the ISP
  * @sp: command to send to the ISP
  *
- * Returns non-zero if a failure occured, else zero.
+ * Returns non-zero if a failure occurred, else zero.
  */
 int
 qla2x00_start_scsi(srb_t *sp)
@@ -407,7 +407,7 @@ queuing_error:
  *
  * Can be called from both normal and interrupt context.
  *
- * Returns non-zero if a failure occured, else zero.
+ * Returns non-zero if a failure occurred, else zero.
  */
 int
 __qla2x00_marker(scsi_qla_host_t *ha, uint16_t loop_id, uint16_t lun,
@@ -666,7 +666,7 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
  * qla24xx_start_scsi() - Send a SCSI command to the ISP
  * @sp: command to send to the ISP
  *
- * Returns non-zero if a failure occured, else zero.
+ * Returns non-zero if a failure occurred, else zero.
  */
 int
 qla24xx_start_scsi(srb_t *sp)
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 874d802..05a79a9 100644
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
index bc90d6b..c372e24 100644
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
