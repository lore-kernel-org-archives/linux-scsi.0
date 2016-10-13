From: james.smart@broadcom.com (James Smart)
Subject: [PATCH v3 01/17] Fix few small typos in lpfc_scsi.c
Date: Thu, 13 Oct 2016 15:06:02 -0700
Message-ID: <5800054a.CGSEAA82tuayHqLT%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bastion.smtp.avagotech.com ([202.86.248.61]:55290 "EHLO
        sgpsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757015AbcJMWQg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 18:16:36 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp1.avagotech.com (Postfix) with SMTP id 67728100742
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 15:06:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


From: "Milan P. Gandhi" <mgandhi@redhat.com>

This patch does a cleanup and fixes few small typos in lpfc_scsi.c

Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 
 drivers/scsi/lpfc/lpfc_scsi.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index d197aa1..ca56f28 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -607,7 +607,7 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_sli4_post_scsi_sgl_list - Psot blocks of scsi buffer sgls from a list
+ * lpfc_sli4_post_scsi_sgl_list - Post blocks of scsi buffer sgls from a list
  * @phba: pointer to lpfc hba data structure.
  * @post_sblist: pointer to the scsi buffer list.
  *
@@ -736,7 +736,7 @@ lpfc_sli4_post_scsi_sgl_list(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_sli4_repost_scsi_sgl_list - Repsot all the allocated scsi buffer sgls
+ * lpfc_sli4_repost_scsi_sgl_list - Repost all the allocated scsi buffer sgls
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine walks the list of scsi buffers that have been allocated and
@@ -857,7 +857,7 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int num_to_alloc)
 				psb->data, psb->dma_handle);
 			kfree(psb);
 			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
-					"3368 Failed to allocated IOTAG for"
+					"3368 Failed to allocate IOTAG for"
 					" XRI:0x%x\n", lxri);
 			lpfc_sli4_free_xri(phba, lxri);
 			break;
@@ -1136,7 +1136,7 @@ lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
  *
  * This routine does the pci dma mapping for scatter-gather list of scsi cmnd
  * field of @lpfc_cmd for device with SLI-3 interface spec. This routine scans
- * through sg elements and format the bdea. This routine also initializes all
+ * through sg elements and format the bde. This routine also initializes all
  * IOCB fields which are dependent on scsi command request buffer.
  *
  * Return codes:
@@ -1269,13 +1269,16 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 
-/* Return if if error injection is detected by Initiator */
+/* Return BG_ERR_INIT if error injection is detected by Initiator */
 #define BG_ERR_INIT	0x1
-/* Return if if error injection is detected by Target */
+/* Return BG_ERR_TGT if error injection is detected by Target */
 #define BG_ERR_TGT	0x2
-/* Return if if swapping CSUM<-->CRC is required for error injection */
+/* Return BG_ERR_SWAP if swapping CSUM<-->CRC is required for error injection */
 #define BG_ERR_SWAP	0x10
-/* Return if disabling Guard/Ref/App checking is required for error injection */
+/**
+ * Return BG_ERR_CHECK if disabling Guard/Ref/App checking is required for
+ * error injection
+ **/
 #define BG_ERR_CHECK	0x20
 
 /**
@@ -4822,7 +4825,7 @@ wait_for_cmpl:
 		ret = FAILED;
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 				 "0748 abort handler timed out waiting "
-				 "for abortng I/O (xri:x%x) to complete: "
+				 "for aborting I/O (xri:x%x) to complete: "
 				 "ret %#x, ID %d, LUN %llu\n",
 				 iocb->sli4_xritag, ret,
 				 cmnd->device->id, cmnd->device->lun);

