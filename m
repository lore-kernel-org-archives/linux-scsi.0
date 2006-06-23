From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 8/13] qla2xxx: Cleanup DEBUG macro usage.
Date: Fri, 23 Jun 2006 16:11:05 -0700
Message-ID: <1151104260260-git-send-email-andrew.vasquez@qlogic.com>
References: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:53936 "EHLO avexch2.qlogic.com")
	by vger.kernel.org with ESMTP id S1752162AbWFWXLG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jun 2006 19:11:06 -0400
In-Reply-To: <20060623230815.GB10758@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

- macro usage statements should terminate with a ';'
- remove unused macros.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.h  |   98 ++++++++-----------
 drivers/scsi/qla2xxx/qla_init.c |   10 +-
 drivers/scsi/qla2xxx/qla_isr.c  |    4 -
 drivers/scsi/qla2xxx/qla_mbx.c  |  200 ++++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_os.c   |    8 +-
 5 files changed, 154 insertions(+), 166 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index ace6afd..2cea009 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -37,122 +37,110 @@ #endif
 /*
 * Macros use for debugging the driver.
 */
-#undef ENTER_TRACE
-#if defined(ENTER_TRACE)
-#define ENTER(x)	do { printk("qla2100 : Entering %s()\n", x); } while (0)
-#define LEAVE(x)	do { printk("qla2100 : Leaving %s()\n", x);  } while (0)
-#define ENTER_INTR(x)	do { printk("qla2100 : Entering %s()\n", x); } while (0)
-#define LEAVE_INTR(x)	do { printk("qla2100 : Leaving %s()\n", x);  } while (0)
-#else
-#define ENTER(x)	do {} while (0)
-#define LEAVE(x)	do {} while (0)
-#define ENTER_INTR(x) 	do {} while (0)
-#define LEAVE_INTR(x)   do {} while (0)
-#endif
 
 #if  DEBUG_QLA2100
-#define DEBUG(x)	do {x;} while (0);
+#define DEBUG(x)	do {x;} while (0)
 #else
-#define DEBUG(x)	do {} while (0);
+#define DEBUG(x)	do {} while (0)
 #endif
 
 #if defined(QL_DEBUG_LEVEL_1)
-#define DEBUG1(x)	do {x;} while (0);
+#define DEBUG1(x)	do {x;} while (0)
 #else
-#define DEBUG1(x)	do {} while (0);
+#define DEBUG1(x)	do {} while (0)
 #endif
 
 #if defined(QL_DEBUG_LEVEL_2)
-#define DEBUG2(x)       do {x;} while (0);
-#define DEBUG2_3(x)     do {x;} while (0);
-#define DEBUG2_3_11(x)  do {x;} while (0);
-#define DEBUG2_9_10(x)    do {x;} while (0);
-#define DEBUG2_11(x)    do {x;} while (0);
-#define DEBUG2_13(x)    do {x;} while (0);
+#define DEBUG2(x)       do {x;} while (0)
+#define DEBUG2_3(x)     do {x;} while (0)
+#define DEBUG2_3_11(x)  do {x;} while (0)
+#define DEBUG2_9_10(x)    do {x;} while (0)
+#define DEBUG2_11(x)    do {x;} while (0)
+#define DEBUG2_13(x)    do {x;} while (0)
 #else
-#define DEBUG2(x)	do {} while (0);
+#define DEBUG2(x)	do {} while (0)
 #endif
 
 #if defined(QL_DEBUG_LEVEL_3)
-#define DEBUG3(x)	do {x;} while (0);
-#define DEBUG2_3(x)	do {x;} while (0);
-#define DEBUG2_3_11(x)	do {x;} while (0);
-#define DEBUG3_11(x)	do {x;} while (0);
+#define DEBUG3(x)	do {x;} while (0)
+#define DEBUG2_3(x)	do {x;} while (0)
+#define DEBUG2_3_11(x)	do {x;} while (0)
+#define DEBUG3_11(x)	do {x;} while (0)
 #else
-#define DEBUG3(x)	do {} while (0);
+#define DEBUG3(x)	do {} while (0)
   #if !defined(QL_DEBUG_LEVEL_2)
-  #define DEBUG2_3(x)	do {} while (0);
+  #define DEBUG2_3(x)	do {} while (0)
   #endif
 #endif
 
 #if defined(QL_DEBUG_LEVEL_4)
-#define DEBUG4(x)	do {x;} while (0);
+#define DEBUG4(x)	do {x;} while (0)
 #else
-#define DEBUG4(x)	do {} while (0);
+#define DEBUG4(x)	do {} while (0)
 #endif
 
 #if defined(QL_DEBUG_LEVEL_5)
-#define DEBUG5(x)          do {x;} while (0);
+#define DEBUG5(x)          do {x;} while (0)
 #else
-#define DEBUG5(x)	do {} while (0);
+#define DEBUG5(x)	do {} while (0)
 #endif
 
 #if defined(QL_DEBUG_LEVEL_7)
-#define DEBUG7(x)          do {x;} while (0);
+#define DEBUG7(x)          do {x;} while (0)
 #else
-#define DEBUG7(x)	   do {} while (0);
+#define DEBUG7(x)	   do {} while (0)
 #endif
 
 #if defined(QL_DEBUG_LEVEL_9)
