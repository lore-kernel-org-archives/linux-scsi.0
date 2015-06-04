From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 10/10] qla2xxx: Fix indentation
Date: Thu, 4 Jun 2015 15:58:09 -0700
Message-ID: <5570D801.5090703@sandisk.com>
References: <5570D656.9050704@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0087.outbound.protection.outlook.com ([157.56.110.87]:32256
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752184AbbFDW6U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jun 2015 18:58:20 -0400
In-Reply-To: <5570D656.9050704@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@odin.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Detected by smatch.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |  2 +-
 drivers/scsi/qla2xxx/qla_iocb.c |  8 ++++----
 drivers/scsi/qla2xxx/qla_isr.c  |  4 ++--
 drivers/scsi/qla2xxx/qla_nx.c   |  2 +-
 drivers/scsi/qla2xxx/qla_nx2.c  | 13 ++++++-------
 5 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 33cb3f6..5a5ca43 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -708,7 +708,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 		if (rval != QLA_SUCCESS) {
 			ql_log(ql_log_warn, vha, 0x00d4,
 			    "Unable to initialize ISP84XX.\n");
-		qla84xx_put_chip(vha);
+			qla84xx_put_chip(vha);
 		}
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 21d6f3f..524b5bc 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2763,10 +2763,10 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_host *vha, uint32_t tot_dsds)
 	handle = req->current_outstanding_cmd;
 	for (index = 1; index < req->num_outstanding_cmds; index++) {
 		handle++;
-	if (handle == req->num_outstanding_cmds)
-		handle = 1;
-	if (!req->outstanding_cmds[handle])
-		break;
+		if (handle == req->num_outstanding_cmds)
+			handle = 1;
+		if (!req->outstanding_cmds[handle])
+			break;
 	}
 
 	if (index == req->num_outstanding_cmds) {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 79f6989..b70af1f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1579,7 +1579,7 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void *tsk)
 			ql_log(ql_log_warn, fcport->vha, 0x503c,
 			    "Async-%s error - hdl=%x response(%x).\n",
 			    type, sp->handle, sts->data[3]);
-		iocb->u.tmf.data = QLA_FUNCTION_FAILED;
+			iocb->u.tmf.data = QLA_FUNCTION_FAILED;
 		}
 	}
 
@@ -1978,7 +1978,7 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 		rval = EXT_STATUS_ERR;
 		break;
 	}
-		bsg_job->reply->reply_payload_rcv_len = 0;
+	bsg_job->reply->reply_payload_rcv_len = 0;
 
 done:
 	/* Return the vendor specific reply to API */
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index b359a83..bb0ee7c 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1835,7 +1835,7 @@ qla82xx_set_product_offset(struct qla_hw_data *ha)
 
 	ptab_desc = qla82xx_get_table_desc(unirom,
 		 QLA82XX_URI_DIR_SECT_PRODUCT_TBL);
-       if (!ptab_desc)
+	if (!ptab_desc)
 		return -1;
 
 	entries = cpu_to_le32(ptab_desc->num_entries);
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index b8ceb82..007192d 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -397,11 +397,11 @@ qla8044_idc_lock(struct qla_hw_data *ha)
 				 * has the lock, wait for 2secs
 				 * and retry
 				 */
-				 ql_dbg(ql_dbg_p3p, vha, 0xb08a,
-				     "%s: IDC lock Recovery by %d "
-				     "failed, Retrying timeout\n", __func__,
-				     ha->portnum);
-				 timeout = 0;
+				ql_dbg(ql_dbg_p3p, vha, 0xb08a,
+				       "%s: IDC lock Recovery by %d "
+				       "failed, Retrying timeout\n", __func__,
+				       ha->portnum);
+				timeout = 0;
 			}
 		}
 		msleep(QLA8044_DRV_LOCK_MSLEEP);
@@ -3138,8 +3138,7 @@ qla8044_minidump_process_rdmdio(struct scsi_qla_host *vha,
 			goto error;
 
 		addr7 = addr2 - (4 * stride1);
-			data = qla8044_ipmdio_rd_reg(vha, addr1, addr3,
-			    mask, addr7);
+		data = qla8044_ipmdio_rd_reg(vha, addr1, addr3, mask, addr7);
 		if (data == -1)
 			goto error;
 
-- 
2.1.4

