From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [PATCH] ipr: trivial: fix small coding style issues
Date: Wed, 22 Aug 2012 18:14:14 -0300
Message-ID: <1345670054-6757-1-git-send-email-klebers@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bb40dc42.virtua.com.br ([187.64.220.66]:55319 "EHLO
	oc3035817862.ibm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752648Ab2HVVXt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Aug 2012 17:23:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jiri Kosina <trivial@kernel.org>, Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

Fixing small trivial coding style issues.

Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c |   66 ++++++++++++++++++++++++++--------------------------
 1 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 07b14ba..47ac4f4 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -192,7 +192,7 @@ static const struct ipr_chip_t ipr_chip[] = {
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CROCODILE, IPR_USE_MSI, IPR_SIS64, IPR_MMIO, &ipr_chip_cfg[2] }
 };
 
-static int ipr_max_bus_speeds [] = {
+static int ipr_max_bus_speeds[] = {
 	IPR_80MBs_SCSI_RATE, IPR_U160_SCSI_RATE, IPR_U320_SCSI_RATE
 };
 
@@ -562,7 +562,7 @@ static void ipr_trc_hook(struct ipr_cmnd *ipr_cmd,
 	trace_entry->u.add_data = add_data;
 }
 #else
-#define ipr_trc_hook(ipr_cmd, type, add_data) do { } while(0)
+#define ipr_trc_hook(ipr_cmd, type, add_data) do { } while (0)
 #endif
 
 /**
@@ -1035,7 +1035,7 @@ static void ipr_send_hcam(struct ipr_ioa_cfg *ioa_cfg, u8 type,
  **/
 static void ipr_update_ata_class(struct ipr_resource_entry *res, unsigned int proto)
 {
-	switch(proto) {
+	switch (proto) {
 	case IPR_PROTO_SATA:
 	case IPR_PROTO_SAS_STP:
 		res->ata_class = ATA_DEV_ATA;
@@ -3076,7 +3076,7 @@ static void ipr_get_ioa_dump(struct ipr_ioa_cfg *ioa_cfg, struct ipr_dump *dump)
 }
 
 #else
-#define ipr_get_ioa_dump(ioa_cfg, dump) do { } while(0)
+#define ipr_get_ioa_dump(ioa_cfg, dump) do { } while (0)
 #endif
 
 /**
@@ -3088,7 +3088,7 @@ static void ipr_get_ioa_dump(struct ipr_ioa_cfg *ioa_cfg, struct ipr_dump *dump)
  **/
 static void ipr_release_dump(struct kref *kref)
 {
-	struct ipr_dump *dump = container_of(kref,struct ipr_dump,kref);
+	struct ipr_dump *dump = container_of(kref, struct ipr_dump, kref);
 	struct ipr_ioa_cfg *ioa_cfg = dump->ioa_cfg;
 	unsigned long lock_flags = 0;
 	int i;
@@ -3175,7 +3175,7 @@ restart:
 				break;
 			}
 		}
-	} while(did_work);
+	} while (did_work);
 
 	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
 		if (res->add_to_ml) {
@@ -3301,7 +3301,7 @@ static ssize_t ipr_show_log_level(struct device *dev,
  * 	number of bytes printed to buffer
  **/
 static ssize_t ipr_store_log_level(struct device *dev,
-			           struct device_attribute *attr,
+				   struct device_attribute *attr,
 				   const char *buf, size_t count)
 {
 	struct Scsi_Host *shost = class_to_shost(dev);
@@ -3348,7 +3348,7 @@ static ssize_t ipr_store_diagnostics(struct device *dev,
 		return -EACCES;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	while(ioa_cfg->in_reset_reload) {
+	while (ioa_cfg->in_reset_reload) {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
@@ -3715,7 +3715,7 @@ static int ipr_update_ioa_ucode(struct ipr_ioa_cfg *ioa_cfg,
 	unsigned long lock_flags;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	while(ioa_cfg->in_reset_reload) {
+	while (ioa_cfg->in_reset_reload) {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
@@ -3779,7 +3779,7 @@ static ssize_t ipr_store_update_fw(struct device *dev,
 	len = snprintf(fname, 99, "%s", buf);
 	fname[len-1] = '\0';
 
-	if(request_firmware(&fw_entry, fname, &ioa_cfg->pdev->dev)) {
+	if (request_firmware(&fw_entry, fname, &ioa_cfg->pdev->dev)) {
 		dev_err(&ioa_cfg->pdev->dev, "Firmware file %s not found\n", fname);
 		return -EIO;
 	}
@@ -4645,7 +4645,7 @@ static int ipr_slave_alloc(struct scsi_device *sdev)
  * Return value:
  * 	SUCCESS / FAILED
  **/
-static int __ipr_eh_host_reset(struct scsi_cmnd * scsi_cmd)
+static int __ipr_eh_host_reset(struct scsi_cmnd *scsi_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg;
 	int rc;
@@ -4667,7 +4667,7 @@ static int __ipr_eh_host_reset(struct scsi_cmnd * scsi_cmd)
 	return rc;
 }
 
-static int ipr_eh_host_reset(struct scsi_cmnd * cmd)
+static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
 {
 	int rc;
 
@@ -4734,7 +4734,7 @@ static int ipr_device_reset(struct ipr_ioa_cfg *ioa_cfg,
 	}
 
 	LEAVE;
-	return (IPR_IOASC_SENSE_KEY(ioasc) ? -EIO : 0);
+	return IPR_IOASC_SENSE_KEY(ioasc) ? -EIO : 0;
 }
 
 /**
@@ -4758,7 +4758,7 @@ static int ipr_sata_reset(struct ata_link *link, unsigned int *classes,
 
 	ENTER;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	while(ioa_cfg->in_reset_reload) {
+	while (ioa_cfg->in_reset_reload) {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
@@ -4786,7 +4786,7 @@ static int ipr_sata_reset(struct ata_link *link, unsigned int *classes,
  * Return value:
  *	SUCCESS / FAILED
  **/
-static int __ipr_eh_dev_reset(struct scsi_cmnd * scsi_cmd)
+static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
 {
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioa_cfg *ioa_cfg;
@@ -4844,10 +4844,10 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd * scsi_cmd)
 	res->resetting_device = 0;
 
 	LEAVE;
-	return (rc ? FAILED : SUCCESS);
+	return rc ? FAILED : SUCCESS;
 }
 
-static int ipr_eh_dev_reset(struct scsi_cmnd * cmd)
+static int ipr_eh_dev_reset(struct scsi_cmnd *cmd)
 {
 	int rc;
 
@@ -4943,7 +4943,7 @@ static void ipr_abort_timeout(struct ipr_cmnd *ipr_cmd)
  * Return value:
  *	SUCCESS / FAILED
  **/
-static int ipr_cancel_op(struct scsi_cmnd * scsi_cmd)
+static int ipr_cancel_op(struct scsi_cmnd *scsi_cmd)
 {
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioa_cfg *ioa_cfg;
@@ -5012,7 +5012,7 @@ static int ipr_cancel_op(struct scsi_cmnd * scsi_cmd)
 		res->needs_sync_complete = 1;
 
 	LEAVE;
-	return (IPR_IOASC_SENSE_KEY(ioasc) ? FAILED : SUCCESS);
+	return IPR_IOASC_SENSE_KEY(ioasc) ? FAILED : SUCCESS;
 }
 
 /**
@@ -5022,7 +5022,7 @@ static int ipr_cancel_op(struct scsi_cmnd * scsi_cmd)
  * Return value:
  * 	SUCCESS / FAILED
  **/
-static int ipr_eh_abort(struct scsi_cmnd * scsi_cmd)
+static int ipr_eh_abort(struct scsi_cmnd *scsi_cmd)
 {
 	unsigned long flags;
 	int rc;
@@ -5975,7 +5975,7 @@ static int ipr_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
  * Return value:
  * 	pointer to buffer with description string
  **/
-static const char * ipr_ioa_info(struct Scsi_Host *host)
+static const char *ipr_ioa_info(struct Scsi_Host *host)
 {
 	static char buffer[512];
 	struct ipr_ioa_cfg *ioa_cfg;
@@ -6033,7 +6033,7 @@ static void ipr_ata_phy_reset(struct ata_port *ap)
 
 	ENTER;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
-	while(ioa_cfg->in_reset_reload) {
+	while (ioa_cfg->in_reset_reload) {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
 		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
@@ -6073,7 +6073,7 @@ static void ipr_ata_post_internal(struct ata_queued_cmd *qc)
 	unsigned long flags;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
-	while(ioa_cfg->in_reset_reload) {
+	while (ioa_cfg->in_reset_reload) {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
 		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 		spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
@@ -6398,7 +6398,7 @@ static int ipr_invalid_adapter(struct ipr_ioa_cfg *ioa_cfg)
 	int i;
 
 	if ((ioa_cfg->type == 0x5702) && (ioa_cfg->pdev->revision < 4)) {
-		for (i = 0; i < ARRAY_SIZE(ipr_blocked_processors); i++){
+		for (i = 0; i < ARRAY_SIZE(ipr_blocked_processors); i++) {
 			if (__is_processor(ipr_blocked_processors[i]))
 				return 1;
 		}
@@ -6676,7 +6676,7 @@ static void ipr_scsi_bus_speed_limit(struct ipr_ioa_cfg *ioa_cfg)
  * 	none
  **/
 static void ipr_modify_ioafp_mode_page_28(struct ipr_ioa_cfg *ioa_cfg,
-					  	struct ipr_mode_pages *mode_pages)
+					  struct ipr_mode_pages *mode_pages)
 {
 	int i, entry_length;
 	struct ipr_dev_bus_entry *bus;
@@ -8090,7 +8090,7 @@ static void ipr_reset_ioa_job(struct ipr_cmnd *ipr_cmd)
 		ipr_reinit_ipr_cmnd(ipr_cmd);
 		ipr_cmd->job_step_failed = ipr_reset_cmd_failed;
 		rc = ipr_cmd->job_step(ipr_cmd);
-	} while(rc == IPR_RC_JOB_CONTINUE);
+	} while (rc == IPR_RC_JOB_CONTINUE);
 }
 
 /**
@@ -8351,7 +8351,7 @@ static void ipr_free_cmd_blks(struct ipr_ioa_cfg *ioa_cfg)
 	}
 
 	if (ioa_cfg->ipr_cmd_pool)
-		pci_pool_destroy (ioa_cfg->ipr_cmd_pool);
+		pci_pool_destroy(ioa_cfg->ipr_cmd_pool);
 
 	kfree(ioa_cfg->ipr_cmnd_list);
 	kfree(ioa_cfg->ipr_cmnd_list_dma);
@@ -8431,8 +8431,8 @@ static int __devinit ipr_alloc_cmd_blks(struct ipr_ioa_cfg *ioa_cfg)
 	dma_addr_t dma_addr;
 	int i;
 
-	ioa_cfg->ipr_cmd_pool = pci_pool_create (IPR_NAME, ioa_cfg->pdev,
-						 sizeof(struct ipr_cmnd), 512, 0);
+	ioa_cfg->ipr_cmd_pool = pci_pool_create(IPR_NAME, ioa_cfg->pdev,
+						sizeof(struct ipr_cmnd), 512, 0);
 
 	if (!ioa_cfg->ipr_cmd_pool)
 		return -ENOMEM;
@@ -8446,7 +8446,7 @@ static int __devinit ipr_alloc_cmd_blks(struct ipr_ioa_cfg *ioa_cfg)
 	}
 
 	for (i = 0; i < IPR_NUM_CMD_BLKS; i++) {
-		ipr_cmd = pci_pool_alloc (ioa_cfg->ipr_cmd_pool, GFP_KERNEL, &dma_addr);
+		ipr_cmd = pci_pool_alloc(ioa_cfg->ipr_cmd_pool, GFP_KERNEL, &dma_addr);
 
 		if (!ipr_cmd) {
 			ipr_free_cmd_blks(ioa_cfg);
@@ -9031,7 +9031,7 @@ static void ipr_scan_vsets(struct ipr_ioa_cfg *ioa_cfg)
 	int target, lun;
 
 	for (target = 0; target < IPR_MAX_NUM_TARGETS_PER_BUS; target++)
-		for (lun = 0; lun < IPR_MAX_NUM_VSET_LUNS_PER_TARGET; lun++ )
+		for (lun = 0; lun < IPR_MAX_NUM_VSET_LUNS_PER_TARGET; lun++)
 			scsi_add_device(ioa_cfg->host, IPR_VSET_BUS, target, lun);
 }
 
@@ -9077,7 +9077,7 @@ static void __ipr_remove(struct pci_dev *pdev)
 	ENTER;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
-	while(ioa_cfg->in_reset_reload) {
+	while (ioa_cfg->in_reset_reload) {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, host_lock_flags);
 		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 		spin_lock_irqsave(ioa_cfg->host->host_lock, host_lock_flags);
@@ -9206,7 +9206,7 @@ static void ipr_shutdown(struct pci_dev *pdev)
 	unsigned long lock_flags = 0;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-	while(ioa_cfg->in_reset_reload) {
+	while (ioa_cfg->in_reset_reload) {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 		wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
-- 
1.7.1

