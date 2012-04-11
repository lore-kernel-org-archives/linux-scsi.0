From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] qla2xxx: Fix typo in qla2xxx files
Date: Thu, 12 Apr 2012 01:31:00 +0900
Message-ID: <1334161860-7433-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:50009 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760656Ab2DKQbI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Apr 2012 12:31:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, linux-driver@qlogic.com, trivial@kernel.org, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>

Correct spelling typo within qla2xxx files.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c     |    4 ++--
 drivers/scsi/qla2xxx/qla_fw.h      |    4 ++--
 drivers/scsi/qla2xxx/qla_iocb.c    |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c     |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |    4 ++--
 drivers/scsi/qla2xxx/qla_mid.c     |    2 +-
 drivers/scsi/qla2xxx/qla_nx.c      |    4 ++--
 drivers/scsi/qla2xxx/qla_os.c      |    6 +++---
 drivers/scsi/qla2xxx/qla_target.c  |   12 ++++++------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    4 ++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |    2 +-
 11 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 0393915..a774f9c 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2295,7 +2295,7 @@ ql_dbg(uint32_t level, scsi_qla_host_t *vha, int32_t id, const char *fmt, ...)
 
 /*
  * This function is for formatting and logging debug information.
- * It is to be used when vha is not available and pci is availble,
+ * It is to be used when vha is not available and pci is available,
  * i.e., before host allocation. It formats the message and logs it
  * to the messages file.
  * parameters:
@@ -2390,7 +2390,7 @@ ql_log(uint32_t level, scsi_qla_host_t *vha, int32_t id, const char *fmt, ...)
 
 /*
  * This function is for formatting and logging log messages.
- * It is to be used when vha is not available and pci is availble,
+ * It is to be used when vha is not available and pci is available,
  * i.e., before host allocation. It formats the message and logs
  * it to the messages file. All the messages are logged irrespective
  * of the value of ql2xextended_error_logging.
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 6d7d775..980b5a7 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1130,7 +1130,7 @@ struct mid_db_entry_24xx {
 /*
  * Virtual Port Control IOCB
  */
