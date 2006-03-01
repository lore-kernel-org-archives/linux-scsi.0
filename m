From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 1/22] lpfc 8.1.2: Remove unused prototypes from lpfc_crtn.h
Date: Tue, 28 Feb 2006 19:25:11 -0500
Message-ID: <20060301002511.GA15346@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:40870 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S932735AbWCAAZM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:12 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PB6D015352
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:11 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PBNw015351
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:11 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove unused prototypes from lpfc_crtn.h

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -42,9 +42,6 @@ void lpfc_mbx_cmpl_reg_login(struct lpfc
 void lpfc_mbx_cmpl_fabric_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
-int lpfc_nlp_plogi(struct lpfc_hba *, struct lpfc_nodelist *);
-int lpfc_nlp_adisc(struct lpfc_hba *, struct lpfc_nodelist *);
-int lpfc_nlp_unmapped(struct lpfc_hba *, struct lpfc_nodelist *);
 int lpfc_nlp_list(struct lpfc_hba *, struct lpfc_nodelist *, int);
 void lpfc_set_disctmo(struct lpfc_hba *);
 int lpfc_can_disctmo(struct lpfc_hba *);
@@ -54,12 +51,10 @@ int lpfc_check_sli_ndlp(struct lpfc_hba 
 int lpfc_nlp_remove(struct lpfc_hba *, struct lpfc_nodelist *);
 void lpfc_nlp_init(struct lpfc_hba *, struct lpfc_nodelist *, uint32_t);
 struct lpfc_nodelist *lpfc_setup_disc_node(struct lpfc_hba *, uint32_t);
-struct lpfc_nodelist *lpfc_setup_rscn_node(struct lpfc_hba *, uint32_t);
 void lpfc_disc_list_loopmap(struct lpfc_hba *);
 void lpfc_disc_start(struct lpfc_hba *);
 void lpfc_disc_flush_list(struct lpfc_hba *);
 void lpfc_disc_timeout(unsigned long);
-void lpfc_scan_timeout(unsigned long);
 
 struct lpfc_nodelist *lpfc_findnode_rpi(struct lpfc_hba * phba, uint16_t rpi);
 
@@ -68,12 +63,6 @@ int lpfc_do_work(void *);
 int lpfc_disc_state_machine(struct lpfc_hba *, struct lpfc_nodelist *, void *,
 			    uint32_t);
 
-uint32_t lpfc_cmpl_prli_reglogin_issue(struct lpfc_hba *,
-				       struct lpfc_nodelist *, void *,
-				       uint32_t);
-uint32_t lpfc_cmpl_plogi_prli_issue(struct lpfc_hba *, struct lpfc_nodelist *,
-				    void *, uint32_t);
-
 int lpfc_check_sparm(struct lpfc_hba *, struct lpfc_nodelist *,
 		     struct serv_parm *, uint32_t);
 int lpfc_els_abort(struct lpfc_hba *, struct lpfc_nodelist * ndlp,
@@ -120,15 +109,11 @@ int lpfc_hba_down_prep(struct lpfc_hba *
 void lpfc_hba_init(struct lpfc_hba *, uint32_t *);
 int lpfc_post_buffer(struct lpfc_hba *, struct lpfc_sli_ring *, int, int);
 void lpfc_decode_firmware_rev(struct lpfc_hba *, char *, int);
-uint8_t *lpfc_get_lpfchba_info(struct lpfc_hba *, uint8_t *);
-int lpfc_fcp_abort(struct lpfc_hba *, int, int, int);
 int lpfc_online(struct lpfc_hba *);
 int lpfc_offline(struct lpfc_hba *);
 
-
 int lpfc_sli_setup(struct lpfc_hba *);
 int lpfc_sli_queue_setup(struct lpfc_hba *);
-void lpfc_slim_access(struct lpfc_hba *);
 
 void lpfc_handle_eratt(struct lpfc_hba *);
 void lpfc_handle_latt(struct lpfc_hba *);
@@ -174,9 +159,6 @@ int lpfc_sli_abort_iocb(struct lpfc_hba 
 
 void lpfc_mbox_timeout(unsigned long);
 void lpfc_mbox_timeout_handler(struct lpfc_hba *);
-void lpfc_map_fcp_cmnd_to_bpl(struct lpfc_hba *, struct lpfc_scsi_buf *);
-void lpfc_free_scsi_cmd(struct lpfc_scsi_buf *);
-uint32_t lpfc_os_timeout_transform(struct lpfc_hba *, uint32_t);
 
 struct lpfc_nodelist *lpfc_findnode_did(struct lpfc_hba * phba, uint32_t order,
 					uint32_t did);