-#define DEBUG9(x)       do {x;} while (0);
-#define DEBUG9_10(x)    do {x;} while (0);
-#define DEBUG2_9_10(x)	do {x;} while (0);
+#define DEBUG9(x)       do {x;} while (0)
+#define DEBUG9_10(x)    do {x;} while (0)
+#define DEBUG2_9_10(x)	do {x;} while (0)
 #else
-#define DEBUG9(x)	do {} while (0);
+#define DEBUG9(x)	do {} while (0)
 #endif
 
 #if defined(QL_DEBUG_LEVEL_10)
-#define DEBUG10(x)      do {x;} while (0);
-#define DEBUG2_9_10(x)	do {x;} while (0);
-#define DEBUG9_10(x)	do {x;} while (0);
+#define DEBUG10(x)      do {x;} while (0)
+#define DEBUG2_9_10(x)	do {x;} while (0)
+#define DEBUG9_10(x)	do {x;} while (0)
 #else
-#define DEBUG10(x)	do {} while (0);
+#define DEBUG10(x)	do {} while (0)
   #if !defined(DEBUG2_9_10)
-  #define DEBUG2_9_10(x)	do {} while (0);
+  #define DEBUG2_9_10(x)	do {} while (0)
   #endif
   #if !defined(DEBUG9_10)
-  #define DEBUG9_10(x)	do {} while (0);
+  #define DEBUG9_10(x)	do {} while (0)
   #endif
 #endif
 
 #if defined(QL_DEBUG_LEVEL_11)
-#define DEBUG11(x)      do{x;} while(0);
+#define DEBUG11(x)      do{x;} while(0)
 #if !defined(DEBUG2_11)
-#define DEBUG2_11(x)    do{x;} while(0);
+#define DEBUG2_11(x)    do{x;} while(0)
 #endif
 #if !defined(DEBUG2_3_11)
-#define DEBUG2_3_11(x)  do{x;} while(0);
+#define DEBUG2_3_11(x)  do{x;} while(0)
 #endif
 #if !defined(DEBUG3_11)
-#define DEBUG3_11(x)    do{x;} while(0);
+#define DEBUG3_11(x)    do{x;} while(0)
 #endif
 #else
-#define DEBUG11(x)	do{} while(0);
+#define DEBUG11(x)	do{} while(0)
   #if !defined(QL_DEBUG_LEVEL_2)
-  #define DEBUG2_11(x)	do{} while(0);
+  #define DEBUG2_11(x)	do{} while(0)
     #if !defined(QL_DEBUG_LEVEL_3)
-    #define DEBUG2_3_11(x) do{} while(0);
+    #define DEBUG2_3_11(x) do{} while(0)
     #endif
   #endif
   #if !defined(QL_DEBUG_LEVEL_3)
-  #define DEBUG3_11(x)	do{} while(0);
+  #define DEBUG3_11(x)	do{} while(0)
   #endif
 #endif
 
 #if defined(QL_DEBUG_LEVEL_12)
-#define DEBUG12(x)      do {x;} while (0);
+#define DEBUG12(x)      do {x;} while (0)
 #else
-#define DEBUG12(x)	do {} while (0);
+#define DEBUG12(x)	do {} while (0)
 #endif
 
 #if defined(QL_DEBUG_LEVEL_13)
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2ccdd84..101cf12 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3137,14 +3137,14 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 					ha->isp_abort_cnt--;
 					DEBUG(printk("qla%ld: ISP abort - "
 					    "retry remaining %d\n",
-					    ha->host_no, ha->isp_abort_cnt);)
+					    ha->host_no, ha->isp_abort_cnt));
 					status = 1;
 				}
 			} else {
 				ha->isp_abort_cnt = MAX_RETRIES_OF_ISP_ABORT;
 				DEBUG(printk("qla2x00(%ld): ISP error recovery "
 				    "- retrying (%d) more times\n",
-				    ha->host_no, ha->isp_abort_cnt);)
+				    ha->host_no, ha->isp_abort_cnt));
 				set_bit(ISP_ABORT_RETRY, &ha->dpc_flags);
 				status = 1;
 			}
@@ -3158,7 +3158,7 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 	} else {
 		DEBUG(printk(KERN_INFO
 				"qla2x00_abort_isp(%ld): exiting.\n",
-				ha->host_no);)
+				ha->host_no));
 	}
 
 	return(status);
@@ -3234,7 +3234,7 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 		clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
 		if (!(status = qla2x00_fw_ready(ha))) {
 			DEBUG(printk("%s(): Start configure loop, "
-			    "status = %d\n", __func__, status);)
+			    "status = %d\n", __func__, status));
 
 			/* Issue a marker after FW becomes ready. */
 			qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