-#define VP_CTRL_IOCB_TYPE	0x30	/* Vitual Port Control entry. */
+#define VP_CTRL_IOCB_TYPE	0x30	/* Virtual Port Control entry. */
 struct vp_ctrl_entry_24xx {
 	uint8_t entry_type;		/* Entry type. */
 	uint8_t entry_count;		/* Entry count. */
@@ -1166,7 +1166,7 @@ struct vp_ctrl_entry_24xx {
 /*
  * Modify Virtual Port Configuration IOCB
  */
-#define VP_CONFIG_IOCB_TYPE	0x31	/* Vitual Port Config entry. */
+#define VP_CONFIG_IOCB_TYPE	0x31	/* Virtual Port Config entry. */
 struct vp_config_entry_24xx {
 	uint8_t entry_type;		/* Entry type. */
 	uint8_t entry_count;		/* Entry count. */
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 88dd472..a075f46 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1936,7 +1936,7 @@ qla2x00_alloc_iocbs(scsi_qla_host_t *vha, srb_t *sp)
 	}
 	if (index == MAX_OUTSTANDING_COMMANDS) {
 		ql_log(ql_log_warn, vha, 0x700b,
-		    "No room on oustanding cmd array.\n");
+		    "No room on outstanding cmd array.\n");
 		goto queuing_error;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6656fda..a5ac4f7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1415,7 +1415,7 @@ qla2x00_handle_sense(srb_t *sp, uint8_t *sense_data, uint32_t par_sense_len,
 
 struct scsi_dif_tuple {
 	__be16 guard;       /* Checksum */
-	__be16 app_tag;         /* APPL identifer */
+	__be16 app_tag;         /* APPL identifier */
 	__be32 ref_tag;         /* Target LBA or indirect LBA */
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index c0d7080..a2f74a5 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -321,7 +321,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 					    CRB_NIU_XG_PAUSE_CTL_P1);
 				}
 				ql_log(ql_log_info, base_vha, 0x101c,
-				    "Mailbox cmd timeout occured, cmd=0x%x, "
+				    "Mailbox cmd timeout occurred, cmd=0x%x, "
 				    "mb[0]=0x%x, eeh_busy=0x%x. Scheduling ISP "
 				    "abort.\n", command, mcp->mb[0],
 				    ha->flags.eeh_busy);
@@ -346,7 +346,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 					    CRB_NIU_XG_PAUSE_CTL_P1);
 				}
 				ql_log(ql_log_info, base_vha, 0x101e,
-				    "Mailbox cmd timeout occured, cmd=0x%x, "
+				    "Mailbox cmd timeout occurred, cmd=0x%x, "
 				    "mb[0]=0x%x. Scheduling ISP abort ",
 				    command, mcp->mb[0]);
 				set_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index cdd2fdd..394f112 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -650,7 +650,7 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 			&req->dma, GFP_KERNEL);
 	if (req->ring == NULL) {
 		ql_log(ql_log_fatal, base_vha, 0x00da,
-		    "Failed to allocte memory for request_ring.\n");
+		    "Failed to allocate memory for request_ring.\n");
 		goto que_failed;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index f052853..d281b47 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2446,7 +2446,7 @@ qla82xx_load_fw(scsi_qla_host_t *vha)
 
 	if (qla82xx_fw_load_from_flash(ha) == QLA_SUCCESS) {
 		ql_log(ql_log_info, vha, 0x00a1,
-		    "Firmware loaded successully from flash.\n");
+		    "Firmware loaded successfully from flash.\n");
 		return QLA_SUCCESS;
 	} else {
 		ql_log(ql_log_warn, vha, 0x0108,
@@ -4005,7 +4005,7 @@ qla82xx_minidump_process_rdmem(scsi_qla_host_t *vha,
 
 	if (r_addr & 0xf) {
 		ql_log(ql_log_warn, vha, 0xb033,
-		    "Read addr 0x%x not 16 bytes alligned\n", r_addr);
+		    "Read addr 0x%x not 16 bytes aligned\n", r_addr);
 		return rval;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c49f39e..850364f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1103,7 +1103,7 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 	if (qla2x00_eh_wait_for_pending_commands(vha, cmd->device->id,
 	    cmd->device->lun, type) != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800d,
-		    "wait for peding cmds failed for cmd=%p.\n", cmd);
+		    "wait for pending cmds failed for cmd=%p.\n", cmd);
 		goto eh_reset_failed;
 	}
 
@@ -1202,7 +1202,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 eh_bus_reset_done:
 	ql_log(ql_log_warn, vha, 0x802b,
 	    "BUS RESET %s nexus=%ld:%d:%d.\n",
-	    (ret == FAILED) ? "FAILED" : "SUCCEDED", vha->host_no, id, lun);
+	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no, id, lun);
 
 	return ret;
 }
