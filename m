From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] scsi: Fix typo in scsi
Date: Wed, 25 Apr 2012 00:24:16 +0900
Message-ID: <1335281056-18329-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:42690 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab2DXPYY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Apr 2012 11:24:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, trivial@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>

Correct spelling typo within drivers/scsi

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c            |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c              |    4 ++--
 drivers/scsi/isci/host.c                       |    2 +-
 drivers/scsi/isci/port.c                       |    2 +-
 drivers/scsi/mvumi.c                           |    6 +++---
 drivers/scsi/qla4xxx/ql4_os.c                  |    6 +++---
 drivers/scsi/vmw_pvscsi.c                      |    4 ++--
 drivers/target/iscsi/iscsi_target_parameters.c |    4 ++--
 8 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 25417d0..0bcacf7 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -2888,7 +2888,7 @@ ahd_handle_lqiphase_error(struct ahd_softc *ahd, u_int lqistat1)
 		ahd_outb(ahd, CLRINT, CLRSCSIINT);
 		ahd_unpause(ahd);
 	} else {
-		printk("Reseting Channel for LQI Phase error\n");
+		printk("Resetting Channel for LQI Phase error\n");
 		ahd_dump_card_state(ahd);
 		ahd_reset_channel(ahd, 'A', /*Initiate Reset*/TRUE);
 	}
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index c1c6a92..5f988b4 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -864,7 +864,7 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event,
 		return;
 
 	default:
-		printk(KERN_ERR PFX "Unkonwn netevent %ld", event);
+		printk(KERN_ERR PFX "Unknown netevent %ld", event);
 		return;
 	}
 
@@ -1632,7 +1632,7 @@ static void bnx2fc_unbind_pcidev(struct bnx2fc_hba *hba)
 /**
  * bnx2fc_ulp_start - cnic callback to initialize & start adapter instance
  *
- * @handle:	transport handle pointing to adapter struture
+ * @handle:	transport handle pointing to adapter structure
  *
  * This function maps adapter structure to pcidev structure and initiates
  *	firmware handshake to enable/initialize on-chip FCoE components.
diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index bc8981e..7b48785 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -492,7 +492,7 @@ static void sci_controller_process_completions(struct isci_host *ihost)
 	u32 event_cycle;
 
 	dev_dbg(&ihost->pdev->dev,
-		"%s: completion queue begining get:0x%08x\n",
+		"%s: completion queue beginning get:0x%08x\n",
 		__func__,
 		ihost->completion_queue_get);
 
diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 2fb85bf..13098b0 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -212,7 +212,7 @@ static void isci_port_link_up(struct isci_host *isci_host,
 		memcpy(iphy->sas_phy.attached_sas_addr,
 		       iphy->frame_rcvd.iaf.sas_addr, SAS_ADDR_SIZE);
 	} else {
-		dev_err(&isci_host->pdev->dev, "%s: unkown target\n", __func__);
+		dev_err(&isci_host->pdev->dev, "%s: unknown target\n", __func__);
 		success = false;
 	}
 
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 88cf1db..783edc7 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -122,7 +122,7 @@ static struct mvumi_res *mvumi_alloc_mem_resource(struct mvumi_hba *mhba,
 
 	if (!res) {
 		dev_err(&mhba->pdev->dev,
-			"Failed to allocate memory for resouce manager.\n");
+			"Failed to allocate memory for resource manager.\n");
 		return NULL;
 	}
 
@@ -1007,13 +1007,13 @@ static int mvumi_handshake(struct mvumi_hba *mhba)
 		tmp |= INT_MAP_COMAOUT | INT_MAP_COMAERR;
 		iowrite32(tmp, regs + CPU_ENPOINTA_MASK_REG);
 		iowrite32(mhba->list_num_io, mhba->ib_shadow);
-		/* Set InBound List Avaliable count shadow */
+		/* Set InBound List Available count shadow */
 		iowrite32(lower_32_bits(mhba->ib_shadow_phys),
 					regs + CLA_INB_AVAL_COUNT_BASEL);
 		iowrite32(upper_32_bits(mhba->ib_shadow_phys),
 					regs + CLA_INB_AVAL_COUNT_BASEH);
 