@@ -3258,7 +3258,7 @@ qla2x00_restart_isp(scsi_qla_host_t *ha)
 
 		DEBUG(printk("%s(): Configure loop done, status = 0x%x\n",
 				__func__,
-				status);)
+				status));
 	}
 	return (status);
 }
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index b9f01f7..795bf15 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1432,8 +1432,8 @@ qla24xx_ms_entry(scsi_qla_host_t *ha, st
 	DEBUG3(printk("%s(%ld): pkt=%p pkthandle=%d.\n",
 	    __func__, ha->host_no, pkt, pkt->handle));
 
-	DEBUG9(printk("%s: ct pkt dump:\n", __func__);)
-	DEBUG9(qla2x00_dump_buffer((void *)pkt, sizeof(struct ct_entry_24xx));)
+	DEBUG9(printk("%s: ct pkt dump:\n", __func__));
+	DEBUG9(qla2x00_dump_buffer((void *)pkt, sizeof(struct ct_entry_24xx)));
 
 	/* Validate handle. */
  	if (pkt->handle < MAX_OUTSTANDING_COMMANDS)
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index f5e226f..879f281 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -13,13 +13,13 @@ qla2x00_mbx_sem_timeout(unsigned long da
 {
 	struct semaphore	*sem_ptr = (struct semaphore *)data;
 
-	DEBUG11(printk("qla2x00_sem_timeout: entered.\n");)
+	DEBUG11(printk("qla2x00_sem_timeout: entered.\n"));
 
 	if (sem_ptr != NULL) {
 		up(sem_ptr);
 	}
 
-	DEBUG11(printk("qla2x00_mbx_sem_timeout: exiting.\n");)
+	DEBUG11(printk("qla2x00_mbx_sem_timeout: exiting.\n"));
 }
 
 /*
@@ -61,7 +61,7 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 	rval = QLA_SUCCESS;
 	abort_active = test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
 	/*
 	 * Wait for active mailbox commands to finish by waiting at most tov
@@ -72,7 +72,7 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 		if (qla2x00_down_timeout(&ha->mbx_cmd_sem, mcp->tov * HZ)) {
 			/* Timeout occurred. Return error. */
 			DEBUG2_3_11(printk("%s(%ld): cmd access timeout. "
-			    "Exiting.\n", __func__, ha->host_no);)
+			    "Exiting.\n", __func__, ha->host_no));
 			return QLA_FUNCTION_TIMEOUT;
 		}
 	}
@@ -86,7 +86,7 @@ qla2x00_mailbox_command(scsi_qla_host_t 
 		spin_lock_irqsave(&ha->mbx_reg_lock, mbx_flags);
 
 	DEBUG11(printk("scsi(%ld): prepare to issue mbox cmd=0x%x.\n",
-	    ha->host_no, mcp->mb[0]);)
+	    ha->host_no, mcp->mb[0]));
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
@@ -131,14 +131,14 @@ #endif
 
 	/* Unlock mbx registers and wait for interrupt */
 	DEBUG11(printk("%s(%ld): going to unlock irq & waiting for interrupt. "
-	    "jiffies=%lx.\n", __func__, ha->host_no, jiffies);)
+	    "jiffies=%lx.\n", __func__, ha->host_no, jiffies));
 
 	/* Wait for mbx cmd completion until timeout */
 
 	if (!abort_active && io_lock_on) {
 		/* sleep on completion semaphore */
 		DEBUG11(printk("%s(%ld): INTERRUPT MODE. Initializing timer.\n",
-		    __func__, ha->host_no);)
+		    __func__, ha->host_no));
 
 		init_timer(&tmp_intr_timer);
 		tmp_intr_timer.data = (unsigned long)&ha->mbx_intr_sem;
@@ -147,11 +147,11 @@ #endif
 		    (void (*)(unsigned long))qla2x00_mbx_sem_timeout;
 
 		DEBUG11(printk("%s(%ld): Adding timer.\n", __func__,
-		    ha->host_no);)
+		    ha->host_no));
 		add_timer(&tmp_intr_timer);
 
 		DEBUG11(printk("%s(%ld): going to unlock & sleep. "
-		    "time=0x%lx.\n", __func__, ha->host_no, jiffies);)
+		    "time=0x%lx.\n", __func__, ha->host_no, jiffies));
 
 		set_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 
@@ -170,14 +170,14 @@ #endif
 		down(&ha->mbx_intr_sem);
 
 		DEBUG11(printk("%s(%ld): waking up. time=0x%lx\n", __func__,
-		    ha->host_no, jiffies);)
+		    ha->host_no, jiffies));
 		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 
 		/* delete the timer */
 		del_timer(&tmp_intr_timer);
 	} else {
 		DEBUG3_11(printk("%s(%ld): cmd=%x POLLING MODE.\n", __func__,
-		    ha->host_no, command);)
+		    ha->host_no, command));
 
 		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
 			WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
@@ -209,7 +209,7 @@ #endif
 		uint16_t *iptr2;
 
 		DEBUG3_11(printk("%s(%ld): cmd %x completed.\n", __func__,
-		    ha->host_no, command);)
+		    ha->host_no, command));
 
 		/* Got interrupt. Clear the flag. */
 		ha->flags.mbox_int = 0;
@@ -266,7 +266,7 @@ #endif
 
 	if (!abort_active) {
 		DEBUG11(printk("%s(%ld): checking for additional resp "
-		    "interrupt.\n", __func__, ha->host_no);)
+		    "interrupt.\n", __func__, ha->host_no));
 
 		/* polling mode for non isp_abort commands. */
 		qla2x00_poll(ha);
