From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: mpt3sas: fix some spelling mistakes in message and comments
Date: Mon, 31 Oct 2016 09:34:46 -0600
Message-ID: <20161031153446.18846-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:36105 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944124AbcJaPev (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2016 11:34:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trival fixes, minor spelling mistakes in comments and in a KERN_INFO
message.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 981be7b..4f28963 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -423,7 +423,7 @@ _scsih_get_sas_address(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		return 0;
 	}
 
-	/* we hit this becuase the given parent handle doesn't exist */
+	/* we hit this because the given parent handle doesn't exist */
 	if (ioc_status == MPI2_IOCSTATUS_CONFIG_INVALID_PAGE)
 		return -ENXIO;
 
@@ -1523,7 +1523,7 @@ _scsih_display_sata_capabilities(struct MPT3SAS_ADAPTER *ioc,
 /*
  * raid transport support -
  * Enabled for SLES11 and newer, in older kernels the driver will panic when
- * unloading the driver followed by a load - I beleive that the subroutine
+ * unloading the driver followed by a load - I believe that the subroutine
  * raid_class_release() is not cleaning up properly.
  */
 
@@ -2948,7 +2948,7 @@ _scsih_ublock_io_device(struct MPT3SAS_ADAPTER *ioc, u64 sas_address)
  * @ioc: per adapter object
  * @handle: device handle
  *
- * During device pull we need to appropiately set the sdev state.
+ * During device pull we need to appropriately set the sdev state.
  */
 static void
 _scsih_block_io_all_device(struct MPT3SAS_ADAPTER *ioc)
@@ -2977,7 +2977,7 @@ _scsih_block_io_all_device(struct MPT3SAS_ADAPTER *ioc)
  * @ioc: per adapter object
  * @handle: device handle
  *
- * During device pull we need to appropiately set the sdev state.
+ * During device pull we need to appropriately set the sdev state.
  */
 static void
 _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
@@ -3936,7 +3936,7 @@ _scsih_flush_running_cmds(struct MPT3SAS_ADAPTER *ioc)
  * _scsih_setup_eedp - setup MPI request for EEDP transfer
  * @ioc: per adapter object
  * @scmd: pointer to scsi command object
- * @mpi_request: pointer to the SCSI_IO reqest message frame
+ * @mpi_request: pointer to the SCSI_IO request message frame
  *
  * Supporting protection 1 and 3.
  *
@@ -4088,7 +4088,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		return 0;
-	/* device busy with task managment */
+	/* device busy with task management */
 	} else if (sas_target_priv_data->tm_busy ||
 	    sas_device_priv_data->block)
 		return SCSI_MLQUEUE_DEVICE_BUSY;
@@ -6327,7 +6327,7 @@ _scsih_reprobe_lun(struct scsi_device *sdev, void *no_uld_attach)
 {
 	sdev->no_uld_attach = no_uld_attach ? 1 : 0;
 	sdev_printk(KERN_INFO, sdev, "%s raid component\n",
-	    sdev->no_uld_attach ? "hidding" : "exposing");
+	    sdev->no_uld_attach ? "hiding" : "exposing");
 	WARN_ON(scsi_device_reprobe(sdev));
 }
 
@@ -9217,7 +9217,7 @@ scsih_init(void)
 	 /* queuecommand callback hander */
 	scsi_io_cb_idx = mpt3sas_base_register_callback_handler(_scsih_io_done);
 
-	/* task managment callback handler */
+	/* task management callback handler */
 	tm_cb_idx = mpt3sas_base_register_callback_handler(_scsih_tm_done);
 
 	/* base internal commands callback handler */
-- 
2.9.3

