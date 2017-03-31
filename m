From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 2/2] qla2xxx: Fix typo in driver
Date: Fri, 31 Mar 2017 14:37:04 -0700
Message-ID: <20170331213704.5577-3-himanshu.madhani@cavium.com>
References: <20170331213704.5577-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0054.outbound.protection.outlook.com ([104.47.42.54]:21357
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755199AbdCaVhb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 31 Mar 2017 17:37:31 -0400
In-Reply-To: <20170331213704.5577-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Milan P Gandhi <mgandhi@redhat.com>

Signed-off-by: Milan P Gandhi <mgandhi@redhat.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 2 +-
 drivers/scsi/qla2xxx/qla_bsg.c  | 2 +-
 drivers/scsi/qla2xxx/qla_gs.c   | 2 +-
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 drivers/scsi/qla2xxx/qla_isr.c  | 6 +++---
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 435ff7fd6384..7c8d6c54ab70 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -695,7 +695,7 @@ qla2x00_sysfs_write_reset(struct file *filp, struct kobject *kobj,
 	case 0x2025e:
 		if (!IS_P3P_TYPE(ha) || vha != base_vha) {
 			ql_log(ql_log_info, vha, 0x7071,
-			    "FCoE ctx reset no supported.\n");
+			    "FCoE ctx reset not supported.\n");
 			return -EPERM;
 		}
 
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 84c9098cc089..069104fed267 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1822,7 +1822,7 @@ qla24xx_process_bidir_cmd(struct bsg_job *bsg_job)
 	/* Check if operating mode is P2P */
 	if (ha->operating_mode != P2P) {
 		ql_log(ql_log_warn, vha, 0x70a4,
-		    "Host is operating mode is not P2p\n");
+		    "Host operating mode is not P2p\n");
 		rval = EXT_STATUS_INVALID_CFG;
 		goto done;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index ab0f873fd6a1..9bc9aa9e164a 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -144,7 +144,7 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
 			if (ct_rsp->header.response !=
 			    cpu_to_be16(CT_ACCEPT_RESPONSE)) {
 				ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x2077,
-				    "%s failed rejected request on port_id: %02x%02x%02x Compeltion status 0x%x, response 0x%x\n",
+				    "%s failed rejected request on port_id: %02x%02x%02x Completion status 0x%x, response 0x%x\n",
 				    routine, vha->d_id.b.domain,
 				    vha->d_id.b.area, vha->d_id.b.al_pa,
 				    comp_status, ct_rsp->header.response);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f9d2fe7b1ade..034743309ada 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2289,7 +2289,7 @@ qla2x00_chip_diag(scsi_qla_host_t *vha)
 		goto chip_diag_failed;
 
 	/* Check product ID of chip */
-	ql_dbg(ql_dbg_init, vha, 0x007d, "Checking product Id of chip.\n");
+	ql_dbg(ql_dbg_init, vha, 0x007d, "Checking product ID of chip.\n");
 
 	mb[1] = RD_MAILBOX_REG(ha, reg, 1);
 	mb[2] = RD_MAILBOX_REG(ha, reg, 2);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 3203367a4f42..aac03504d9a3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2100,14 +2100,14 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 
 	case CS_DATA_OVERRUN:
 		ql_dbg(ql_dbg_user, vha, 0x70b1,
-		    "Command completed with date overrun thread_id=%d\n",
+		    "Command completed with data overrun thread_id=%d\n",
 		    thread_id);
 		rval = EXT_STATUS_DATA_OVERRUN;
 		break;
 
 	case CS_DATA_UNDERRUN:
 		ql_dbg(ql_dbg_user, vha, 0x70b2,
-		    "Command completed with date underrun thread_id=%d\n",
+		    "Command completed with data underrun thread_id=%d\n",
 		    thread_id);
 		rval = EXT_STATUS_DATA_UNDERRUN;
 		break;
@@ -2134,7 +2134,7 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 
 	case CS_BIDIR_RD_UNDERRUN:
 		ql_dbg(ql_dbg_user, vha, 0x70b6,
-		    "Command completed with read data data underrun "
+		    "Command completed with read data underrun "
 		    "thread_id=%d\n", thread_id);
 		rval = EXT_STATUS_DATA_UNDERRUN;
 		break;
-- 
2.12.0