@@ -277,9 +277,9 @@ #endif
 		if (!io_lock_on || (mcp->flags & IOCTL_CMD)) {
 			/* not in dpc. schedule it for dpc to take over. */
 			DEBUG(printk("%s(%ld): timeout schedule "
-			    "isp_abort_needed.\n", __func__, ha->host_no);)
+			    "isp_abort_needed.\n", __func__, ha->host_no));
 			DEBUG2_3_11(printk("%s(%ld): timeout schedule "
-			    "isp_abort_needed.\n", __func__, ha->host_no);)
+			    "isp_abort_needed.\n", __func__, ha->host_no));
 			qla_printk(KERN_WARNING, ha,
 			    "Mailbox command timeout occured. Scheduling ISP "
 			    "abort.\n");
@@ -288,9 +288,9 @@ #endif
 		} else if (!abort_active) {
 			/* call abort directly since we are in the DPC thread */
 			DEBUG(printk("%s(%ld): timeout calling abort_isp\n",
-			    __func__, ha->host_no);)
+			    __func__, ha->host_no));
 			DEBUG2_3_11(printk("%s(%ld): timeout calling "
-			    "abort_isp\n", __func__, ha->host_no);)
+			    "abort_isp\n", __func__, ha->host_no));
 			qla_printk(KERN_WARNING, ha,
 			    "Mailbox command timeout occured. Issuing ISP "
 			    "abort.\n");
@@ -303,9 +303,9 @@ #endif
 			}
 			clear_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
 			DEBUG(printk("%s(%ld): finished abort_isp\n", __func__,
-			    ha->host_no);)
+			    ha->host_no));
 			DEBUG2_3_11(printk("%s(%ld): finished abort_isp\n",
-			    __func__, ha->host_no);)
+			    __func__, ha->host_no));
 		}
 	}
 
@@ -316,9 +316,9 @@ #endif
 	if (rval) {
 		DEBUG2_3_11(printk("%s(%ld): **** FAILED. mbx0=%x, mbx1=%x, "
 		    "mbx2=%x, cmd=%x ****\n", __func__, ha->host_no,
-		    mcp->mb[0], mcp->mb[1], mcp->mb[2], command);)
+		    mcp->mb[0], mcp->mb[1], mcp->mb[2], command));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no);)
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
 	}
 
 	return rval;
@@ -394,7 +394,7 @@ qla2x00_execute_fw(scsi_qla_host_t *ha, 
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
 	mcp->mb[0] = MBC_EXECUTE_FIRMWARE;
 	mcp->out_mb = MBX_0;
@@ -424,10 +424,10 @@ qla2x00_execute_fw(scsi_qla_host_t *ha, 
 	} else {
 		if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 			DEBUG11(printk("%s(%ld): done exchanges=%x.\n",
-			    __func__, ha->host_no, mcp->mb[1]);)
+			    __func__, ha->host_no, mcp->mb[1]));
 		} else {
 			DEBUG11(printk("%s(%ld): done.\n", __func__,
-			    ha->host_no);)
+			    ha->host_no));
 		}
 	}
 
@@ -611,7 +611,7 @@ qla2x00_mbx_reg_test(scsi_qla_host_t *ha
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("qla2x00_mbx_reg_test(%ld): entered.\n", ha->host_no);)
+	DEBUG11(printk("qla2x00_mbx_reg_test(%ld): entered.\n", ha->host_no));
 
 	mcp->mb[0] = MBC_MAILBOX_REGISTER_TEST;
 	mcp->mb[1] = 0xAAAA;
@@ -639,11 +639,11 @@ qla2x00_mbx_reg_test(scsi_qla_host_t *ha
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_mbx_reg_test(%ld): failed=%x.\n",
-		    ha->host_no, rval);)
+		    ha->host_no, rval));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_mbx_reg_test(%ld): done.\n",
-		    ha->host_no);)
+		    ha->host_no));
 	}
 
 	return rval;
@@ -671,7 +671,7 @@ qla2x00_verify_checksum(scsi_qla_host_t 
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
 	mcp->mb[0] = MBC_VERIFY_CHECKSUM;
 	mcp->out_mb = MBX_0;
@@ -694,9 +694,9 @@ qla2x00_verify_checksum(scsi_qla_host_t 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed=%x chk sum=%x.\n", __func__,
 		    ha->host_no, rval, (IS_QLA24XX(ha) || IS_QLA54XX(ha) ?
-		    (mcp->mb[2] << 16) | mcp->mb[1]: mcp->mb[1]));)
+		    (mcp->mb[2] << 16) | mcp->mb[1]: mcp->mb[1])));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no);)
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
 	}
 
 	return rval;
@@ -743,9 +743,9 @@ qla2x00_issue_iocb(scsi_qla_host_t *ha, 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG(printk("qla2x00_issue_iocb(%ld): failed rval 0x%x\n",
-		    ha->host_no, rval);)
+		    ha->host_no, rval));
 		DEBUG2(printk("qla2x00_issue_iocb(%ld): failed rval 0x%x\n",
-		    ha->host_no, rval);)
+		    ha->host_no, rval));
 	} else {
 		sts_entry_t *sts_entry = (sts_entry_t *) buffer;
 
@@ -781,7 +781,7 @@ qla2x00_abort_command(scsi_qla_host_t *h
 	mbx_cmd_t	mc;
 	mbx_cmd_t	*mcp = &mc;
 
-	DEBUG11(printk("qla2x00_abort_command(%ld): entered.\n", ha->host_no);)
+	DEBUG11(printk("qla2x00_abort_command(%ld): entered.\n", ha->host_no));
 
 	fcport = sp->fcport;
 
@@ -813,11 +813,11 @@ qla2x00_abort_command(scsi_qla_host_t *h
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("qla2x00_abort_command(%ld): failed=%x.\n",
-		    ha->host_no, rval);)
+		    ha->host_no, rval));
 	} else {
 		sp->flags |= SRB_ABORT_PENDING;
 		DEBUG11(printk("qla2x00_abort_command(%ld): done.\n",
-		    ha->host_no);)
+		    ha->host_no));
 	}
 
 	return rval;
