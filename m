From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] qla2xxx: Fix typo in qla2xxx drivers
Date: Fri, 26 Oct 2012 22:10:54 +0900
Message-ID: <1351257054-12729-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: trivial@kernel.org, linux-kernel@vger.kernel.org, andrew.vasquez@qlogic.com, linux-driver@qlogic.com, linux-scsi@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Correct spelling typo in debug messages within qla2xxx drivers.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c    |  2 +-
 drivers/scsi/qla2xxx/qla_isr.c     |  4 ++--
 drivers/scsi/qla2xxx/qla_mid.c     |  2 +-
 drivers/scsi/qla2xxx/qla_nx.c      |  6 +++---
 drivers/scsi/qla2xxx/qla_os.c      |  2 +-
 drivers/scsi/qla2xxx/qla_target.c  | 12 ++++++------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  2 +-
 7 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 70dbf53..23e8375 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1858,7 +1858,7 @@ qla2x00_alloc_iocbs(scsi_qla_host_t *vha, srb_t *sp)
 	}
 	if (index == MAX_OUTSTANDING_COMMANDS) {
 		ql_log(ql_log_warn, vha, 0x700b,
-		    "No room on oustanding cmd array.\n");
+		    "No room on outstanding cmd array.\n");
 		goto queuing_error;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6f67a9d..fce641e 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -251,7 +251,7 @@ qla2x00_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 	/* Read all mbox registers? */
 	mboxes = (1 << ha->mbx_count) - 1;
 	if (!ha->mcp)
-		ql_dbg(ql_dbg_async, vha, 0x5001, "MBX pointer ERRROR.\n");
+		ql_dbg(ql_dbg_async, vha, 0x5001, "MBX pointer ERROR.\n");
 	else
 		mboxes = ha->mcp->in_mb;
 
@@ -1972,7 +1972,7 @@ qla24xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 	/* Read all mbox registers? */
 	mboxes = (1 << ha->mbx_count) - 1;
 	if (!ha->mcp)
-		ql_dbg(ql_dbg_async, vha, 0x504e, "MBX pointer ERRROR.\n");
+		ql_dbg(ql_dbg_async, vha, 0x504e, "MBX pointer ERROR.\n");
 	else
 		mboxes = ha->mcp->in_mb;
 
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 3e8b324..54330ff 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -643,7 +643,7 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 			&req->dma, GFP_KERNEL);
 	if (req->ring == NULL) {
 		ql_log(ql_log_fatal, base_vha, 0x00da,
-		    "Failed to allocte memory for request_ring.\n");
+		    "Failed to allocate memory for request_ring.\n");
 		goto que_failed;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 9ce3a8f..10a302e 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -955,7 +955,7 @@ qla82xx_rom_fast_read(struct qla_hw_data *ha, int addr, int *valp)
 	}
 	if (loops >= 50000) {
 		ql_log(ql_log_fatal, vha, 0x00b9,
-		    "Failed to aquire SEM2 lock.\n");
+		    "Failed to acquire SEM2 lock.\n");
 		return -1;
 	}
 	ret = qla82xx_do_rom_fast_read(ha, addr, valp);
@@ -1122,7 +1122,7 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 		long data;
 	};
 
-	/* Halt all the indiviual PEGs and other blocks of the ISP */
+	/* Halt all the individual PEGs and other blocks of the ISP */
 	qla82xx_rom_lock(ha);
 
 	/* disable all I2Q */