-		/* Set OutBound List Avaliable count shadow */
+		/* Set OutBound List Available count shadow */
 		iowrite32((mhba->list_num_io-1) | CL_POINTER_TOGGLE,
 						mhba->ob_shadow);
 		iowrite32(lower_32_bits(mhba->ob_shadow_phys), regs + 0x5B0);
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ee47820..9f372aa 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -778,7 +778,7 @@ static void qla4xxx_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 				     iscsi_stats_dma);
 	if (ret != QLA_SUCCESS) {
 		ql4_printk(KERN_ERR, ha,
-			   "Unable to retreive iscsi stats\n");
+			   "Unable to retrieve iscsi stats\n");
 		goto free_stats;
 	}
 
@@ -4268,7 +4268,7 @@ static int qla4xxx_compare_tuple_ddb(struct scsi_qla_host *ha,
 		return QLA_ERROR;
 
 	/* For multi sessions, driver generates the ISID, so do not compare
-	 * ISID in reset path since it would be a comparision between the
+	 * ISID in reset path since it would be a comparison between the
 	 * driver generated ISID and firmware generated ISID. This could
 	 * lead to adding duplicated DDBs in the list as driver generated
 	 * ISID would not match firmware generated ISID.
@@ -5130,7 +5130,7 @@ static void qla4xxx_destroy_fw_ddb_session(struct scsi_qla_host *ha)
 	}
 }
 /**
- * qla4xxx_remove_adapter - calback function to remove adapter.
+ * qla4xxx_remove_adapter - callback function to remove adapter.
  * @pci_dev: PCI device pointer
  **/
 static void __devexit qla4xxx_remove_adapter(struct pci_dev *pdev)
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 4411d42..20b3a48 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -295,7 +295,7 @@ static void ll_adapter_reset(const struct pvscsi_adapter *adapter)
 
 static void ll_bus_reset(const struct pvscsi_adapter *adapter)
 {
-	dev_dbg(pvscsi_dev(adapter), "Reseting bus on %p\n", adapter);
+	dev_dbg(pvscsi_dev(adapter), "Resetting bus on %p\n", adapter);
 
 	pvscsi_write_cmd_desc(adapter, PVSCSI_CMD_RESET_BUS, NULL, 0);
 }
@@ -304,7 +304,7 @@ static void ll_device_reset(const struct pvscsi_adapter *adapter, u32 target)
 {
 	struct PVSCSICmdDescResetDevice cmd = { 0 };
 
-	dev_dbg(pvscsi_dev(adapter), "Reseting device: target=%u\n", target);
+	dev_dbg(pvscsi_dev(adapter), "Resetting device: target=%u\n", target);
 
 	cmd.target = target;
 
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index ad3b3c1..377378e 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -662,7 +662,7 @@ int iscsi_extract_key_value(char *textbuf, char **key, char **value)
 {
 	*value = strchr(textbuf, '=');
 	if (!*value) {
-		pr_err("Unable to locate \"=\" seperator for key,"
+		pr_err("Unable to locate \"=\" separator for key,"
 				" ignoring request.\n");
 		return -1;
 	}
@@ -1278,7 +1278,7 @@ static int iscsi_check_value(struct iscsi_param *param, char *value)
 		comma_ptr = strchr(value, ',');
 
 		if (comma_ptr && !IS_TYPE_VALUE_LIST(param)) {
-			pr_err("Detected value seperator \",\", but"
+			pr_err("Detected value separator \",\", but"
 				" key \"%s\" does not allow a value list,"
 				" protocol error.\n", param->name);
 			return -1;
-- 
1.7.10.207.g0bb2e