@@ -848,7 +848,7 @@ qla2x00_abort_target(fc_port_t *fcport)
 	if (fcport == NULL)
 		return 0;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->ha->host_no);)
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->ha->host_no));
 
 	ha = fcport->ha;
 	mcp->mb[0] = MBC_ABORT_TARGET;
@@ -872,11 +872,11 @@ qla2x00_abort_target(fc_port_t *fcport)
 
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("qla2x00_abort_target(%ld): failed=%x.\n",
-		    ha->host_no, rval);)
+		    ha->host_no, rval));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_abort_target(%ld): done.\n",
-		    ha->host_no);)
+		    ha->host_no));
 	}
 
 	return rval;
@@ -912,7 +912,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_get_adapter_id(%ld): entered.\n",
-	    ha->host_no);)
+	    ha->host_no));
 
 	mcp->mb[0] = MBC_GET_ADAPTER_LOOP_ID;
 	mcp->out_mb = MBX_0;
@@ -933,11 +933,11 @@ qla2x00_get_adapter_id(scsi_qla_host_t *
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_get_adapter_id(%ld): failed=%x.\n",
-		    ha->host_no, rval);)
+		    ha->host_no, rval));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_get_adapter_id(%ld): done.\n",
-		    ha->host_no);)
+		    ha->host_no));
 	}
 
 	return rval;
@@ -968,7 +968,7 @@ qla2x00_get_retry_cnt(scsi_qla_host_t *h
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_get_retry_cnt(%ld): entered.\n",
-			ha->host_no);)
+			ha->host_no));
 
 	mcp->mb[0] = MBC_GET_RETRY_COUNT;
 	mcp->out_mb = MBX_0;
@@ -980,7 +980,7 @@ qla2x00_get_retry_cnt(scsi_qla_host_t *h
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_get_retry_cnt(%ld): failed = %x.\n",
-		    ha->host_no, mcp->mb[0]);)
+		    ha->host_no, mcp->mb[0]));
 	} else {
 		/* Convert returned data and check our values. */
 		*r_a_tov = mcp->mb[3] / 2;
@@ -992,7 +992,7 @@ qla2x00_get_retry_cnt(scsi_qla_host_t *h
 		}
 
 		DEBUG11(printk("qla2x00_get_retry_cnt(%ld): done. mb3=%d "
-		    "ratov=%d.\n", ha->host_no, mcp->mb[3], ratov);)
+		    "ratov=%d.\n", ha->host_no, mcp->mb[3], ratov));
 	}
 
 	return rval;
@@ -1023,7 +1023,7 @@ qla2x00_init_firmware(scsi_qla_host_t *h
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_init_firmware(%ld): entered.\n",
-	    ha->host_no);)
+	    ha->host_no));
 
 	mcp->mb[0] = MBC_INITIALIZE_FIRMWARE;
 	mcp->mb[2] = MSW(ha->init_cb_dma);
@@ -1043,11 +1043,11 @@ qla2x00_init_firmware(scsi_qla_host_t *h
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_init_firmware(%ld): failed=%x "
 		    "mb0=%x.\n",
-		    ha->host_no, rval, mcp->mb[0]);)
+		    ha->host_no, rval, mcp->mb[0]));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_init_firmware(%ld): done.\n",
-		    ha->host_no);)
+		    ha->host_no));
 	}
 
 	return rval;
@@ -1079,7 +1079,7 @@ qla2x00_get_port_database(scsi_qla_host_
 	struct port_database_24xx *pd24;
 	dma_addr_t pd_dma;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
 	pd24 = NULL;
 	pd = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
@@ -1220,7 +1220,7 @@ qla2x00_get_firmware_state(scsi_qla_host
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_get_firmware_state(%ld): entered.\n",
-	    ha->host_no);)
+	    ha->host_no));
 
 	mcp->mb[0] = MBC_GET_FIRMWARE_STATE;
 	mcp->out_mb = MBX_0;
@@ -1235,11 +1235,11 @@ qla2x00_get_firmware_state(scsi_qla_host
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_get_firmware_state(%ld): "
-		    "failed=%x.\n", ha->host_no, rval);)
+		    "failed=%x.\n", ha->host_no, rval));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_get_firmware_state(%ld): done.\n",
-		    ha->host_no);)
+		    ha->host_no));
 	}
 
 	return rval;
@@ -1272,7 +1272,7 @@ qla2x00_get_port_name(scsi_qla_host_t *h
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_get_port_name(%ld): entered.\n",
-	    ha->host_no);)
+	    ha->host_no));
 
 	mcp->mb[0] = MBC_GET_PORT_NAME;
 	mcp->out_mb = MBX_1|MBX_0;