@@ -4030,7 +4030,7 @@ qla82xx_minidump_process_rdmem(scsi_qla_host_t *vha,
 
 	if (r_addr & 0xf) {
 		ql_log(ql_log_warn, vha, 0xb033,
-		    "Read addr 0x%x not 16 bytes alligned\n", r_addr);
+		    "Read addr 0x%x not 16 bytes aligned\n", r_addr);
 		return rval;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index fb8cd38..18a6c7a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1177,7 +1177,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 eh_bus_reset_done:
 	ql_log(ql_log_warn, vha, 0x802b,
 	    "BUS RESET %s nexus=%ld:%d:%d.\n",
-	    (ret == FAILED) ? "FAILED" : "SUCCEDED", vha->host_no, id, lun);
+	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no, id, lun);
 
 	return ret;
 }
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 5b30132..75beb7e 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -73,7 +73,7 @@ enum fcp_resp_rsp_codes {
 #define FCP_PTA_SIMPLE      0   /* simple task attribute */
 #define FCP_PTA_HEADQ       1   /* head of queue task attribute */
 #define FCP_PTA_ORDERED     2   /* ordered task attribute */
-#define FCP_PTA_ACA         4   /* auto. contigent allegiance */
+#define FCP_PTA_ACA         4   /* auto. contingent allegiance */
 #define FCP_PTA_MASK        7   /* mask for task attribute field */
 #define FCP_PRI_SHIFT       3   /* priority field starts in bit 3 */
 #define FCP_PRI_RESVD_MASK  0x80        /* reserved bits in priority field */
@@ -3983,7 +3983,7 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 	case MBA_RSP_TRANSFER_ERR:	/* Response Transfer Error */
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf03a,
 		    "qla_target(%d): System error async event %#x "
-		    "occured", vha->vp_idx, code);
+		    "occurred", vha->vp_idx, code);
 		break;
 	case MBA_WAKEUP_THRES:		/* Request Queue Wake-up. */
 		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
@@ -3992,7 +3992,7 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 	case MBA_LOOP_UP:
 	{
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf03b,
-		    "qla_target(%d): Async LOOP_UP occured "
+		    "qla_target(%d): Async LOOP_UP occurred "
 		    "(m[0]=%x, m[1]=%x, m[2]=%x, m[3]=%x)", vha->vp_idx,
 		    le16_to_cpu(mailbox[0]), le16_to_cpu(mailbox[1]),
 		    le16_to_cpu(mailbox[2]), le16_to_cpu(mailbox[3]));
@@ -4009,7 +4009,7 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 	case MBA_LIP_RESET:
 	case MBA_RSCN_UPDATE:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf03c,
-		    "qla_target(%d): Async event %#x occured "
+		    "qla_target(%d): Async event %#x occurred "
 		    "(m[0]=%x, m[1]=%x, m[2]=%x, m[3]=%x)", vha->vp_idx, code,
 		    le16_to_cpu(mailbox[0]), le16_to_cpu(mailbox[1]),
 		    le16_to_cpu(mailbox[2]), le16_to_cpu(mailbox[3]));
@@ -4018,7 +4018,7 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 	case MBA_PORT_UPDATE:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf03d,
 		    "qla_target(%d): Port update async event %#x "
-		    "occured: updating the ports database (m[0]=%x, m[1]=%x, "
+		    "occurred: updating the ports database (m[0]=%x, m[1]=%x, "
 		    "m[2]=%x, m[3]=%x)", vha->vp_idx, code,
 		    le16_to_cpu(mailbox[0]), le16_to_cpu(mailbox[1]),
 		    le16_to_cpu(mailbox[2]), le16_to_cpu(mailbox[3]));
@@ -4034,7 +4034,7 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 
 	default:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf040,
-		    "qla_target(%d): Async event %#x occured: "
+		    "qla_target(%d): Async event %#x occurred: "
 		    "ignore (m[0]=%x, m[1]=%x, m[2]=%x, m[3]=%x)", vha->vp_idx,
 		    code, le16_to_cpu(mailbox[0]), le16_to_cpu(mailbox[1]),
 		    le16_to_cpu(mailbox[2]), le16_to_cpu(mailbox[3]));
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 4752f65..389083d 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -367,7 +367,7 @@ static struct se_node_acl *tcm_qla2xxx_alloc_fabric_acl(
 
 	nacl = kzalloc(sizeof(struct tcm_qla2xxx_nacl), GFP_KERNEL);
 	if (!nacl) {
-		pr_err("Unable to alocate struct tcm_qla2xxx_nacl\n");
+		pr_err("Unable to allocate struct tcm_qla2xxx_nacl\n");
 		return NULL;
 	}
 
-- 
1.8.0.rc3.16.g8ead1bf
