From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 1/5] lpfc : Correct kdoc syntax errors in lpfc_els.c
Date: Tue, 16 Dec 2008 11:01:30 -0500
Message-ID: <1229443290.4621.16.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63256 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969AbYLPQAE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2008 11:00:04 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mBGG023d026146
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2008 08:00:02 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c |  178 ++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 89 insertions(+), 89 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2008-12-16 09:34:12.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2008-12-16 10:48:27.000000000 -0500
@@ -55,7 +55,7 @@ static void lpfc_register_new_vport(stru
 static int lpfc_max_els_tries = 3;
 
 /**
- * lpfc_els_chk_latt: Check host link attention event for a vport.
+ * lpfc_els_chk_latt - Check host link attention event for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine checks whether there is an outstanding host link
@@ -116,7 +116,7 @@ lpfc_els_chk_latt(struct lpfc_vport *vpo
 }
 
 /**
- * lpfc_prep_els_iocb: Allocate and prepare a lpfc iocb data structure.
+ * lpfc_prep_els_iocb - Allocate and prepare a lpfc iocb data structure
  * @vport: pointer to a host virtual N_Port data structure.
  * @expectRsp: flag indicating whether response is expected.
  * @cmdSize: size of the ELS command.
@@ -290,7 +290,7 @@ els_iocb_free_pcmb_exit:
 }
 
 /**
- * lpfc_issue_fabric_reglogin: Issue fabric registration login for a vport.
+ * lpfc_issue_fabric_reglogin - Issue fabric registration login for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine issues a fabric registration login for a @vport. An
@@ -386,7 +386,7 @@ fail:
 }
 
 /**
- * lpfc_cmpl_els_flogi_fabric: Completion function for flogi to a fabric port.
+ * lpfc_cmpl_els_flogi_fabric - Completion function for flogi to a fabric port
  * @vport: pointer to a host virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  * @sp: pointer to service parameter data structure.
@@ -509,7 +509,7 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 }
 
 /**
- * lpfc_cmpl_els_flogi_nport: Completion function for flogi to an N_Port.
+ * lpfc_cmpl_els_flogi_nport - Completion function for flogi to an N_Port
  * @vport: pointer to a host virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  * @sp: pointer to service parameter data structure.
@@ -626,7 +626,7 @@ fail:
 }
 
 /**
- * lpfc_cmpl_els_flogi: Completion callback function for flogi.
+ * lpfc_cmpl_els_flogi - Completion callback function for flogi
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -751,7 +751,7 @@ out:
 }
 
 /**
- * lpfc_issue_els_flogi: Issue an flogi iocb command for a vport.
+ * lpfc_issue_els_flogi - Issue an flogi iocb command for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  * @retry: number of retries to the command IOCB.
@@ -849,7 +849,7 @@ lpfc_issue_els_flogi(struct lpfc_vport *
 }
 
 /**
- * lpfc_els_abort_flogi: Abort all outstanding flogi iocbs.
+ * lpfc_els_abort_flogi - Abort all outstanding flogi iocbs
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine aborts all the outstanding Fabric Login (FLOGI) IOCBs
@@ -898,7 +898,7 @@ lpfc_els_abort_flogi(struct lpfc_hba *ph
 }
 
 /**
- * lpfc_initial_flogi: Issue an initial fabric login for a vport.
+ * lpfc_initial_flogi - Issue an initial fabric login for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine issues an initial Fabric Login (FLOGI) for the @vport
@@ -949,7 +949,7 @@ lpfc_initial_flogi(struct lpfc_vport *vp
 }
 
 /**
- * lpfc_initial_fdisc: Issue an initial fabric discovery for a vport.
+ * lpfc_initial_fdisc - Issue an initial fabric discovery for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine issues an initial Fabric Discover (FDISC) for the @vport
@@ -998,7 +998,7 @@ lpfc_initial_fdisc(struct lpfc_vport *vp
 }
 
 /**
- * lpfc_more_plogi: Check and issue remaining plogis for a vport.
+ * lpfc_more_plogi - Check and issue remaining plogis for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine checks whether there are more remaining Port Logins
@@ -1031,7 +1031,7 @@ lpfc_more_plogi(struct lpfc_vport *vport
 }
 
 /**
- * lpfc_plogi_confirm_nport: Confirm pologi wwpn matches stored ndlp.
+ * lpfc_plogi_confirm_nport - Confirm pologi wwpn matches stored ndlp
  * @phba: pointer to lpfc hba data structure.
  * @prsp: pointer to response IOCB payload.
  * @ndlp: pointer to a node-list data structure.
@@ -1165,7 +1165,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba
 }
 
 /**
- * lpfc_end_rscn: Check and handle more rscn for a vport.
+ * lpfc_end_rscn - Check and handle more rscn for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine checks whether more Registration State Change
@@ -1197,7 +1197,7 @@ lpfc_end_rscn(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_cmpl_els_plogi: Completion callback function for plogi.
+ * lpfc_cmpl_els_plogi - Completion callback function for plogi
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -1322,7 +1322,7 @@ out:
 }
 
 /**
- * lpfc_issue_els_plogi: Issue an plogi iocb command for a vport.
+ * lpfc_issue_els_plogi - Issue an plogi iocb command for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  * @did: destination port identifier.
  * @retry: number of retries to the command IOCB.
@@ -1401,7 +1401,7 @@ lpfc_issue_els_plogi(struct lpfc_vport *
 }
 
 /**
- * lpfc_cmpl_els_prli: Completion callback function for prli.
+ * lpfc_cmpl_els_prli - Completion callback function for prli
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -1472,7 +1472,7 @@ out:
 }
 
 /**
- * lpfc_issue_els_prli: Issue a prli iocb command for a vport.
+ * lpfc_issue_els_prli - Issue a prli iocb command for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  * @retry: number of retries to the command IOCB.
@@ -1562,7 +1562,7 @@ lpfc_issue_els_prli(struct lpfc_vport *v
 }
 
 /**
- * lpfc_rscn_disc: Perform rscn discovery for a vport.
+ * lpfc_rscn_disc - Perform rscn discovery for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine performs Registration State Change Notification (RSCN)
@@ -1588,7 +1588,7 @@ lpfc_rscn_disc(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_adisc_done: Complete the adisc phase of discovery.
+ * lpfc_adisc_done - Complete the adisc phase of discovery
  * @vport: pointer to lpfc_vport hba data structure that finished all ADISCs.
  *
  * This function is called when the final ADISC is completed during discovery.
@@ -1639,7 +1639,7 @@ lpfc_adisc_done(struct lpfc_vport *vport
 }
 
 /**
- * lpfc_more_adisc: Issue more adisc as needed.
+ * lpfc_more_adisc - Issue more adisc as needed
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine determines whether there are more ndlps on a @vport
@@ -1672,7 +1672,7 @@ lpfc_more_adisc(struct lpfc_vport *vport
 }
 
 /**
- * lpfc_cmpl_els_adisc: Completion callback function for adisc.
+ * lpfc_cmpl_els_adisc - Completion callback function for adisc
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -1760,7 +1760,7 @@ out:
 }
 
 /**
- * lpfc_issue_els_adisc: Issue an address discover iocb to an node on a vport.
+ * lpfc_issue_els_adisc - Issue an address discover iocb to an node on a vport
  * @vport: pointer to a virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  * @retry: number of retries to the command IOCB.
@@ -1833,7 +1833,7 @@ lpfc_issue_els_adisc(struct lpfc_vport *
 }
 
 /**
- * lpfc_cmpl_els_logo: Completion callback function for logo.
+ * lpfc_cmpl_els_logo - Completion callback function for logo
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -1910,7 +1910,7 @@ out:
 }
 
 /**
- * lpfc_issue_els_logo: Issue a logo to an node on a vport.
+ * lpfc_issue_els_logo - Issue a logo to an node on a vport
  * @vport: pointer to a virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  * @retry: number of retries to the command IOCB.
@@ -1918,7 +1918,7 @@ out:
  * This routine constructs and issues an ELS Logout (LOGO) iocb command
  * to a remote node, referred by an @ndlp on a @vport. It constructs the
  * payload of the IOCB, properly sets up the @ndlp state, and invokes the
- * lpfc_sli_issue_iocb() routine to send out the LOGO ELS command.
+ * lpfc_sli_issue_iocb() routine to send out the LOGO ELS command
  *
  * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
  * will be incremented by 1 for holding the ndlp and the reference to ndlp
@@ -1991,7 +1991,7 @@ lpfc_issue_els_logo(struct lpfc_vport *v
 }
 
 /**
- * lpfc_cmpl_els_cmd: Completion callback function for generic els command.
+ * lpfc_cmpl_els_cmd - Completion callback function for generic els command
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -2031,7 +2031,7 @@ lpfc_cmpl_els_cmd(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_issue_els_scr: Issue a scr to an node on a vport.
+ * lpfc_issue_els_scr - Issue a scr to an node on a vport
  * @vport: pointer to a host virtual N_Port data structure.
  * @nportid: N_Port identifier to the remote node.
  * @retry: number of retries to the command IOCB.
@@ -2125,7 +2125,7 @@ lpfc_issue_els_scr(struct lpfc_vport *vp
 }
 
 /**
- * lpfc_issue_els_farpr: Issue a farp to an node on a vport.
+ * lpfc_issue_els_farpr - Issue a farp to an node on a vport
  * @vport: pointer to a host virtual N_Port data structure.
  * @nportid: N_Port identifier to the remote node.
  * @retry: number of retries to the command IOCB.
@@ -2135,7 +2135,7 @@ lpfc_issue_els_scr(struct lpfc_vport *vp
  * is passed into the function. It first search the @vport node list to find
  * the matching ndlp. If no such ndlp is found, a new ndlp shall be created
  * for this (FARPR) purpose. An IOCB is allocated, payload prepared, and the
- * lpfc_sli_issue_iocb() routine is invoked to send the FARPR ELS command.
+ * lpfc_sli_issue_iocb() routine is invoked to send the FARPR ELS command
  *
  * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
  * will be incremented by 1 for holding the ndlp and the reference to ndlp
@@ -2236,7 +2236,7 @@ lpfc_issue_els_farpr(struct lpfc_vport *
 }
 
 /**
- * lpfc_cancel_retry_delay_tmo: Cancel the timer with delayed iocb-cmd retry.
+ * lpfc_cancel_retry_delay_tmo - Cancel the timer with delayed iocb-cmd retry
  * @vport: pointer to a host virtual N_Port data structure.
  * @nlp: pointer to a node-list data structure.
  *
@@ -2291,7 +2291,7 @@ lpfc_cancel_retry_delay_tmo(struct lpfc_
 }
 
 /**
- * lpfc_els_retry_delay: Timer function with a ndlp delayed function timer.
+ * lpfc_els_retry_delay - Timer function with a ndlp delayed function timer
  * @ptr: holder for the pointer to the timer function associated data (ndlp).
  *
  * This routine is invoked by the ndlp delayed-function timer to check
@@ -2333,7 +2333,7 @@ lpfc_els_retry_delay(unsigned long ptr)
 }
 
 /**
- * lpfc_els_retry_delay_handler: Work thread handler for ndlp delayed function.
+ * lpfc_els_retry_delay_handler - Work thread handler for ndlp delayed function
  * @ndlp: pointer to a node-list data structure.
  *
  * This routine is the worker-thread handler for processing the @ndlp delayed
@@ -2404,7 +2404,7 @@ lpfc_els_retry_delay_handler(struct lpfc
 }
 
 /**
- * lpfc_els_retry: Make retry decision on an els command iocb.
+ * lpfc_els_retry - Make retry decision on an els command iocb
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -2732,7 +2732,7 @@ lpfc_els_retry(struct lpfc_hba *phba, st
 }
 
 /**
- * lpfc_els_free_data: Free lpfc dma buffer and data structure with an iocb.
+ * lpfc_els_free_data - Free lpfc dma buffer and data structure with an iocb
  * @phba: pointer to lpfc hba data structure.
  * @buf_ptr1: pointer to the lpfc DMA buffer data structure.
  *
@@ -2764,7 +2764,7 @@ lpfc_els_free_data(struct lpfc_hba *phba
 }
 
 /**
- * lpfc_els_free_bpl: Free lpfc dma buffer and data structure with bpl.
+ * lpfc_els_free_bpl - Free lpfc dma buffer and data structure with bpl
  * @phba: pointer to lpfc hba data structure.
  * @buf_ptr: pointer to the lpfc dma buffer data structure.
  *
@@ -2784,7 +2784,7 @@ lpfc_els_free_bpl(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_els_free_iocb: Free a command iocb and its associated resources.
+ * lpfc_els_free_iocb - Free a command iocb and its associated resources
  * @phba: pointer to lpfc hba data structure.
  * @elsiocb: pointer to lpfc els command iocb data structure.
  *
@@ -2877,7 +2877,7 @@ lpfc_els_free_iocb(struct lpfc_hba *phba
 }
 
 /**
- * lpfc_cmpl_els_logo_acc: Completion callback function to logo acc response.
+ * lpfc_cmpl_els_logo_acc - Completion callback function to logo acc response
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -2931,7 +2931,7 @@ lpfc_cmpl_els_logo_acc(struct lpfc_hba *
 }
 
 /**
- * lpfc_mbx_cmpl_dflt_rpi: Completion callbk func for unreg dflt rpi mbox cmd.
+ * lpfc_mbx_cmpl_dflt_rpi - Completion callbk func for unreg dflt rpi mbox cmd
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -2965,7 +2965,7 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *
 }
 
 /**
- * lpfc_cmpl_els_rsp: Completion callback function for els response iocb cmd.
+ * lpfc_cmpl_els_rsp - Completion callback function for els response iocb cmd
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -3136,7 +3136,7 @@ out:
 }
 
 /**
- * lpfc_els_rsp_acc: Prepare and issue an acc response iocb command.
+ * lpfc_els_rsp_acc - Prepare and issue an acc response iocb command
  * @vport: pointer to a host virtual N_Port data structure.
  * @flag: the els command code to be accepted.
  * @oldiocb: pointer to the original lpfc command iocb data structure.
@@ -3275,7 +3275,7 @@ lpfc_els_rsp_acc(struct lpfc_vport *vpor
 }
 
 /**
- * lpfc_els_rsp_reject: Propare and issue a rjt response iocb command.
+ * lpfc_els_rsp_reject - Propare and issue a rjt response iocb command
  * @vport: pointer to a virtual N_Port data structure.
  * @rejectError:
  * @oldiocb: pointer to the original lpfc command iocb data structure.
@@ -3356,7 +3356,7 @@ lpfc_els_rsp_reject(struct lpfc_vport *v
 }
 
 /**
- * lpfc_els_rsp_adisc_acc: Prepare and issue acc response to adisc iocb cmd.
+ * lpfc_els_rsp_adisc_acc - Prepare and issue acc response to adisc iocb cmd
  * @vport: pointer to a virtual N_Port data structure.
  * @oldiocb: pointer to the original lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -3431,7 +3431,7 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport
 }
 
 /**
- * lpfc_els_rsp_prli_acc: Prepare and issue acc response to prli iocb cmd.
+ * lpfc_els_rsp_prli_acc - Prepare and issue acc response to prli iocb cmd
  * @vport: pointer to a virtual N_Port data structure.
  * @oldiocb: pointer to the original lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -3529,7 +3529,7 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport 
 }
 
 /**
- * lpfc_els_rsp_rnid_acc: Issue rnid acc response iocb command.
+ * lpfc_els_rsp_rnid_acc - Issue rnid acc response iocb command
  * @vport: pointer to a virtual N_Port data structure.
  * @format: rnid command format.
  * @oldiocb: pointer to the original lpfc command iocb data structure.
@@ -3635,7 +3635,7 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport 
 }
 
 /**
- * lpfc_els_disc_adisc: Issue remaining adisc iocbs to npr nodes of a vport.
+ * lpfc_els_disc_adisc - Issue remaining adisc iocbs to npr nodes of a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine issues Address Discover (ADISC) ELS commands to those
@@ -3693,7 +3693,7 @@ lpfc_els_disc_adisc(struct lpfc_vport *v
 }
 
 /**
- * lpfc_els_disc_plogi: Issue plogi for all npr nodes of a vport before adisc.
+ * lpfc_els_disc_plogi - Issue plogi for all npr nodes of a vport before adisc
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine issues Port Login (PLOGI) ELS commands to all the N_Ports
@@ -3752,7 +3752,7 @@ lpfc_els_disc_plogi(struct lpfc_vport *v
 }
 
 /**
- * lpfc_els_flush_rscn: Clean up any rscn activities with a vport.
+ * lpfc_els_flush_rscn - Clean up any rscn activities with a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine cleans up any Registration State Change Notification
@@ -3791,7 +3791,7 @@ lpfc_els_flush_rscn(struct lpfc_vport *v
 }
 
 /**
- * lpfc_rscn_payload_check: Check whether there is a pending rscn to a did.
+ * lpfc_rscn_payload_check - Check whether there is a pending rscn to a did
  * @vport: pointer to a host virtual N_Port data structure.
  * @did: remote destination port identifier.
  *
@@ -3866,7 +3866,7 @@ return_did_out:
 }
 
 /**
- * lpfc_rscn_recovery_check: Send recovery event to vport nodes matching rscn
+ * lpfc_rscn_recovery_check - Send recovery event to vport nodes matching rscn
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine sends recovery (NLP_EVT_DEVICE_RECOVERY) event to the
@@ -3895,7 +3895,7 @@ lpfc_rscn_recovery_check(struct lpfc_vpo
 }
 
 /**
- * lpfc_send_rscn_event: Send an RSCN event to management application.
+ * lpfc_send_rscn_event - Send an RSCN event to management application
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  *
@@ -3938,7 +3938,7 @@ lpfc_send_rscn_event(struct lpfc_vport *
 }
 
 /**
- * lpfc_els_rcv_rscn: Process an unsolicited rscn iocb.
+ * lpfc_els_rcv_rscn - Process an unsolicited rscn iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -4134,7 +4134,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 }
 
 /**
- * lpfc_els_handle_rscn: Handle rscn for a vport.
+ * lpfc_els_handle_rscn - Handle rscn for a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine handles the Registration State Configuration Notification
@@ -4222,7 +4222,7 @@ lpfc_els_handle_rscn(struct lpfc_vport *
 }
 
 /**
- * lpfc_els_rcv_flogi: Process an unsolicited flogi iocb.
+ * lpfc_els_rcv_flogi - Process an unsolicited flogi iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -4336,7 +4336,7 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vp
 }
 
 /**
- * lpfc_els_rcv_rnid: Process an unsolicited rnid iocb.
+ * lpfc_els_rcv_rnid - Process an unsolicited rnid iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -4391,7 +4391,7 @@ lpfc_els_rcv_rnid(struct lpfc_vport *vpo
 }
 
 /**
- * lpfc_els_rcv_lirr: Process an unsolicited lirr iocb.
+ * lpfc_els_rcv_lirr - Process an unsolicited lirr iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -4419,7 +4419,7 @@ lpfc_els_rcv_lirr(struct lpfc_vport *vpo
 }
 
 /**
- * lpfc_els_rsp_rps_acc: Completion callbk func for MBX_READ_LNK_STAT mbox cmd.
+ * lpfc_els_rsp_rps_acc - Completion callbk func for MBX_READ_LNK_STAT mbox cmd
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -4513,7 +4513,7 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba *ph
 }
 
 /**
- * lpfc_els_rcv_rps: Process an unsolicited rps iocb.
+ * lpfc_els_rcv_rps - Process an unsolicited rps iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -4590,7 +4590,7 @@ reject_out:
 }
 
 /**
- * lpfc_els_rsp_rpl_acc: Issue an accept rpl els command.
+ * lpfc_els_rsp_rpl_acc - Issue an accept rpl els command
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdsize: size of the ELS command.
  * @oldiocb: pointer to the original lpfc command iocb data structure.
@@ -4662,7 +4662,7 @@ lpfc_els_rsp_rpl_acc(struct lpfc_vport *
 }
 
 /**
- * lpfc_els_rcv_rpl: Process an unsolicited rpl iocb.
+ * lpfc_els_rcv_rpl - Process an unsolicited rpl iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -4721,7 +4721,7 @@ lpfc_els_rcv_rpl(struct lpfc_vport *vpor
 }
 
 /**
- * lpfc_els_rcv_farp: Process an unsolicited farp request els command.
+ * lpfc_els_rcv_farp - Process an unsolicited farp request els command
  * @vport: pointer to a virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -4804,7 +4804,7 @@ lpfc_els_rcv_farp(struct lpfc_vport *vpo
 }
 
 /**
- * lpfc_els_rcv_farpr: Process an unsolicited farp response iocb.
+ * lpfc_els_rcv_farpr - Process an unsolicited farp response iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -4842,7 +4842,7 @@ lpfc_els_rcv_farpr(struct lpfc_vport *vp
 }
 
 /**
- * lpfc_els_rcv_fan: Process an unsolicited fan iocb command.
+ * lpfc_els_rcv_fan - Process an unsolicited fan iocb command
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @fan_ndlp: pointer to a node-list data structure.
@@ -4890,14 +4890,14 @@ lpfc_els_rcv_fan(struct lpfc_vport *vpor
 }
 
 /**
- * lpfc_els_timeout: Handler funciton to the els timer.
+ * lpfc_els_timeout - Handler funciton to the els timer
  * @ptr: holder for the timer function associated data.
  *
  * This routine is invoked by the ELS timer after timeout. It posts the ELS
  * timer timeout event by setting the WORKER_ELS_TMO bit to the work port
  * event bitmap and then invokes the lpfc_worker_wake_up() routine to wake
  * up the worker thread. It is for the worker thread to invoke the routine
- * lpfc_els_timeout_handler() to work on the posted event WORKER_ELS_TMO.
+ * lpfc_els_timeout_handler() to work on the posted event WORKER_ELS_TMO
  **/
 void
 lpfc_els_timeout(unsigned long ptr)
@@ -4919,7 +4919,7 @@ lpfc_els_timeout(unsigned long ptr)
 }
 
 /**
- * lpfc_els_timeout_handler: Process an els timeout event.
+ * lpfc_els_timeout_handler - Process an els timeout event
  * @vport: pointer to a virtual N_Port data structure.
  *
  * This routine is the actual handler function that processes an ELS timeout
@@ -4994,7 +4994,7 @@ lpfc_els_timeout_handler(struct lpfc_vpo
 }
 
 /**
- * lpfc_els_flush_cmd: Clean up the outstanding els commands to a vport.
+ * lpfc_els_flush_cmd - Clean up the outstanding els commands to a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
  * This routine is used to clean up all the outstanding ELS commands on a
@@ -5076,7 +5076,7 @@ lpfc_els_flush_cmd(struct lpfc_vport *vp
 }
 
 /**
- * lpfc_els_flush_all_cmd: Clean up all the outstanding els commands to a HBA.
+ * lpfc_els_flush_all_cmd - Clean up all the outstanding els commands to a HBA
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is used to clean up all the outstanding ELS commands on a
@@ -5137,7 +5137,7 @@ lpfc_els_flush_all_cmd(struct lpfc_hba  
 }
 
 /**
- * lpfc_send_els_failure_event: Posts an ELS command failure event.
+ * lpfc_send_els_failure_event - Posts an ELS command failure event
  * @phba: Pointer to hba context object.
  * @cmdiocbp: Pointer to command iocb which reported error.
  * @rspiocbp: Pointer to response iocb which reported error.
@@ -5204,7 +5204,7 @@ lpfc_send_els_failure_event(struct lpfc_
 }
 
 /**
- * lpfc_send_els_event: Posts unsolicited els event.
+ * lpfc_send_els_event - Posts unsolicited els event
  * @vport: Pointer to vport object.
  * @ndlp: Pointer FC node object.
  * @cmd: ELS command code.
@@ -5283,7 +5283,7 @@ lpfc_send_els_event(struct lpfc_vport *v
 

 /**
- * lpfc_els_unsol_buffer: Process an unsolicited event data buffer.
+ * lpfc_els_unsol_buffer - Process an unsolicited event data buffer
  * @phba: pointer to lpfc hba data structure.
  * @pring: pointer to a SLI ring.
  * @vport: pointer to a host virtual N_Port data structure.
@@ -5591,7 +5591,7 @@ dropit:
 }
 
 /**
- * lpfc_find_vport_by_vpid: Find a vport on a HBA through vport identifier.
+ * lpfc_find_vport_by_vpid - Find a vport on a HBA through vport identifier
  * @phba: pointer to lpfc hba data structure.
  * @vpi: host virtual N_Port identifier.
  *
@@ -5621,7 +5621,7 @@ lpfc_find_vport_by_vpid(struct lpfc_hba 
 }
 
 /**
- * lpfc_els_unsol_event: Process an unsolicited event from an els sli ring.
+ * lpfc_els_unsol_event - Process an unsolicited event from an els sli ring
  * @phba: pointer to lpfc hba data structure.
  * @pring: pointer to a SLI ring.
  * @elsiocb: pointer to lpfc els iocb data structure.
@@ -5709,7 +5709,7 @@ lpfc_els_unsol_event(struct lpfc_hba *ph
 }
 
 /**
- * lpfc_do_scr_ns_plogi: Issue a plogi to the name server for scr.
+ * lpfc_do_scr_ns_plogi - Issue a plogi to the name server for scr
  * @phba: pointer to lpfc hba data structure.
  * @vport: pointer to a virtual N_Port data structure.
  *
@@ -5780,7 +5780,7 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *ph
 }
 
 /**
- * lpfc_cmpl_reg_new_vport: Completion callback function to register new vport.
+ * lpfc_cmpl_reg_new_vport - Completion callback function to register new vport
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -5849,7 +5849,7 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 }
 
 /**
- * lpfc_register_new_vport: Register a new vport with a HBA.
+ * lpfc_register_new_vport - Register a new vport with a HBA
  * @phba: pointer to lpfc hba data structure.
  * @vport: pointer to a host virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -5898,7 +5898,7 @@ mbox_err_exit:
 }
 
 /**
- * lpfc_cmpl_els_fdisc: Completion function for fdisc iocb command.
+ * lpfc_cmpl_els_fdisc - Completion function for fdisc iocb command
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -6006,7 +6006,7 @@ out:
 }
 
 /**
- * lpfc_issue_els_fdisc: Issue a fdisc iocb command.
+ * lpfc_issue_els_fdisc - Issue a fdisc iocb command
  * @vport: pointer to a virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  * @retry: number of retries to the command IOCB.
@@ -6100,7 +6100,7 @@ lpfc_issue_els_fdisc(struct lpfc_vport *
 }
 
 /**
- * lpfc_cmpl_els_npiv_logo: Completion function with vport logo.
+ * lpfc_cmpl_els_npiv_logo - Completion function with vport logo
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -6135,7 +6135,7 @@ lpfc_cmpl_els_npiv_logo(struct lpfc_hba 
 }
 
 /**
- * lpfc_issue_els_npiv_logo: Issue a logo off a vport.
+ * lpfc_issue_els_npiv_logo - Issue a logo off a vport
  * @vport: pointer to a virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  *
@@ -6196,7 +6196,7 @@ lpfc_issue_els_npiv_logo(struct lpfc_vpo
 }
 
 /**
- * lpfc_fabric_block_timeout: Handler function to the fabric block timer.
+ * lpfc_fabric_block_timeout - Handler function to the fabric block timer
  * @ptr: holder for the timer function associated data.
  *
  * This routine is invoked by the fabric iocb block timer after
@@ -6225,14 +6225,14 @@ lpfc_fabric_block_timeout(unsigned long 
 }
 
 /**
- * lpfc_resume_fabric_iocbs: Issue a fabric iocb from driver internal list.
+ * lpfc_resume_fabric_iocbs - Issue a fabric iocb from driver internal list
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine issues one fabric iocb from the driver internal list to
  * the HBA. It first checks whether it's ready to issue one fabric iocb to
  * the HBA (whether there is no outstanding fabric iocb). If so, it shall
  * remove one pending fabric iocb from the driver internal list and invokes
- * lpfc_sli_issue_iocb() routine to send the fabric iocb to the HBA.
+ * lpfc_sli_issue_iocb() routine to send the fabric iocb to the HBA
  **/
 static void
 lpfc_resume_fabric_iocbs(struct lpfc_hba *phba)