@@ -1292,7 +1292,7 @@ qla2x00_get_port_name(scsi_qla_host_t *h
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_get_port_name(%ld): failed=%x.\n",
-		    ha->host_no, rval);)
+		    ha->host_no, rval));
 	} else {
 		if (name != NULL) {
 			/* This function returns name in big endian. */
@@ -1307,7 +1307,7 @@ qla2x00_get_port_name(scsi_qla_host_t *h
 		}
 
 		DEBUG11(printk("qla2x00_get_port_name(%ld): done.\n",
-		    ha->host_no);)
+		    ha->host_no));
 	}
 
 	return rval;
@@ -1335,7 +1335,7 @@ qla2x00_lip_reset(scsi_qla_host_t *ha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
 	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		mcp->mb[0] = MBC_LIP_FULL_LOGIN;
@@ -1364,10 +1364,10 @@ qla2x00_lip_reset(scsi_qla_host_t *ha)
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n",
-		    __func__, ha->host_no, rval);)
+		    __func__, ha->host_no, rval));
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no);)
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
 	}
 
 	return rval;
@@ -1400,10 +1400,10 @@ qla2x00_send_sns(scsi_qla_host_t *ha, dm
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_send_sns(%ld): entered.\n",
-	    ha->host_no);)
+	    ha->host_no));
 
 	DEBUG11(printk("qla2x00_send_sns: retry cnt=%d ratov=%d total "
-	    "tov=%d.\n", ha->retry_count, ha->login_timeout, mcp->tov);)
+	    "tov=%d.\n", ha->retry_count, ha->login_timeout, mcp->tov));
 
 	mcp->mb[0] = MBC_SEND_SNS_COMMAND;
 	mcp->mb[1] = cmd_size;
@@ -1421,12 +1421,12 @@ qla2x00_send_sns(scsi_qla_host_t *ha, dm
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG(printk("qla2x00_send_sns(%ld): failed=%x mb[0]=%x "
-		    "mb[1]=%x.\n", ha->host_no, rval, mcp->mb[0], mcp->mb[1]);)
+		    "mb[1]=%x.\n", ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 		DEBUG2_3_11(printk("qla2x00_send_sns(%ld): failed=%x mb[0]=%x "
-		    "mb[1]=%x.\n", ha->host_no, rval, mcp->mb[0], mcp->mb[1]);)
+		    "mb[1]=%x.\n", ha->host_no, rval, mcp->mb[0], mcp->mb[1]));
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("qla2x00_send_sns(%ld): done.\n", ha->host_no);)
+		DEBUG11(printk("qla2x00_send_sns(%ld): done.\n", ha->host_no));
 	}
 
 	return rval;
@@ -1442,7 +1442,7 @@ qla24xx_login_fabric(scsi_qla_host_t *ha
 	dma_addr_t	lg_dma;
 	uint32_t	iop[2];
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
 	lg = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
 	if (lg == NULL) {
@@ -1466,7 +1466,7 @@ qla24xx_login_fabric(scsi_qla_host_t *ha
 	rval = qla2x00_issue_iocb(ha, lg, lg_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Login IOCB "
-		    "(%x).\n", __func__, ha->host_no, rval);)
+		    "(%x).\n", __func__, ha->host_no, rval));
 	} else if (lg->entry_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- error status (%x).\n", __func__, ha->host_no,
@@ -1507,7 +1507,7 @@ qla24xx_login_fabric(scsi_qla_host_t *ha
 			break;
 		}
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no);)
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
 
 		iop[0] = le32_to_cpu(lg->io_parameter[0]);
 
@@ -1561,7 +1561,7 @@ qla2x00_login_fabric(scsi_qla_host_t *ha
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("qla2x00_login_fabric(%ld): entered.\n", ha->host_no);)
+	DEBUG11(printk("qla2x00_login_fabric(%ld): entered.\n", ha->host_no));
 
 	mcp->mb[0] = MBC_LOGIN_FABRIC_PORT;
 	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
@@ -1606,11 +1606,11 @@ qla2x00_login_fabric(scsi_qla_host_t *ha
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_login_fabric(%ld): failed=%x "
 		    "mb[0]=%x mb[1]=%x mb[2]=%x.\n", ha->host_no, rval,
-		    mcp->mb[0], mcp->mb[1], mcp->mb[2]);)
+		    mcp->mb[0], mcp->mb[1], mcp->mb[2]));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_login_fabric(%ld): done.\n",
-		    ha->host_no);)
+		    ha->host_no));
 	}
 
 	return rval;
@@ -1645,7 +1645,7 @@ qla2x00_login_local_device(scsi_qla_host
 		    fcport->d_id.b.domain, fcport->d_id.b.area,
 		    fcport->d_id.b.al_pa, mb_ret, opt);
 
-	DEBUG3(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
+	DEBUG3(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
 	mcp->mb[0] = MBC_LOGIN_LOOP_PORT;
 	if (HAS_EXTENDED_IDS(ha))
@@ -1679,13 +1679,13 @@ qla2x00_login_local_device(scsi_qla_host
 
 		DEBUG(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x "
 		    "mb[6]=%x mb[7]=%x.\n", __func__, ha->host_no, rval,
-		    mcp->mb[0], mcp->mb[1], mcp->mb[6], mcp->mb[7]);)
+		    mcp->mb[0], mcp->mb[1], mcp->mb[6], mcp->mb[7]));
 		DEBUG2_3(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x "
 		    "mb[6]=%x mb[7]=%x.\n", __func__, ha->host_no, rval,
-		    mcp->mb[0], mcp->mb[1], mcp->mb[6], mcp->mb[7]);)
+		    mcp->mb[0], mcp->mb[1], mcp->mb[6], mcp->mb[7]));
 	} else {
 		/*EMPTY*/
-		DEBUG3(printk("%s(%ld): done.\n", __func__, ha->host_no);)
+		DEBUG3(printk("%s(%ld): done.\n", __func__, ha->host_no));
 	}
 
 	return (rval);
