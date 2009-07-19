From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 7/8] lpfc 8.3.4: Remove spaces before newlines in several
	log messages
Date: Sun, 19 Jul 2009 10:01:38 -0400
Message-ID: <1248012098.15009.34.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:34700 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbZGSOBk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2009 10:01:40 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n6JE1eGd021605
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jul 2009 07:01:40 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Remove spaces before newlines in several log messages

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_hbadisc.c |    2 +-
 drivers/scsi/lpfc/lpfc_init.c    |   10 +++++-----
 drivers/scsi/lpfc/lpfc_mbox.c    |    2 +-
 drivers/scsi/lpfc/lpfc_scsi.c    |    6 +++---
 drivers/scsi/lpfc/lpfc_sli.c     |    4 ++--
 drivers/scsi/lpfc/lpfc_vport.c   |    2 +-
 6 files changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2402,7 +2402,7 @@ lpfc_create_static_vport(struct lpfc_hba *phba)
 		if (!new_fc_vport) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0546 lpfc_create_static_vport failed to"
-				" create vport \n");
+				" create vport\n");
 			continue;
 		}
 
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -580,7 +580,7 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 				KERN_ERR,
 				LOG_INIT,
 				"0456 Adapter failed to issue "
-				"ASYNCEVT_ENABLE mbox status x%x \n.",
+				"ASYNCEVT_ENABLE mbox status x%x\n",
 				rc);
 		mempool_free(pmb, phba->mbox_mem_pool);
 	}
@@ -594,7 +594,7 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 
 	if ((rc != MBX_BUSY) && (rc != MBX_SUCCESS)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT, "0435 Adapter failed "
-				"to get Option ROM version status x%x\n.", rc);
+				"to get Option ROM version status x%x\n", rc);
 		mempool_free(pmb, phba->mbox_mem_pool);
 	}
 
@@ -2923,7 +2923,7 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba *phba,
 	switch (event_type) {
 	case LPFC_FCOE_EVENT_TYPE_NEW_FCF:
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
-			"2546 New FCF found index 0x%x tag 0x%x \n",
+			"2546 New FCF found index 0x%x tag 0x%x\n",
 			acqe_fcoe->fcf_index,
 			acqe_fcoe->event_tag);
 		/*
@@ -2949,7 +2949,7 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba *phba,
 
 	case LPFC_FCOE_EVENT_TYPE_FCF_TABLE_FULL:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-			"2548 FCF Table full count 0x%x tag 0x%x \n",
+			"2548 FCF Table full count 0x%x tag 0x%x\n",
 			bf_get(lpfc_acqe_fcoe_fcf_count, acqe_fcoe),
 			acqe_fcoe->event_tag);
 		break;
@@ -2957,7 +2957,7 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba *phba,
 	case LPFC_FCOE_EVENT_TYPE_FCF_DEAD:
 		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
 			"2549 FCF disconnected fron network index 0x%x"
-			" tag 0x%x \n", acqe_fcoe->fcf_index,
+			" tag 0x%x\n", acqe_fcoe->fcf_index,
 			acqe_fcoe->event_tag);
 		/* If the event is not for currently used fcf do nothing */
 		if (phba->fcf.fcf_indx != acqe_fcoe->fcf_index)
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1893,7 +1893,7 @@ lpfc_dump_fcoe_param(struct lpfc_hba *phba,
 		/* dump_fcoe_param failed to allocate memory */
 		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
 			"2569 lpfc_dump_fcoe_param: memory"
-			" allocation failed \n");
+			" allocation failed\n");
 		return 1;
 	}
 
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2142,7 +2142,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 	} else if (resp_info & RESID_OVER) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 				 "9028 FCP command x%x residual overrun error. "
-				 "Data: x%x x%x \n", cmnd->cmnd[0],
+				 "Data: x%x x%x\n", cmnd->cmnd[0],
 				 scsi_bufflen(cmnd), scsi_get_resid(cmnd));
 		host_status = DID_ERROR;
 
@@ -2843,7 +2843,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 				dif_op_str[scsi_get_prot_op(cmnd)]);
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
 				"9034 BLKGRD: CDB: %02x %02x %02x %02x %02x "
-				"%02x %02x %02x %02x %02x \n",
+				"%02x %02x %02x %02x %02x\n",
 				cmnd->cmnd[0], cmnd->cmnd[1], cmnd->cmnd[2],
 				cmnd->cmnd[3], cmnd->cmnd[4], cmnd->cmnd[5],
 				cmnd->cmnd[6], cmnd->cmnd[7], cmnd->cmnd[8],
@@ -2871,7 +2871,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 				dif_op_str[scsi_get_prot_op(cmnd)]);
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
 				 "9039 BLKGRD: CDB: %02x %02x %02x %02x %02x "
-				 "%02x %02x %02x %02x %02x \n",
+				 "%02x %02x %02x %02x %02x\n",
 				 cmnd->cmnd[0], cmnd->cmnd[1], cmnd->cmnd[2],
 				 cmnd->cmnd[3], cmnd->cmnd[4], cmnd->cmnd[5],
 				 cmnd->cmnd[6], cmnd->cmnd[7], cmnd->cmnd[8],
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4304,7 +4304,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	 */
 	if (lpfc_sli4_read_fcoe_params(phba, mboxq))
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_INIT,
-			"2570 Failed to read FCoE parameters \n");
+			"2570 Failed to read FCoE parameters\n");
 
 	/* Issue READ_REV to collect vpd and FW information. */
 	vpd_size = PAGE_SIZE;
@@ -6326,7 +6326,7 @@ lpfc_sli_async_event_handler(struct lpfc_hba * phba,
 			KERN_ERR,
 			LOG_SLI,
 			"0346 Ring %d handler: unexpected ASYNC_STATUS"
-			" evt_code 0x%x \n"
+			" evt_code 0x%x\n"
 			"W0  0x%08x W1  0x%08x W2  0x%08x W3  0x%08x\n"
 			"W4  0x%08x W5  0x%08x W6  0x%08x W7  0x%08x\n"
 			"W8  0x%08x W9  0x%08x W10 0x%08x W11 0x%08x\n"
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -668,7 +668,7 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 				lpfc_printf_log(vport->phba, KERN_WARNING,
 						LOG_VPORT,
 						"1829 CT command failed to "
-						"delete objects on fabric. \n");
+						"delete objects on fabric\n");
 		}
 		/* First look for the Fabric ndlp */
 		ndlp = lpfc_findnode_did(vport, Fabric_DID);