@@ -6284,7 +6284,7 @@ repeat:
 }
 
 /**
- * lpfc_unblock_fabric_iocbs: Unblock issuing fabric iocb command.
+ * lpfc_unblock_fabric_iocbs - Unblock issuing fabric iocb command
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine unblocks the  issuing fabric iocb command. The function
@@ -6302,7 +6302,7 @@ lpfc_unblock_fabric_iocbs(struct lpfc_hb
 }
 
 /**
- * lpfc_block_fabric_iocbs: Block issuing fabric iocb command.
+ * lpfc_block_fabric_iocbs - Block issuing fabric iocb command
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine blocks the issuing fabric iocb for a specified amount of
@@ -6324,7 +6324,7 @@ lpfc_block_fabric_iocbs(struct lpfc_hba 
 }
 
 /**
- * lpfc_cmpl_fabric_iocb: Completion callback function for fabric iocb.
+ * lpfc_cmpl_fabric_iocb - Completion callback function for fabric iocb
  * @phba: pointer to lpfc hba data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @rspiocb: pointer to lpfc response iocb data structure.
@@ -6383,7 +6383,7 @@ lpfc_cmpl_fabric_iocb(struct lpfc_hba *p
 }
 
 /**
- * lpfc_issue_fabric_iocb: Issue a fabric iocb command.
+ * lpfc_issue_fabric_iocb - Issue a fabric iocb command
  * @phba: pointer to lpfc hba data structure.
  * @iocb: pointer to lpfc command iocb data structure.
  *
@@ -6452,7 +6452,7 @@ lpfc_issue_fabric_iocb(struct lpfc_hba *
 }
 
 /**
- * lpfc_fabric_abort_vport: Abort a vport's iocbs from driver fabric iocb list.
+ * lpfc_fabric_abort_vport - Abort a vport's iocbs from driver fabric iocb list
  * @vport: pointer to a virtual N_Port data structure.
  *
  * This routine aborts all the IOCBs associated with a @vport from the
@@ -6492,7 +6492,7 @@ static void lpfc_fabric_abort_vport(stru
 }
 
 /**
- * lpfc_fabric_abort_nport: Abort a ndlp's iocbs from driver fabric iocb list.
+ * lpfc_fabric_abort_nport - Abort a ndlp's iocbs from driver fabric iocb list
  * @ndlp: pointer to a node-list data structure.
  *
  * This routine aborts all the IOCBs associated with an @ndlp from the
@@ -6532,7 +6532,7 @@ void lpfc_fabric_abort_nport(struct lpfc
 }
 
 /**
- * lpfc_fabric_abort_hba: Abort all iocbs on driver fabric iocb list.
+ * lpfc_fabric_abort_hba - Abort all iocbs on driver fabric iocb list
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine aborts all the IOCBs currently on the driver internal


