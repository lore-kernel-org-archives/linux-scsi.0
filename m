From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 27/29] qla2xxx: Correction to message ids.
Date: Tue, 27 Aug 2013 01:37:53 -0400
Message-ID: <1377581875-8574-28-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:26215 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937Ab3H0GGx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:53 -0400
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R63PaY019068
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:52 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1eg8v690wy-5
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:52 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |   12 ++++++++----
 drivers/scsi/qla2xxx/qla_mr.c  |    2 +-
 drivers/scsi/qla2xxx/qla_nx2.c |   10 +++++-----
 drivers/scsi/qla2xxx/qla_sup.c |    2 +-
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index f693b30..2ef497e 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -11,10 +11,11 @@
  * ----------------------------------------------------------------------
  * |             Level            |   Last Value Used  |     Holes	|
  * ----------------------------------------------------------------------
- * | Module Init and Probe        |       0x0152       | 0x4b,0xba,0xfa |
+ * | Module Init and Probe        |       0x0159       | 0x4b,0xba,0xfa |
  * | Mailbox commands             |       0x1181       | 0x111a-0x111b  |
  * |                              |                    | 0x1155-0x1158  |
  * |                              |                    | 0x1018-0x1019  |
+ * |                              |                    | 0x1115-0x1116  |
  * |                              |                    | 0x10ca		|
  * | Device Discovery             |       0x2095       | 0x2020-0x2022, |
  * |                              |                    | 0x2011-0x2012, |
@@ -28,7 +29,7 @@
  * | DPC Thread                   |       0x4022       | 0x4002,0x4013  |
  * | Async Events                 |       0x5087       | 0x502b-0x502f  |
  * |                              |                    | 0x5047,0x5052  |
- * |                              |                    | 0x5040,0x5075  |
+ * |                              |                    | 0x5084,0x5075	|
  * |                              |                    | 0x503d,0x5044  |
  * | Timer Routines               |       0x6012       |                |
  * | User Space Interactions      |       0x70e1       | 0x7018,0x702e, |
@@ -41,6 +42,7 @@
  * |                              |                    | 0x70ad-0x70ae, |
  * |                              |                    | 0x70d1-0x70db, |
  * |                              |                    | 0x7047,0x703b	|
+ * |                              |                    | 0x70de-0x70df, |
  * | Task Management              |       0x803d       | 0x8025-0x8026  |
  * |                              |                    | 0x800b,0x8039  |
  * | AER/EEH                      |       0x9011       |		|
@@ -54,10 +56,12 @@
  * |                              |                    | 0xb12c,0xb12d  |
  * |                              |                    | 0xb13a,0xb142  |
  * |                              |                    | 0xb13c-0xb140  |
+ * |                              |                    | 0xb149		|
  * | MultiQ                       |       0xc00c       |		|
  * | Misc                         |       0xd010       |		|
- * | Target Mode		  |	  0xe070       |		|
- * | Target Mode Management	  |	  0xf072       |		|
+ * | Target Mode		  |	  0xe070       | 0xe021		|
+ * | Target Mode Management	  |	  0xf072       | 0xf002-0xf003	|
+ * |                              |                    | 0xf046-0xf049  |
  * | Target Mode Task Management  |	  0x1000b      |		|
  * ----------------------------------------------------------------------
  */
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 39d1306..2482975 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1596,7 +1596,7 @@ qlafx00_timer_routine(scsi_qla_host_t *vha)
 		 */
 		if (ha->mr.fw_critemp_timer_tick == 0) {
 			tempc = QLAFX00_GET_TEMPERATURE(ha);
-			ql_log(ql_dbg_timer, vha, 0x6012,
+			ql_dbg(ql_dbg_timer, vha, 0x6012,
 			    "ISPFx00(%s): Critical temp timer, "
 			    "current SOC temperature: %d\n",
 			    __func__, tempc);
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 712a9bb..a26ce74 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -3153,7 +3153,7 @@ qla8044_poll_flash_status_reg(struct scsi_qla_host *vha)
 		ret_val = qla8044_rd_reg_indirect(vha, QLA8044_FLASH_STATUS,
 		    &flash_status);
 		if (ret_val) {
-			ql_log(ql_log_warn, vha, 0xb120,
+			ql_log(ql_log_warn, vha, 0xb13c,
 			    "%s: Failed to read FLASH_STATUS reg.\n",
 			    __func__);
 			break;
@@ -3484,7 +3484,7 @@ qla8044_write_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
 		}
 		erase_offset += QLA8044_SECTOR_SIZE;
 	}
-	ql_dbg(ql_dbg_user, vha, 0xb139,
+	ql_dbg(ql_dbg_user, vha, 0xb13f,
 	    "Got write for addr = 0x%x length=0x%x.\n",
 	    offset, length);
 
@@ -3653,7 +3653,7 @@ qla8044_clear_rst_ready(scsi_qla_host_t *vha)
 	 */
 	drv_state &= ~(1 << vha->hw->portnum);
 
-	ql_dbg(ql_dbg_p3p, vha, 0xb143,
+	ql_dbg(ql_dbg_p3p, vha, 0xb13d,
 	    "drv_state: 0x%08x\n", drv_state);
 	qla8044_wr_direct(vha, QLA8044_CRB_DRV_STATE_INDEX, drv_state);
 }
@@ -3681,13 +3681,13 @@ qla8044_abort_isp(scsi_qla_host_t *vha)
 		/* If IDC_CTRL DONTRESETHBA_BIT0 is set don't do reset
 		 * recovery */
 		if (qla8044_idc_dontreset(ha) == DONTRESET_BIT0) {
-			ql_dbg(ql_dbg_p3p, vha, 0xb144,
+			ql_dbg(ql_dbg_p3p, vha, 0xb13e,
 			    "Reset recovery disabled\n");
 			rval = QLA_FUNCTION_FAILED;
 			goto exit_isp_reset;
 		}
 
-		ql_dbg(ql_dbg_p3p, vha, 0xb145,
+		ql_dbg(ql_dbg_p3p, vha, 0xb140,
 		    "HW State: NEED RESET\n");
 		qla8044_wr_direct(vha, QLA8044_CRB_DEV_STATE_INDEX,
 		    QLA8XXX_DEV_NEED_RESET);
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 2f2e029..bd56cde 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2944,7 +2944,7 @@ qla82xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 		ha->fw_revision[0] = bcode[0x4];
 		ha->fw_revision[1] = bcode[0x5];
 		ha->fw_revision[2] = bcode[0x6];
-		ql_dbg(ql_dbg_init, vha, 0x015a,
+		ql_dbg(ql_dbg_init, vha, 0x0153,
 		    "Firmware revision %d.%d.%d\n",
 		    ha->fw_revision[0], ha->fw_revision[1],
 		    ha->fw_revision[2]);
-- 
1.7.7

