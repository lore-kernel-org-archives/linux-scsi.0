From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 3/5] lpfc : Correct kdoc syntax errors in lpfc_sli.c
Date: Tue, 16 Dec 2008 11:01:48 -0500
Message-ID: <1229443308.4621.19.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63314 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382AbYLPQAU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2008 11:00:20 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mBGG0KIg026198
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2008 08:00:20 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |  182 +++++++++++++++++++++++++++++--------------------------------
 1 file changed, 87 insertions(+), 95 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-12-16 09:34:12.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-12-16 10:49:58.000000000 -0500
@@ -68,7 +68,7 @@ typedef enum _lpfc_iocb_type {
 } lpfc_iocb_type;
 
 /**
- * lpfc_cmd_iocb: Get next command iocb entry in the ring.
+ * lpfc_cmd_iocb - Get next command iocb entry in the ring
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -85,7 +85,7 @@ lpfc_cmd_iocb(struct lpfc_hba *phba, str
 }
 
 /**
- * lpfc_resp_iocb: Get next response iocb entry in the ring.
+ * lpfc_resp_iocb - Get next response iocb entry in the ring
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -102,7 +102,7 @@ lpfc_resp_iocb(struct lpfc_hba *phba, st
 }
 
 /**
- * __lpfc_sli_get_iocbq: Allocates an iocb object from iocb pool.
+ * __lpfc_sli_get_iocbq - Allocates an iocb object from iocb pool
  * @phba: Pointer to HBA context object.
  *
  * This function is called with hbalock held. This function
@@ -121,7 +121,7 @@ __lpfc_sli_get_iocbq(struct lpfc_hba *ph
 }
 
 /**
- * lpfc_sli_get_iocbq: Allocates an iocb object from iocb pool.
+ * lpfc_sli_get_iocbq - Allocates an iocb object from iocb pool
  * @phba: Pointer to HBA context object.
  *
  * This function is called with no lock held. This function
@@ -142,7 +142,7 @@ lpfc_sli_get_iocbq(struct lpfc_hba *phba
 }
 
 /**
- * __lpfc_sli_release_iocbq: Release iocb to the iocb pool.
+ * __lpfc_sli_release_iocbq - Release iocb to the iocb pool
  * @phba: Pointer to HBA context object.
  * @iocbq: Pointer to driver iocb object.
  *
@@ -164,7 +164,7 @@ __lpfc_sli_release_iocbq(struct lpfc_hba
 }
 
 /**
- * lpfc_sli_release_iocbq: Release iocb to the iocb pool.
+ * lpfc_sli_release_iocbq - Release iocb to the iocb pool
  * @phba: Pointer to HBA context object.
  * @iocbq: Pointer to driver iocb object.
  *
@@ -185,8 +185,8 @@ lpfc_sli_release_iocbq(struct lpfc_hba *
 }
 
 /**
- * lpfc_sli_iocb_cmd_type: Get the iocb type.
- * @iocb_cmnd : iocb command code.
+ * lpfc_sli_iocb_cmd_type - Get the iocb type
+ * @iocb_cmnd: iocb command code.
  *
  * This function is called by ring event handler function to get the iocb type.
  * This function translates the iocb command to an iocb command type used to
@@ -295,7 +295,7 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd
 }
 
 /**
- * lpfc_sli_ring_map: Issue config_ring mbox for all rings.
+ * lpfc_sli_ring_map - Issue config_ring mbox for all rings
  * @phba: Pointer to HBA context object.
  *
  * This function is called from SLI initialization code
@@ -338,7 +338,7 @@ lpfc_sli_ring_map(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_ringtxcmpl_put: Adds new iocb to the txcmplq.
+ * lpfc_sli_ringtxcmpl_put - Adds new iocb to the txcmplq
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @piocb: Pointer to the driver iocb object.
@@ -370,7 +370,7 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba 
 }
 
 /**
- * lpfc_sli_ringtx_get: Get first element of the txq.
+ * lpfc_sli_ringtx_get - Get first element of the txq
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -391,7 +391,7 @@ lpfc_sli_ringtx_get(struct lpfc_hba *phb
 }
 
 /**
- * lpfc_sli_next_iocb_slot: Get next iocb slot in the ring.
+ * lpfc_sli_next_iocb_slot - Get next iocb slot in the ring
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -445,7 +445,7 @@ lpfc_sli_next_iocb_slot (struct lpfc_hba
 }
 
 /**
- * lpfc_sli_next_iotag: Get an iotag for the iocb.
+ * lpfc_sli_next_iotag - Get an iotag for the iocb
  * @phba: Pointer to HBA context object.
  * @iocbq: Pointer to driver iocb object.
  *
@@ -520,7 +520,7 @@ lpfc_sli_next_iotag(struct lpfc_hba *phb
 }
 
 /**
- * lpfc_sli_submit_iocb: Submit an iocb to the firmware.
+ * lpfc_sli_submit_iocb - Submit an iocb to the firmware
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @iocb: Pointer to iocb slot in the ring.
@@ -577,7 +577,7 @@ lpfc_sli_submit_iocb(struct lpfc_hba *ph
 }
 
 /**
- * lpfc_sli_update_full_ring: Update the chip attention register.
+ * lpfc_sli_update_full_ring - Update the chip attention register
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -608,7 +608,7 @@ lpfc_sli_update_full_ring(struct lpfc_hb
 }
 
 /**
- * lpfc_sli_update_ring: Update chip attention register.
+ * lpfc_sli_update_ring - Update chip attention register
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -632,7 +632,7 @@ lpfc_sli_update_ring(struct lpfc_hba *ph
 }
 
 /**
- * lpfc_sli_resume_iocb: Process iocbs in the txq.
+ * lpfc_sli_resume_iocb - Process iocbs in the txq
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -672,7 +672,7 @@ lpfc_sli_resume_iocb(struct lpfc_hba *ph
 }
 
 /**
- * lpfc_sli_next_hbq_slot: Get next hbq entry for the HBQ.
+ * lpfc_sli_next_hbq_slot - Get next hbq entry for the HBQ
  * @phba: Pointer to HBA context object.
  * @hbqno: HBQ number.
  *
@@ -717,7 +717,7 @@ lpfc_sli_next_hbq_slot(struct lpfc_hba *
 }
 
 /**
- * lpfc_sli_hbqbuf_free_all: Free all the hbq buffers.
+ * lpfc_sli_hbqbuf_free_all - Free all the hbq buffers
  * @phba: Pointer to HBA context object.
  *
  * This function is called with no lock held to free all the
@@ -771,7 +771,7 @@ lpfc_sli_hbqbuf_free_all(struct lpfc_hba
 }
 
 /**
- * lpfc_sli_hbq_to_firmware: Post the hbq buffer to firmware.
+ * lpfc_sli_hbq_to_firmware - Post the hbq buffer to firmware
  * @phba: Pointer to HBA context object.
  * @hbqno: HBQ number.
  * @hbq_buf: Pointer to HBQ buffer.
@@ -841,7 +841,7 @@ struct lpfc_hbq_init *lpfc_hbq_defs[] = 
 };
 
 /**
- * lpfc_sli_hbqbuf_fill_hbqs: Post more hbq buffers to HBQ.
+ * lpfc_sli_hbqbuf_fill_hbqs - Post more hbq buffers to HBQ
  * @phba: Pointer to HBA context object.
  * @hbqno: HBQ number.
  * @count: Number of HBQ buffers to be posted.
@@ -901,7 +901,7 @@ err:
 }
 
 /**
- * lpfc_sli_hbqbuf_add_hbqs: Post more HBQ buffers to firmware.
+ * lpfc_sli_hbqbuf_add_hbqs - Post more HBQ buffers to firmware
  * @phba: Pointer to HBA context object.
  * @qno: HBQ number.
  *
@@ -917,7 +917,7 @@ lpfc_sli_hbqbuf_add_hbqs(struct lpfc_hba
 }
 
 /**
- * lpfc_sli_hbqbuf_init_hbqs: Post initial buffers to the HBQ.
+ * lpfc_sli_hbqbuf_init_hbqs - Post initial buffers to the HBQ
  * @phba: Pointer to HBA context object.
  * @qno:  HBQ queue number.
  *
@@ -933,7 +933,7 @@ lpfc_sli_hbqbuf_init_hbqs(struct lpfc_hb
 }
 
 /**
- * lpfc_sli_hbqbuf_find: Find the hbq buffer associated with a tag.
+ * lpfc_sli_hbqbuf_find - Find the hbq buffer associated with a tag
  * @phba: Pointer to HBA context object.
  * @tag: Tag of the hbq buffer.
  *
@@ -966,7 +966,7 @@ lpfc_sli_hbqbuf_find(struct lpfc_hba *ph
 }
 
 /**
- * lpfc_sli_free_hbq: Give back the hbq buffer to firmware.
+ * lpfc_sli_free_hbq - Give back the hbq buffer to firmware
  * @phba: Pointer to HBA context object.
  * @hbq_buffer: Pointer to HBQ buffer.
  *
@@ -988,7 +988,7 @@ lpfc_sli_free_hbq(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_sli_chk_mbx_command: Check if the mailbox is a legitimate mailbox.
+ * lpfc_sli_chk_mbx_command - Check if the mailbox is a legitimate mailbox
  * @mbxCommand: mailbox command code.
  *
  * This function is called by the mailbox event handler function to verify
@@ -1064,8 +1064,7 @@ lpfc_sli_chk_mbx_command(uint8_t mbxComm
 }
 
 /**
- * lpfc_sli_wake_mbox_wait: Completion handler for mbox issued from
- *          lpfc_sli_issue_mbox_wait.
+ * lpfc_sli_wake_mbox_wait - lpfc_sli_issue_mbox_wait mbox completion handler
  * @phba: Pointer to HBA context object.
  * @pmboxq: Pointer to mailbox command.
  *
@@ -1096,7 +1095,7 @@ lpfc_sli_wake_mbox_wait(struct lpfc_hba 
 

 /**
- * lpfc_sli_def_mbox_cmpl: Default mailbox completion handler.
+ * lpfc_sli_def_mbox_cmpl - Default mailbox completion handler
  * @phba: Pointer to HBA context object.
  * @pmb: Pointer to mailbox object.
  *
@@ -1140,7 +1139,7 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *
 }
 
 /**
- * lpfc_sli_handle_mb_event: Handle mailbox completions from firmware.
+ * lpfc_sli_handle_mb_event - Handle mailbox completions from firmware
  * @phba: Pointer to HBA context object.
  *
  * This function is called with no lock held. This function processes all
@@ -1260,7 +1259,7 @@ lpfc_sli_handle_mb_event(struct lpfc_hba
 }
 
 /**
- * lpfc_sli_get_buff: Get the buffer associated with the buffer tag.
+ * lpfc_sli_get_buff - Get the buffer associated with the buffer tag
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @tag: buffer tag.
@@ -1288,7 +1287,7 @@ lpfc_sli_get_buff(struct lpfc_hba *phba,
 

 /**
- * lpfc_sli_process_unsol_iocb: Unsolicited iocb handler.
+ * lpfc_sli_process_unsol_iocb - Unsolicited iocb handler
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @saveq: Pointer to the unsolicited iocb.
@@ -1484,7 +1483,7 @@ lpfc_sli_process_unsol_iocb(struct lpfc_
 }
 
 /**
- * lpfc_sli_iocbq_lookup: Find command iocb for the given response iocb.
+ * lpfc_sli_iocbq_lookup - Find command iocb for the given response iocb
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @prspiocb: Pointer to response iocb object.
@@ -1521,7 +1520,7 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *p
 }
 
 /**
- * lpfc_sli_process_sol_iocb: process solicited iocb completion.
+ * lpfc_sli_process_sol_iocb - process solicited iocb completion
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @saveq: Pointer to the response iocb to be processed.
@@ -1614,7 +1613,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 }
 
 /**
- * lpfc_sli_rsp_pointers_error: Response ring pointer error handler.
+ * lpfc_sli_rsp_pointers_error - Response ring pointer error handler
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -1652,7 +1651,7 @@ lpfc_sli_rsp_pointers_error(struct lpfc_
 }
 
 /**
- * lpfc_poll_eratt: Error attention polling timer timeout handler.
+ * lpfc_poll_eratt - Error attention polling timer timeout handler
  * @ptr: Pointer to address of HBA context object.
  *
  * This function is invoked by the Error Attention polling timer when the
@@ -1682,7 +1681,7 @@ void lpfc_poll_eratt(unsigned long ptr)
 }
 
 /**
- * lpfc_sli_poll_fcp_ring: Handle FCP ring completion in polling mode.
+ * lpfc_sli_poll_fcp_ring - Handle FCP ring completion in polling mode
  * @phba: Pointer to HBA context object.
  *
  * This function is called from lpfc_queuecommand, lpfc_poll_timeout,
@@ -1845,7 +1844,7 @@ void lpfc_sli_poll_fcp_ring(struct lpfc_
 }
 
 /**
- * lpfc_sli_handle_fast_ring_event: Handle ring events on FCP ring.
+ * lpfc_sli_handle_fast_ring_event - Handle ring events on FCP ring
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @mask: Host attention register mask for this ring.
@@ -2037,7 +2036,7 @@ lpfc_sli_handle_fast_ring_event(struct l
 }
 
 /**
- * lpfc_sli_handle_slow_ring_event: Handle ring events for non-FCP rings.
+ * lpfc_sli_handle_slow_ring_event - Handle ring events for non-FCP rings
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @mask: Host attention register mask for this ring.
@@ -2311,7 +2310,7 @@ lpfc_sli_handle_slow_ring_event(struct l
 }
 
 /**
- * lpfc_sli_abort_iocb_ring: Abort all iocbs in the ring.
+ * lpfc_sli_abort_iocb_ring  Abort all iocbs in the ring
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  *
@@ -2360,7 +2359,7 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba
 }
 
 /**
- * lpfc_sli_flush_fcp_rings: flush all iocbs in the fcp ring.
+ * lpfc_sli_flush_fcp_rings - flush all iocbs in the fcp ring
  * @phba: Pointer to HBA context object.
  *
  * This function flushes all iocbs in the fcp ring and frees all the iocb
@@ -2424,7 +2423,7 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba
 }
 
 /**
- * lpfc_sli_brdready: Check for host status bits.
+ * lpfc_sli_brdready - Check for host status bits
  * @phba: Pointer to HBA context object.
  * @mask: Bit mask to be checked.
  *
@@ -2484,7 +2483,7 @@ lpfc_sli_brdready(struct lpfc_hba *phba,
 #define BARRIER_TEST_PATTERN (0xdeadbeef)
 
 /**
- * lpfc_reset_barrier: Make HBA ready for HBA reset.
+ * lpfc_reset_barrier - Make HBA ready for HBA reset
  * @phba: Pointer to HBA context object.
  *
  * This function is called before resetting an HBA. This
@@ -2564,7 +2563,7 @@ restore_hc:
 }
 
 /**
- * lpfc_sli_brdkill: Issue a kill_board mailbox command.
+ * lpfc_sli_brdkill - Issue a kill_board mailbox command
  * @phba: Pointer to HBA context object.
  *
  * This function issues a kill_board mailbox command and waits for
@@ -2651,7 +2650,7 @@ lpfc_sli_brdkill(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_brdreset: Reset the HBA.
+ * lpfc_sli_brdreset - Reset the HBA
  * @phba: Pointer to HBA context object.
  *
  * This function resets the HBA by writing HC_INITFF to the control
@@ -2714,7 +2713,7 @@ lpfc_sli_brdreset(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_brdrestart: Restart the HBA.
+ * lpfc_sli_brdrestart - Restart the HBA
  * @phba: Pointer to HBA context object.
  *
  * This function is called in the SLI initialization code path to
@@ -2781,7 +2780,7 @@ lpfc_sli_brdrestart(struct lpfc_hba *phb
 }
 
 /**
- * lpfc_sli_chipset_init: Wait for the restart of the HBA after a restart.
+ * lpfc_sli_chipset_init - Wait for the restart of the HBA after a restart
  * @phba: Pointer to HBA context object.
  *
  * This function is called after a HBA restart to wait for successful
@@ -2876,7 +2875,7 @@ lpfc_sli_chipset_init(struct lpfc_hba *p
 }
 
 /**
- * lpfc_sli_hbq_count: Get the number of HBQs to be configured.
+ * lpfc_sli_hbq_count - Get the number of HBQs to be configured
  *
  * This function calculates and returns the number of HBQs required to be
  * configured.
@@ -2888,7 +2887,7 @@ lpfc_sli_hbq_count(void)
 }
 
 /**
- * lpfc_sli_hbq_entry_count: Calculate total number of hbq entries.
+ * lpfc_sli_hbq_entry_count - Calculate total number of hbq entries
  *
  * This function adds the number of hbq entries in every HBQ to get
  * the total number of hbq entries required for the HBA and returns
@@ -2907,7 +2906,7 @@ lpfc_sli_hbq_entry_count(void)
 }
 
 /**
- * lpfc_sli_hbq_size: Calculate memory required for all hbq entries.
+ * lpfc_sli_hbq_size - Calculate memory required for all hbq entries
  *
  * This function calculates amount of memory required for all hbq entries
  * to be configured and returns the total memory required.
@@ -2919,7 +2918,7 @@ lpfc_sli_hbq_size(void)
 }
 
 /**
- * lpfc_sli_hbq_setup: configure and initialize HBQs.
+ * lpfc_sli_hbq_setup - configure and initialize HBQs
  * @phba: Pointer to HBA context object.
  *
  * This function is called during the SLI initialization to configure
@@ -2988,7 +2987,7 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba
 }
 
 /**
- * lpfc_sli_config_port: Issue config port mailbox command.
+ * lpfc_sli_config_port - Issue config port mailbox command
  * @phba: Pointer to HBA context object.
  * @sli_mode: sli mode - 2/3
  *
@@ -3114,7 +3113,7 @@ do_prep_failed:
 

 /**
- * lpfc_sli_hba_setup: SLI intialization function.
+ * lpfc_sli_hba_setup - SLI intialization function
  * @phba: Pointer to HBA context object.
  *
  * This function is the main SLI intialization function. This function
@@ -3206,7 +3205,7 @@ lpfc_sli_hba_setup_error:
 

 /**
- * lpfc_mbox_timeout: Timeout call back function for mbox timer.
+ * lpfc_mbox_timeout - Timeout call back function for mbox timer
  * @ptr: context object - pointer to hba structure.
  *
  * This is the callback function for mailbox timer. The mailbox
@@ -3237,7 +3236,7 @@ lpfc_mbox_timeout(unsigned long ptr)
 

 /**
- * lpfc_mbox_timeout_handler: Worker thread function to handle mailbox timeout.
+ * lpfc_mbox_timeout_handler - Worker thread function to handle mailbox timeout
  * @phba: Pointer to HBA context object.
  *
  * This function is called from worker thread when a mailbox command times out.
@@ -3295,7 +3294,7 @@ lpfc_mbox_timeout_handler(struct lpfc_hb
 }
 
 /**
- * lpfc_sli_issue_mbox: Issue a mailbox command to firmware.
+ * lpfc_sli_issue_mbox - Issue a mailbox command to firmware
  * @phba: Pointer to HBA context object.
  * @pmbox: Pointer to mailbox object.
  * @flag: Flag indicating how the mailbox need to be processed.
@@ -3632,7 +3631,7 @@ out_not_finished:
 }
 
 /**
- * __lpfc_sli_ringtx_put: Add an iocb to the txq.
+ * __lpfc_sli_ringtx_put - Add an iocb to the txq
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @piocb: Pointer to address of newly added command iocb.
@@ -3651,7 +3650,7 @@ __lpfc_sli_ringtx_put(struct lpfc_hba *p
 }
 
 /**
- * lpfc_sli_next_iocb: Get the next iocb in the txq.
+ * lpfc_sli_next_iocb - Get the next iocb in the txq
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @piocb: Pointer to address of newly added command iocb.
@@ -3683,7 +3682,7 @@ lpfc_sli_next_iocb(struct lpfc_hba *phba
 }
 
 /**
- * __lpfc_sli_issue_iocb: Lockless version of lpfc_sli_issue_iocb.
+ * __lpfc_sli_issue_iocb - Lockless version of lpfc_sli_issue_iocb
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @piocb: Pointer to command iocb.
@@ -3813,7 +3812,7 @@ __lpfc_sli_issue_iocb(struct lpfc_hba *p
 

 /**
- * lpfc_sli_issue_iocb: Wrapper function for __lpfc_sli_issue_iocb.
+ * lpfc_sli_issue_iocb - Wrapper function for __lpfc_sli_issue_iocb
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @piocb: Pointer to command iocb.
@@ -3840,7 +3839,7 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phb
 }
 
 /**
- * lpfc_extra_ring_setup: Extra ring setup function.
+ * lpfc_extra_ring_setup - Extra ring setup function
  * @phba: Pointer to HBA context object.
  *
  * This function is called while driver attaches with the
@@ -3886,7 +3885,7 @@ lpfc_extra_ring_setup( struct lpfc_hba *
 }
 
 /**
- * lpfc_sli_async_event_handler: ASYNC iocb handler function.
+ * lpfc_sli_async_event_handler - ASYNC iocb handler function
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @iocbq: Pointer to iocb object.
@@ -3954,7 +3953,7 @@ lpfc_sli_async_event_handler(struct lpfc
 

 /**
- * lpfc_sli_setup: SLI ring setup function.
+ * lpfc_sli_setup - SLI ring setup function
  * @phba: Pointer to HBA context object.
  *
  * lpfc_sli_setup sets up rings of the SLI interface with
@@ -4076,7 +4075,7 @@ lpfc_sli_setup(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_queue_setup: Queue initialization function.
+ * lpfc_sli_queue_setup - Queue initialization function
  * @phba: Pointer to HBA context object.
  *
  * lpfc_sli_queue_setup sets up mailbox queues and iocb queues for each
@@ -4115,7 +4114,7 @@ lpfc_sli_queue_setup(struct lpfc_hba *ph
 }
 
 /**
- * lpfc_sli_host_down: Vport cleanup function.
+ * lpfc_sli_host_down - Vport cleanup function
  * @vport: Pointer to virtual port object.
  *
  * lpfc_sli_host_down is called to clean up the resources
@@ -4194,7 +4193,7 @@ lpfc_sli_host_down(struct lpfc_vport *vp
 }
 
 /**
- * lpfc_sli_hba_down: Resource cleanup function for the HBA.
+ * lpfc_sli_hba_down - Resource cleanup function for the HBA
  * @phba: Pointer to HBA context object.
  *
  * This function cleans up all iocb, buffers, mailbox commands
@@ -4299,7 +4298,7 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_sli_pcimem_bcopy: SLI memory copy function.
+ * lpfc_sli_pcimem_bcopy - SLI memory copy function
  * @srcp: Source memory pointer.
  * @destp: Destination memory pointer.
  * @cnt: Number of words required to be copied.
@@ -4329,7 +4328,7 @@ lpfc_sli_pcimem_bcopy(void *srcp, void *
 

 /**
- * lpfc_sli_ringpostbuf_put: Function to add a buffer to postbufq.
+ * lpfc_sli_ringpostbuf_put - Function to add a buffer to postbufq
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @mp: Pointer to driver buffer object.
@@ -4352,8 +4351,7 @@ lpfc_sli_ringpostbuf_put(struct lpfc_hba
 }
 
 /**
- * lpfc_sli_get_buffer_tag: Tag allocation function for a buffer posted
- *          using CMD_QUE_XRI64_CX iocb.
+ * lpfc_sli_get_buffer_tag - allocates a tag for a CMD_QUE_XRI64_CX buffer
  * @phba: Pointer to HBA context object.
  *
  * When HBQ is enabled, buffers are searched based on tags. This function
@@ -4378,8 +4376,7 @@ lpfc_sli_get_buffer_tag(struct lpfc_hba 
 }
 
 /**
- * lpfc_sli_ring_taggedbuf_get: Search HBQ buffer associated with
- *              posted using CMD_QUE_XRI64_CX iocb.
+ * lpfc_sli_ring_taggedbuf_get - find HBQ buffer associated with given tag
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @tag: Buffer tag.
@@ -4422,8 +4419,7 @@ lpfc_sli_ring_taggedbuf_get(struct lpfc_
 }
 
 /**
- * lpfc_sli_ringpostbuf_get: SLI2 buffer search function for
- *      unsolicited ct and els events.
+ * lpfc_sli_ringpostbuf_get - search buffers for unsolicited CT and ELS events
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @phys: DMA address of the buffer.
@@ -4431,7 +4427,7 @@ lpfc_sli_ring_taggedbuf_get(struct lpfc_
  * This function searches the buffer list using the dma_address
  * of unsolicited event to find the driver's lpfc_dmabuf object
  * corresponding to the dma_address. The function returns the
- * lpfc_dmabuf object if a buffer is found else it returns NULL.
+ * lpfc_dmabuf object if a buffer is found else it returns NULL
  * This function is called by the ct and els unsolicited event
  * handlers to get the buffer associated with the unsolicited
  * event.
@@ -4466,7 +4462,7 @@ lpfc_sli_ringpostbuf_get(struct lpfc_hba
 }
 
 /**
- * lpfc_sli_abort_els_cmpl: Completion handler for the els abort iocbs.
+ * lpfc_sli_abort_els_cmpl - Completion handler for the els abort iocbs
  * @phba: Pointer to HBA context object.
  * @cmdiocb: Pointer to driver command iocb object.
  * @rspiocb: Pointer to driver response iocb object.
@@ -4542,7 +4538,7 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba 
 }
 
 /**
- * lpfc_ignore_els_cmpl: Completion handler for aborted ELS command.
+ * lpfc_ignore_els_cmpl - Completion handler for aborted ELS command
  * @phba: Pointer to HBA context object.
  * @cmdiocb: Pointer to driver command iocb object.
  * @rspiocb: Pointer to driver response iocb object.
@@ -4572,7 +4568,7 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *ph
 }
 
 /**
- * lpfc_sli_issue_abort_iotag: Abort function for a command iocb.
+ * lpfc_sli_issue_abort_iotag - Abort function for a command iocb
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @cmdiocb: Pointer to driver command iocb object.
@@ -4658,15 +4654,14 @@ abort_iotag_exit:
 }
 
 /**
- * lpfc_sli_validate_fcp_iocb: Filtering function, used to find commands
- *                    associated with a vport/SCSI target/lun.
+ * lpfc_sli_validate_fcp_iocb - find commands associated with a vport or LUN
  * @iocbq: Pointer to driver iocb object.
  * @vport: Pointer to driver virtual port object.
  * @tgt_id: SCSI ID of the target.
  * @lun_id: LUN ID of the scsi device.
  * @ctx_cmd: LPFC_CTX_LUN/LPFC_CTX_TGT/LPFC_CTX_HOST
  *
- * This function acts as iocb filter for functions which abort or count
+ * This function acts as an iocb filter for functions which abort or count
  * all FCP iocbs pending on a lun/SCSI target/SCSI host. It will return
  * 0 if the filtering criteria is met for the given iocb and will return
  * 1 if the filtering criteria is not met.
@@ -4724,7 +4719,7 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_i
 }
 
 /**
- * lpfc_sli_sum_iocb: Function to count the number of FCP iocbs pending.
+ * lpfc_sli_sum_iocb - Function to count the number of FCP iocbs pending
  * @vport: Pointer to virtual port.
  * @tgt_id: SCSI ID of the target.
  * @lun_id: LUN ID of the scsi device.
@@ -4762,8 +4757,7 @@ lpfc_sli_sum_iocb(struct lpfc_vport *vpo
 }
 
 /**
- * lpfc_sli_abort_fcp_cmpl: Completion handler function for an aborted
- *       FCP iocb.
+ * lpfc_sli_abort_fcp_cmpl - Completion handler function for aborted FCP IOCBs
  * @phba: Pointer to HBA context object
  * @cmdiocb: Pointer to command iocb object.
  * @rspiocb: Pointer to response iocb object.
@@ -4781,8 +4775,7 @@ lpfc_sli_abort_fcp_cmpl(struct lpfc_hba 
 }
 
 /**
- * lpfc_sli_abort_iocb: This function issue abort for all SCSI commands
- *          pending on a SCSI host(vport)/target/lun.
+ * lpfc_sli_abort_iocb - issue abort for all commands on a host/target/LUN
  * @vport: Pointer to virtual port.
  * @pring: Pointer to driver SLI ring object.
  * @tgt_id: SCSI ID of the target.
@@ -4854,8 +4847,7 @@ lpfc_sli_abort_iocb(struct lpfc_vport *v
 }
 
 /**
- * lpfc_sli_wake_iocb_wait: iocb completion handler for iocb issued using
- *                          lpfc_sli_issue_iocb_wait.
+ * lpfc_sli_wake_iocb_wait - lpfc_sli_issue_iocb_wait's completion handler
  * @phba: Pointer to HBA context object.
  * @cmdiocbq: Pointer to command iocb.
  * @rspiocbq: Pointer to response iocb.
@@ -4893,7 +4885,7 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba 
 }
 
 /**
- * lpfc_sli_issue_iocb_wait: Synchronous function to issue iocb commands.
+ * lpfc_sli_issue_iocb_wait - Synchronous function to issue iocb commands
  * @phba: Pointer to HBA context object..
  * @pring: Pointer to sli ring.
  * @piocb: Pointer to command iocb.
@@ -5000,7 +4992,7 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 }
 
 /**
- * lpfc_sli_issue_mbox_wait: Synchronous function to issue mailbox.
+ * lpfc_sli_issue_mbox_wait - Synchronous function to issue mailbox
  * @phba: Pointer to HBA context object.
  * @pmboxq: Pointer to driver mailbox object.
  * @timeout: Timeout in number of seconds.
@@ -5070,7 +5062,7 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
 }
 
 /**
- * lpfc_sli_flush_mbox_queue: mailbox queue cleanup function.
+ * lpfc_sli_flush_mbox_queue - mailbox queue cleanup function
  * @phba: Pointer to HBA context.
  *
  * This function is called to cleanup any pending mailbox
@@ -5113,7 +5105,7 @@ lpfc_sli_flush_mbox_queue(struct lpfc_hb
 }
 
 /**
- * lpfc_sli_check_eratt: check error attention events
+ * lpfc_sli_check_eratt - check error attention events
  * @phba: Pointer to HBA context.
  *
  * This function is called form timer soft interrupt context to check HBA's
@@ -5162,7 +5154,7 @@ lpfc_sli_check_eratt(struct lpfc_hba *ph
 }
 
 /**
- * lpfc_sp_intr_handler: The slow-path interrupt handler of lpfc driver.
+ * lpfc_sp_intr_handler - The slow-path interrupt handler of lpfc driver
  * @irq: Interrupt number.
  * @dev_id: The device context pointer.
  *
@@ -5423,7 +5415,7 @@ send_current_mbox:
 } /* lpfc_sp_intr_handler */
 
 /**
- * lpfc_fp_intr_handler: The fast-path interrupt handler of lpfc driver.
+ * lpfc_fp_intr_handler - The fast-path interrupt handler of lpfc driver
  * @irq: Interrupt number.
  * @dev_id: The device context pointer.
  *
@@ -5510,7 +5502,7 @@ lpfc_fp_intr_handler(int irq, void *dev_
 }  /* lpfc_fp_intr_handler */
 
 /**
- * lpfc_intr_handler: The device-level interrupt handler of lpfc driver.
+ * lpfc_intr_handler - The device-level interrupt handler of lpfc driver
  * @irq: Interrupt number.
  * @dev_id: The device context pointer.
  *