@@ -1699,7 +1699,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *h
 	struct logio_entry_24xx *lg;
 	dma_addr_t	lg_dma;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
 	lg = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
 	if (lg == NULL) {
@@ -1720,7 +1720,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *h
 	rval = qla2x00_issue_iocb(ha, lg, lg_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Logout IOCB "
-		    "(%x).\n", __func__, ha->host_no, rval);)
+		    "(%x).\n", __func__, ha->host_no, rval));
 	} else if (lg->entry_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- error status (%x).\n", __func__, ha->host_no,
@@ -1731,10 +1731,10 @@ qla24xx_fabric_logout(scsi_qla_host_t *h
 		    "-- completion status (%x)  ioparam=%x/%x.\n", __func__,
 		    ha->host_no, le16_to_cpu(lg->comp_status),
 		    le32_to_cpu(lg->io_parameter[0]),
-		    le32_to_cpu(lg->io_parameter[1]));)
+		    le32_to_cpu(lg->io_parameter[1])));
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no);)
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
 	}
 
 	dma_pool_free(ha->s_dma_pool, lg, lg_dma);
@@ -1767,7 +1767,7 @@ qla2x00_fabric_logout(scsi_qla_host_t *h
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_fabric_logout(%ld): entered.\n",
-	    ha->host_no);)
+	    ha->host_no));
 
 	mcp->mb[0] = MBC_LOGOUT_FABRIC_PORT;
 	mcp->out_mb = MBX_1|MBX_0;
@@ -1787,11 +1787,11 @@ qla2x00_fabric_logout(scsi_qla_host_t *h
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_fabric_logout(%ld): failed=%x "
-		    "mbx1=%x.\n", ha->host_no, rval, mcp->mb[1]);)
+		    "mbx1=%x.\n", ha->host_no, rval, mcp->mb[1]));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_fabric_logout(%ld): done.\n",
-		    ha->host_no);)
+		    ha->host_no));
 	}
 
 	return rval;
@@ -1820,7 +1820,7 @@ qla2x00_full_login_lip(scsi_qla_host_t *
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_full_login_lip(%ld): entered.\n",
-	    ha->host_no);)
+	    ha->host_no));
 
 	mcp->mb[0] = MBC_LIP_FULL_LOGIN;
 	mcp->mb[1] = 0;
@@ -1835,11 +1835,11 @@ qla2x00_full_login_lip(scsi_qla_host_t *
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_full_login_lip(%ld): failed=%x.\n",
-		    ha->host_no, rval);)
+		    ha->host_no, rval));
 	} else {
 		/*EMPTY*/
 		DEBUG11(printk("qla2x00_full_login_lip(%ld): done.\n",
-		    ha->host_no);)
+		    ha->host_no));
 	}
 
 	return rval;
@@ -1866,7 +1866,7 @@ qla2x00_get_id_list(scsi_qla_host_t *ha,
 	mbx_cmd_t *mcp = &mc;
 
 	DEBUG11(printk("qla2x00_get_id_list(%ld): entered.\n",
-	    ha->host_no);)
+	    ha->host_no));
 
 	if (id_list == NULL)
 		return QLA_FUNCTION_FAILED;
@@ -1895,11 +1895,11 @@ qla2x00_get_id_list(scsi_qla_host_t *ha,
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("qla2x00_get_id_list(%ld): failed=%x.\n",
-		    ha->host_no, rval);)
+		    ha->host_no, rval));
 	} else {
 		*entries = mcp->mb[1];
 		DEBUG11(printk("qla2x00_get_id_list(%ld): done.\n",
-		    ha->host_no);)
+		    ha->host_no));
 	}
 
 	return rval;
@@ -1938,7 +1938,7 @@ qla2x00_get_resource_cnts(scsi_qla_host_
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
 		DEBUG2_3_11(printk("%s(%ld): failed = %x.\n", __func__,
-		    ha->host_no, mcp->mb[0]);)
+		    ha->host_no, mcp->mb[0]));
 	} else {
 		DEBUG11(printk("%s(%ld): done. mb1=%x mb2=%x mb3=%x mb6=%x "
 		    "mb7=%x mb10=%x.\n", __func__, ha->host_no,
@@ -2047,7 +2047,7 @@ qla2x00_get_link_status(scsi_qla_host_t 
 	link_stat_t *stat_buf;
 	dma_addr_t stat_buf_dma;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
 	stat_buf = dma_pool_alloc(ha->s_dma_pool, GFP_ATOMIC, &stat_buf_dma);
 	if (stat_buf == NULL) {
@@ -2085,7 +2085,7 @@ qla2x00_get_link_status(scsi_qla_host_t 
 	if (rval == QLA_SUCCESS) {
 		if (mcp->mb[0] != MBS_COMMAND_COMPLETE) {
 			DEBUG2_3_11(printk("%s(%ld): cmd failed. mbx0=%x.\n",
-			    __func__, ha->host_no, mcp->mb[0]);)
+			    __func__, ha->host_no, mcp->mb[0]));
 			status[0] = mcp->mb[0];
 			rval = BIT_1;
 		} else {
@@ -2110,12 +2110,12 @@ qla2x00_get_link_status(scsi_qla_host_t 
 			    stat_buf->loss_sync_cnt, stat_buf->loss_sig_cnt,
 			    stat_buf->prim_seq_err_cnt,
 			    stat_buf->inval_xmit_word_cnt,
-			    stat_buf->inval_crc_cnt);)
+			    stat_buf->inval_crc_cnt));
 		}
 	} else {
 		/* Failed. */
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    ha->host_no, rval);)
+		    ha->host_no, rval));
 		rval = BIT_1;
 	}
 