@@ -4529,7 +4529,7 @@ qla2x00_module_init(void)
 		return ret;
 	} else if (ret > 0) {
 		/*
-		 * If initiator mode is explictly disabled by qla_tgt_init(),
+		 * If initiator mode is explicitly disabled by qla_tgt_init(),
 		 * prevent scsi_transport_fc.c:fc_scsi_scan_rport() from
 		 * performing scsi_scan_target() during LOOP UP event.
 		 */
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 7368fcb..e20bc5f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -74,7 +74,7 @@ enum fcp_resp_rsp_codes {
 #define FCP_PTA_SIMPLE      0   /* simple task attribute */
 #define FCP_PTA_HEADQ       1   /* head of queue task attribute */
 #define FCP_PTA_ORDERED     2   /* ordered task attribute */
-#define FCP_PTA_ACA         4   /* auto. contigent allegiance */
+#define FCP_PTA_ACA         4   /* auto. contingent allegiance */
 #define FCP_PTA_MASK        7   /* mask for task attribute field */
 #define FCP_PRI_SHIFT       3   /* priority field starts in bit 3 */
 #define FCP_PRI_RESVD_MASK  0x80        /* reserved bits in priority field */
@@ -3814,12 +3814,12 @@ void qla_tgt_async_event(uint16_t code, struct scsi_qla_host *vha, uint16_t *mai
 	case MBA_RSP_TRANSFER_ERR:	/* Response Transfer Error */
 	case MBA_WAKEUP_THRES:		/* Request Queue Wake-up. */
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe141, "qla_target(%d): System error async event %#x "
-			"occured", vha->vp_idx, code);
+			"occurred", vha->vp_idx, code);
 		break;
 
 	case MBA_LOOP_UP:
 	{
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe142, "qla_target(%d): Async LOOP_UP occured "
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe142, "qla_target(%d): Async LOOP_UP occurred "
 			"(m[1]=%x, m[2]=%x, m[3]=%x, m[4]=%x)", vha->vp_idx,
 			le16_to_cpu(mailbox[1]), le16_to_cpu(mailbox[2]),
 			le16_to_cpu(mailbox[3]), le16_to_cpu(mailbox[4]));
@@ -3835,7 +3835,7 @@ void qla_tgt_async_event(uint16_t code, struct scsi_qla_host *vha, uint16_t *mai
 	case MBA_LOOP_DOWN:
 	case MBA_LIP_RESET:
 	case MBA_RSCN_UPDATE:
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe143, "qla_target(%d): Async event %#x occured "
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe143, "qla_target(%d): Async event %#x occurred "
 			"(m[1]=%x, m[2]=%x, m[3]=%x, m[4]=%x)", vha->vp_idx,
 			code, le16_to_cpu(mailbox[1]), le16_to_cpu(mailbox[2]),
 			le16_to_cpu(mailbox[3]), le16_to_cpu(mailbox[4]));
@@ -3843,7 +3843,7 @@ void qla_tgt_async_event(uint16_t code, struct scsi_qla_host *vha, uint16_t *mai
 
 	case MBA_PORT_UPDATE:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe144, "qla_target(%d): Port update async event %#x "
-			"occured: updating the ports database (m[1]=%x, m[2]=%x, "
+			"occurred: updating the ports database (m[1]=%x, m[2]=%x, "
 			"m[3]=%x, m[4]=%x)", vha->vp_idx, code,
 			le16_to_cpu(mailbox[1]), le16_to_cpu(mailbox[2]),
 			le16_to_cpu(mailbox[3]), le16_to_cpu(mailbox[4]));
@@ -3855,7 +3855,7 @@ void qla_tgt_async_event(uint16_t code, struct scsi_qla_host *vha, uint16_t *mai
 		break;
 
 	default:
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe147, "qla_target(%d): Async event %#x occured: "
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe147, "qla_target(%d): Async event %#x occurred: "
 			"ignore (m[1]=%x, m[2]=%x, m[3]=%x, m[4]=%x)",
 			vha->vp_idx, code,
 			le16_to_cpu(mailbox[1]), le16_to_cpu(mailbox[2]),
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 6dd8102..2a30c5a 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -363,7 +363,7 @@ struct se_node_acl *tcm_qla2xxx_alloc_fabric_acl(struct se_portal_group *se_tpg)
 
 	nacl = kzalloc(sizeof(struct tcm_qla2xxx_nacl), GFP_KERNEL);
 	if (!nacl) {
-		pr_err("Unable to alocate struct tcm_qla2xxx_nacl\n");
+		pr_err("Unable to allocate struct tcm_qla2xxx_nacl\n");
 		return NULL;
 	}
 
@@ -1511,7 +1511,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 		return PTR_ERR(se_sess);
 	}
 	/*
-	 * Format the FCP Initiator port_name into colon seperated values to match
+	 * Format the FCP Initiator port_name into colon separated values to match
 	 * the format by tcm_qla2xxx explict ConfigFS NodeACLs.
 	 */
 	memset(&port_name, 0, 36);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 41730ed..3e9ee43 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -3,7 +3,7 @@
 #define TCM_QLA2XXX_VERSION	"v0.1"
 /* length of ASCII WWPNs including pad */
 #define TCM_QLA2XXX_NAMELEN	32
-/* lenth of ASCII NPIV 'WWPN+WWNN' including pad */
+/* length of ASCII NPIV 'WWPN+WWNN' including pad */
 #define TCM_QLA2XXX_NPIV_NAMELEN 66
 
 #include "qla_target.h"
-- 
1.7.10.128.g7945c