@@ -2134,7 +2134,7 @@ qla24xx_get_isp_stats(scsi_qla_host_t *h
 	uint32_t *sbuf, *siter;
 	dma_addr_t sbuf_dma;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
 	if (dwords > (DMA_POOL_SIZE / 4)) {
 		DEBUG2_3_11(printk("%s(%ld): Unabled to retrieve %d DWORDs "
@@ -2198,7 +2198,7 @@ qla24xx_abort_command(scsi_qla_host_t *h
 	dma_addr_t	abt_dma;
 	uint32_t	handle;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no);)
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
 	fcport = sp->fcport;
 
@@ -2231,7 +2231,7 @@ qla24xx_abort_command(scsi_qla_host_t *h
 	rval = qla2x00_issue_iocb(ha, abt, abt_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue IOCB (%x).\n",
-		    __func__, ha->host_no, rval);)
+		    __func__, ha->host_no, rval));
 	} else if (abt->entry_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- error status (%x).\n", __func__, ha->host_no,
@@ -2240,10 +2240,10 @@ qla24xx_abort_command(scsi_qla_host_t *h
 	} else if (abt->nport_handle != __constant_cpu_to_le16(0)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- completion status (%x).\n", __func__, ha->host_no,
-		    le16_to_cpu(abt->nport_handle));)
+		    le16_to_cpu(abt->nport_handle)));
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no);)
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
 		sp->flags |= SRB_ABORT_PENDING;
 	}
 
@@ -2270,7 +2270,7 @@ qla24xx_abort_target(fc_port_t *fcport)
 	if (fcport == NULL)
 		return 0;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->ha->host_no);)
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->ha->host_no));
 
 	ha = fcport->ha;
 	tsk = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &tsk_dma);
@@ -2292,7 +2292,7 @@ qla24xx_abort_target(fc_port_t *fcport)
 	rval = qla2x00_issue_iocb(ha, tsk, tsk_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Target Reset IOCB "
-		    "(%x).\n", __func__, ha->host_no, rval);)
+		    "(%x).\n", __func__, ha->host_no, rval));
 		goto atarget_done;
 	} else if (tsk->p.sts.entry_status != 0) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
@@ -2304,7 +2304,7 @@ qla24xx_abort_target(fc_port_t *fcport)
 	    __constant_cpu_to_le16(CS_COMPLETE)) {
 		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
 		    "-- completion status (%x).\n", __func__,
-		    ha->host_no, le16_to_cpu(tsk->p.sts.comp_status));)
+		    ha->host_no, le16_to_cpu(tsk->p.sts.comp_status)));
 		rval = QLA_FUNCTION_FAILED;
 		goto atarget_done;
 	}
@@ -2313,9 +2313,9 @@ qla24xx_abort_target(fc_port_t *fcport)
 	rval = qla2x00_marker(ha, fcport->loop_id, 0, MK_SYNC_ID);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Marker IOCB "
-		    "(%x).\n", __func__, ha->host_no, rval);)
+		    "(%x).\n", __func__, ha->host_no, rval));
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no);)
+		DEBUG11(printk("%s(%ld): done.\n", __func__, ha->host_no));
 	}
 
 atarget_done:
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0c6e334..fedf2f1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -631,7 +631,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 
 		DEBUG2(printk("%s(%ld): aborting sp %p from RISC. pid=%ld.\n",
 		    __func__, ha->host_no, sp, serial));
-		DEBUG3(qla2x00_print_scsi_cmd(cmd);)
+		DEBUG3(qla2x00_print_scsi_cmd(cmd));
 
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		if (ha->isp_ops.abort_command(ha, sp)) {
@@ -773,7 +773,7 @@ #if defined(LOGOUT_AFTER_DEVICE_RESET)
 #endif
 	} else {
 		DEBUG2(printk(KERN_INFO
-		    "%s failed: loop not ready\n",__func__);)
+		    "%s failed: loop not ready\n",__func__));
 	}
 
 	if (ret == FAILED) {
@@ -1028,12 +1028,12 @@ qla2x00_loop_reset(scsi_qla_host_t *ha)
 		/* Empty */
 		DEBUG2_3(printk("%s(%ld): **** FAILED ****\n",
 				__func__,
-				ha->host_no);)
+				ha->host_no));
 	} else {
 		/* Empty */
 		DEBUG3(printk("%s(%ld): exiting normally.\n",
 				__func__,
-				ha->host_no);)
+				ha->host_no));
 	}
 
 	return(status);
-- 
1.4.1.rc1.gf603


