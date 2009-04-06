From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 5/7] lpfc 8.3.1 : Fix up kernel-doc function comments (Take
	2) - Part 5 of 5
Date: Mon, 6 Apr 2009 18:47:57 -0400
Message-ID: <1239058077.2344.29.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:43042 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757546AbZDFWsG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 18:48:06 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n36Mm5Vd017065
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 15:48:05 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix up kernel-doc function comments (Take 2) - Part 5 of 5

This patch cleans up the kernel-doc formatting in:
lpfc_mbox.c
lpfc_mem.c
lpfc_scsi.c

Signed-off-by: James Smart <James.Smart@emulex.com>
---

 drivers/scsi/lpfc/lpfc_mbox.c |   63 +++++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_mem.c  |   19 +++++-----
 drivers/scsi/lpfc/lpfc_scsi.c |   79 +++++++++++++++++++----------------------
 3 files changed, 77 insertions(+), 84 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -39,7 +39,7 @@
 #include "lpfc_compat.h"
 
 /**
- * lpfc_dump_mem: Prepare a mailbox command for retrieving HBA's VPD memory.
+ * lpfc_dump_mem - Prepare a mailbox command for retrieving HBA's VPD memory
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  * @offset: offset for dumping VPD memory mailbox command.
@@ -77,9 +77,10 @@ lpfc_dump_mem(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb, uint16_t offset)
 }
 
 /**
- * lpfc_dump_mem: Prepare a mailbox command for retrieving wakeup params.
+ * lpfc_dump_wakeup_param - Prepare mailbox command for retrieving wakeup params
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
  * This function create a dump memory mailbox command to dump wake up
  * parameters.
  */
@@ -109,7 +110,7 @@ lpfc_dump_wakeup_param(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 }
 
 /**
- * lpfc_read_nv: Prepare a mailbox command for reading HBA's NVRAM param.
+ * lpfc_read_nv - Prepare a mailbox command for reading HBA's NVRAM param
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -132,7 +133,7 @@ lpfc_read_nv(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_config_async: Prepare a mailbox command for enabling HBA async event.
+ * lpfc_config_async - Prepare a mailbox command for enabling HBA async event
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  * @ring: ring number for the asynchronous event to be configured.
@@ -159,7 +160,7 @@ lpfc_config_async(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb,
 }
 
 /**
- * lpfc_heart_beat: Prepare a mailbox command for heart beat.
+ * lpfc_heart_beat - Prepare a mailbox command for heart beat
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -184,7 +185,7 @@ lpfc_heart_beat(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_read_la: Prepare a mailbox command for reading HBA link attention.
+ * lpfc_read_la - Prepare a mailbox command for reading HBA link attention
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  * @mp: DMA buffer memory for reading the link attention information into.
@@ -228,7 +229,7 @@ lpfc_read_la(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb, struct lpfc_dmabuf *mp)
 }
 
 /**
- * lpfc_clear_la: Prepare a mailbox command for clearing HBA link attention.
+ * lpfc_clear_la - Prepare a mailbox command for clearing HBA link attention
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -257,7 +258,7 @@ lpfc_clear_la(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_config_link: Prepare a mailbox command for configuring link on a HBA.
+ * lpfc_config_link - Prepare a mailbox command for configuring link on a HBA
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -305,7 +306,7 @@ lpfc_config_link(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_config_msi: Prepare a mailbox command for configuring msi-x.
+ * lpfc_config_msi - Prepare a mailbox command for configuring msi-x
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -383,7 +384,7 @@ lpfc_config_msi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 }
 
 /**
- * lpfc_init_link: Prepare a mailbox command for initialize link on a HBA.
+ * lpfc_init_link - Prepare a mailbox command for initialize link on a HBA
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  * @topology: the link topology for the link to be initialized to.
@@ -463,7 +464,7 @@ lpfc_init_link(struct lpfc_hba * phba,
 }
 
 /**
- * lpfc_read_sparam: Prepare a mailbox command for reading HBA parameters.
+ * lpfc_read_sparam - Prepare a mailbox command for reading HBA parameters
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  * @vpi: virtual N_Port identifier.
@@ -523,7 +524,7 @@ lpfc_read_sparam(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb, int vpi)
 }
 
 /**
- * lpfc_unreg_did: Prepare a mailbox command for unregistering DID.
+ * lpfc_unreg_did - Prepare a mailbox command for unregistering DID
  * @phba: pointer to lpfc hba data structure.
  * @vpi: virtual N_Port identifier.
  * @did: remote port identifier.
@@ -555,7 +556,7 @@ lpfc_unreg_did(struct lpfc_hba * phba, uint16_t vpi, uint32_t did,
 }
 
 /**
- * lpfc_read_config: Prepare a mailbox command for reading HBA configuration.
+ * lpfc_read_config - Prepare a mailbox command for reading HBA configuration
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -581,7 +582,7 @@ lpfc_read_config(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_read_lnk_stat: Prepare a mailbox command for reading HBA link stats.
+ * lpfc_read_lnk_stat - Prepare a mailbox command for reading HBA link stats
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -606,7 +607,7 @@ lpfc_read_lnk_stat(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_reg_login: Prepare a mailbox command for registering remote login.
+ * lpfc_reg_login - Prepare a mailbox command for registering remote login
  * @phba: pointer to lpfc hba data structure.
  * @vpi: virtual N_Port identifier.
  * @did: remote port identifier.
@@ -677,7 +678,7 @@ lpfc_reg_login(struct lpfc_hba *phba, uint16_t vpi, uint32_t did,
 }
 
 /**
- * lpfc_unreg_login: Prepare a mailbox command for unregistering remote login.
+ * lpfc_unreg_login - Prepare a mailbox command for unregistering remote login
  * @phba: pointer to lpfc hba data structure.
  * @vpi: virtual N_Port identifier.
  * @rpi: remote port identifier
@@ -709,7 +710,7 @@ lpfc_unreg_login(struct lpfc_hba *phba, uint16_t vpi, uint32_t rpi,
 }
 
 /**
- * lpfc_reg_vpi: Prepare a mailbox command for registering vport identifier.
+ * lpfc_reg_vpi - Prepare a mailbox command for registering vport identifier
  * @phba: pointer to lpfc hba data structure.
  * @vpi: virtual N_Port identifier.
  * @sid: Fibre Channel S_ID (N_Port_ID assigned to a virtual N_Port).
@@ -741,7 +742,7 @@ lpfc_reg_vpi(struct lpfc_hba *phba, uint16_t vpi, uint32_t sid,
 }
 
 /**
- * lpfc_unreg_vpi: Prepare a mailbox command for unregistering vport id.
+ * lpfc_unreg_vpi - Prepare a mailbox command for unregistering vport id
  * @phba: pointer to lpfc hba data structure.
  * @vpi: virtual N_Port identifier.
  * @pmb: pointer to the driver internal queue element for mailbox command.
@@ -771,7 +772,7 @@ lpfc_unreg_vpi(struct lpfc_hba *phba, uint16_t vpi, LPFC_MBOXQ_t *pmb)
 }
 
 /**
- * lpfc_config_pcb_setup: Set up IOCB rings in the Port Control Block (PCB)
+ * lpfc_config_pcb_setup - Set up IOCB rings in the Port Control Block (PCB)
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine sets up and initializes the IOCB rings in the Port Control
@@ -835,7 +836,7 @@ lpfc_config_pcb_setup(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_read_rev: Prepare a mailbox command for reading HBA revision.
+ * lpfc_read_rev - Prepare a mailbox command for reading HBA revision
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -861,7 +862,7 @@ lpfc_read_rev(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_build_hbq_profile2: Set up the HBQ Selection Profile 2.
+ * lpfc_build_hbq_profile2 - Set up the HBQ Selection Profile 2
  * @hbqmb: pointer to the HBQ configuration data structure in mailbox command.
  * @hbq_desc: pointer to the HBQ selection profile descriptor.
  *
@@ -880,7 +881,7 @@ lpfc_build_hbq_profile2(struct config_hbq_var *hbqmb,
 }
 
 /**
- * lpfc_build_hbq_profile3: Set up the HBQ Selection Profile 3.
+ * lpfc_build_hbq_profile3 - Set up the HBQ Selection Profile 3
  * @hbqmb: pointer to the HBQ configuration data structure in mailbox command.
  * @hbq_desc: pointer to the HBQ selection profile descriptor.
  *
@@ -902,7 +903,7 @@ lpfc_build_hbq_profile3(struct config_hbq_var *hbqmb,
 }
 
 /**
- * lpfc_build_hbq_profile5: Set up the HBQ Selection Profile 5.
+ * lpfc_build_hbq_profile5 - Set up the HBQ Selection Profile 5
  * @hbqmb: pointer to the HBQ configuration data structure in mailbox command.
  * @hbq_desc: pointer to the HBQ selection profile descriptor.
  *
@@ -925,7 +926,7 @@ lpfc_build_hbq_profile5(struct config_hbq_var *hbqmb,
 }
 
 /**
- * lpfc_config_hbq: Prepare a mailbox command for configuring an HBQ.
+ * lpfc_config_hbq - Prepare a mailbox command for configuring an HBQ
  * @phba: pointer to lpfc hba data structure.
  * @id: HBQ identifier.
  * @hbq_desc: pointer to the HBA descriptor data structure.
@@ -999,7 +1000,7 @@ lpfc_config_hbq(struct lpfc_hba *phba, uint32_t id,
 }
 
 /**
- * lpfc_config_ring: Prepare a mailbox command for configuring an IOCB ring.
+ * lpfc_config_ring - Prepare a mailbox command for configuring an IOCB ring
  * @phba: pointer to lpfc hba data structure.
  * @ring:
  * @pmb: pointer to the driver internal queue element for mailbox command.
@@ -1057,7 +1058,7 @@ lpfc_config_ring(struct lpfc_hba * phba, int ring, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_config_port: Prepare a mailbox command for configuring port.
+ * lpfc_config_port - Prepare a mailbox command for configuring port
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -1227,7 +1228,7 @@ lpfc_config_port(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 }
 
 /**
- * lpfc_kill_board: Prepare a mailbox command for killing board.
+ * lpfc_kill_board - Prepare a mailbox command for killing board
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
@@ -1253,7 +1254,7 @@ lpfc_kill_board(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
 }
 
 /**
- * lpfc_mbox_put: Put a mailbox cmd into the tail of driver's mailbox queue.
+ * lpfc_mbox_put - Put a mailbox cmd into the tail of driver's mailbox queue
  * @phba: pointer to lpfc hba data structure.
  * @mbq: pointer to the driver internal queue element for mailbox command.
  *
@@ -1277,7 +1278,7 @@ lpfc_mbox_put(struct lpfc_hba * phba, LPFC_MBOXQ_t * mbq)
 }
 
 /**
- * lpfc_mbox_get: Remove a mailbox cmd from the head of driver's mailbox queue.
+ * lpfc_mbox_get - Remove a mailbox cmd from the head of driver's mailbox queue
  * @phba: pointer to lpfc hba data structure.
  *
  * Driver maintains a internal mailbox command queue implemented as a linked
@@ -1304,7 +1305,7 @@ lpfc_mbox_get(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_mbox_cmpl_put: Put mailbox command into mailbox command complete list.
+ * lpfc_mbox_cmpl_put - Put mailbox command into mailbox command complete list
  * @phba: pointer to lpfc hba data structure.
  * @mbq: pointer to the driver internal queue element for mailbox command.
  *
@@ -1327,7 +1328,7 @@ lpfc_mbox_cmpl_put(struct lpfc_hba * phba, LPFC_MBOXQ_t * mbq)
 }
 
 /**
- * lpfc_mbox_tmo_val: Retrieve mailbox command timeout value.
+ * lpfc_mbox_tmo_val - Retrieve mailbox command timeout value
  * @phba: pointer to lpfc hba data structure.
  * @cmd: mailbox command code.
  *
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -41,7 +41,7 @@
 

 /**
- * lpfc_mem_alloc: create and allocate all PCI and memory pools
+ * lpfc_mem_alloc - create and allocate all PCI and memory pools
  * @phba: HBA to allocate pools for
  *
  * Description: Creates and allocates PCI pools lpfc_scsi_dma_buf_pool,
@@ -136,12 +136,12 @@ lpfc_mem_alloc(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_mem_free: Frees all PCI and memory allocated by lpfc_mem_alloc
+ * lpfc_mem_free - Frees all PCI and memory allocated by lpfc_mem_alloc
  * @phba: HBA to free memory for
  *
  * Description: Frees PCI pools lpfc_scsi_dma_buf_pool, lpfc_mbuf_pool,
  * lpfc_hbq_pool.  Frees kmalloc-backed mempools for LPFC_MBOXQ_t and
- * lpfc_nodelist.  Also frees the VPI bitmask.
+ * lpfc_nodelist.  Also frees the VPI bitmask
  *
  * Returns: None
  **/
@@ -212,7 +212,7 @@ lpfc_mem_free(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_mbuf_alloc: Allocate an mbuf from the lpfc_mbuf_pool PCI pool
+ * lpfc_mbuf_alloc - Allocate an mbuf from the lpfc_mbuf_pool PCI pool
  * @phba: HBA which owns the pool to allocate from
  * @mem_flags: indicates if this is a priority (MEM_PRI) allocation
  * @handle: used to return the DMA-mapped address of the mbuf
@@ -249,7 +249,7 @@ lpfc_mbuf_alloc(struct lpfc_hba *phba, int mem_flags, dma_addr_t *handle)
 }
 
 /**
- * __lpfc_mem_free: Free an mbuf from the lpfc_mbuf_pool PCI pool (locked)
+ * __lpfc_mbuf_free - Free an mbuf from the lpfc_mbuf_pool PCI pool (locked)
  * @phba: HBA which owns the pool to return to
  * @virt: mbuf to free
  * @dma: the DMA-mapped address of the lpfc_mbuf_pool to be freed
@@ -278,7 +278,7 @@ __lpfc_mbuf_free(struct lpfc_hba * phba, void *virt, dma_addr_t dma)
 }
 
 /**
- * lpfc_mem_free: Free an mbuf from the lpfc_mbuf_pool PCI pool (unlocked)
+ * lpfc_mbuf_free - Free an mbuf from the lpfc_mbuf_pool PCI pool (unlocked)
  * @phba: HBA which owns the pool to return to
  * @virt: mbuf to free
  * @dma: the DMA-mapped address of the lpfc_mbuf_pool to be freed
@@ -291,7 +291,6 @@ __lpfc_mbuf_free(struct lpfc_hba * phba, void *virt, dma_addr_t dma)
  * Returns: None
  **/
 void
-
 lpfc_mbuf_free(struct lpfc_hba * phba, void *virt, dma_addr_t dma)
 {
 	unsigned long iflags;
@@ -303,7 +302,7 @@ lpfc_mbuf_free(struct lpfc_hba * phba, void *virt, dma_addr_t dma)
 }
 
 /**
- * lpfc_els_hbq_alloc: Allocate an HBQ buffer
+ * lpfc_els_hbq_alloc - Allocate an HBQ buffer
  * @phba: HBA to allocate HBQ buffer for
  *
  * Description: Allocates a DMA-mapped HBQ buffer from the lpfc_hbq_pool PCI
@@ -335,7 +334,7 @@ lpfc_els_hbq_alloc(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_mem_hbq_free: Frees an HBQ buffer allocated with lpfc_els_hbq_alloc
+ * lpfc_mem_hbq_free - Frees an HBQ buffer allocated with lpfc_els_hbq_alloc
  * @phba: HBA buffer was allocated for
  * @hbqbp: HBQ container returned by lpfc_els_hbq_alloc
  *
@@ -355,7 +354,7 @@ lpfc_els_hbq_free(struct lpfc_hba *phba, struct hbq_dmabuf *hbqbp)
 }
 
 /**
- * lpfc_in_buf_free: Free a DMA buffer
+ * lpfc_in_buf_free - Free a DMA buffer
  * @phba: HBA buffer is associated with
  * @mp: Buffer to free
  *
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -112,7 +112,7 @@ lpfc_debug_save_dif(struct scsi_cmnd *cmnd)
 }
 
 /**
- * lpfc_update_stats: Update statistical data for the command completion.
+ * lpfc_update_stats - Update statistical data for the command completion
  * @phba: Pointer to HBA object.
  * @lpfc_cmd: lpfc scsi command object pointer.
  *
@@ -165,8 +165,7 @@ lpfc_update_stats(struct lpfc_hba *phba, struct  lpfc_scsi_buf *lpfc_cmd)
 }
 
 /**
- * lpfc_send_sdev_queuedepth_change_event: Posts a queuedepth change
- *                   event.
+ * lpfc_send_sdev_queuedepth_change_event - Posts a queuedepth change event
  * @phba: Pointer to HBA context object.
  * @vport: Pointer to vport object.
  * @ndlp: Pointer to FC node associated with the target.
@@ -220,7 +219,7 @@ lpfc_send_sdev_queuedepth_change_event(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_rampdown_queue_depth: Post RAMP_DOWN_QUEUE event to worker thread.
+ * lpfc_rampdown_queue_depth - Post RAMP_DOWN_QUEUE event to worker thread
  * @phba: The Hba for which this call is being executed.
  *
  * This routine is called when there is resource error in driver or firmware.
@@ -261,7 +260,7 @@ lpfc_rampdown_queue_depth(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_rampup_queue_depth: Post RAMP_UP_QUEUE event for worker thread.
+ * lpfc_rampup_queue_depth - Post RAMP_UP_QUEUE event for worker thread
  * @phba: The Hba for which this call is being executed.
  *
  * This routine post WORKER_RAMP_UP_QUEUE event for @phba vport. This routine
@@ -303,7 +302,7 @@ lpfc_rampup_queue_depth(struct lpfc_vport  *vport,
 }
 
 /**
- * lpfc_ramp_down_queue_handler: WORKER_RAMP_DOWN_QUEUE event handler.
+ * lpfc_ramp_down_queue_handler - WORKER_RAMP_DOWN_QUEUE event handler
  * @phba: The Hba for which this call is being executed.
  *
  * This routine is called to  process WORKER_RAMP_DOWN_QUEUE event for worker
@@ -361,7 +360,7 @@ lpfc_ramp_down_queue_handler(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_ramp_up_queue_handler: WORKER_RAMP_UP_QUEUE event handler.
+ * lpfc_ramp_up_queue_handler - WORKER_RAMP_UP_QUEUE event handler
  * @phba: The Hba for which this call is being executed.
  *
  * This routine is called to  process WORKER_RAMP_UP_QUEUE event for worker
@@ -410,7 +409,7 @@ lpfc_ramp_up_queue_handler(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_scsi_dev_block: set all scsi hosts to block state.
+ * lpfc_scsi_dev_block - set all scsi hosts to block state
  * @phba: Pointer to HBA context object.
  *
  * This function walks vport list and set each SCSI host to block state
@@ -439,7 +438,7 @@ lpfc_scsi_dev_block(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_new_scsi_buf: Scsi buffer allocator.
+ * lpfc_new_scsi_buf - Scsi buffer allocator
  * @vport: The virtual port for which this call being executed.
  *
  * This routine allocates a scsi buffer, which contains all the necessary
@@ -563,7 +562,7 @@ lpfc_new_scsi_buf(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_get_scsi_buf: Get a scsi buffer from lpfc_scsi_buf_list list of Hba.
+ * lpfc_get_scsi_buf - Get a scsi buffer from lpfc_scsi_buf_list list of Hba
  * @phba: The Hba for which this call is being executed.
  *
  * This routine removes a scsi buffer from head of @phba lpfc_scsi_buf_list list
@@ -592,7 +591,7 @@ lpfc_get_scsi_buf(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_release_scsi_buf: Return a scsi buffer back to hba lpfc_scsi_buf_list list.
+ * lpfc_release_scsi_buf - Return a scsi buffer back to hba's lpfc_scsi_buf_list
  * @phba: The Hba for which this call is being executed.
  * @psb: The scsi buffer which is being released.
  *
@@ -611,7 +610,7 @@ lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb)
 }
 
 /**
- * lpfc_scsi_prep_dma_buf: Routine to do DMA mapping for scsi buffer.
+ * lpfc_scsi_prep_dma_buf - Routine to do DMA mapping for scsi buffer
  * @phba: The Hba for which this call is being executed.
  * @lpfc_cmd: The scsi buffer which is going to be mapped.
  *
@@ -823,9 +822,9 @@ lpfc_cmd_blksize(struct scsi_cmnd *sc)
 /**
  * lpfc_get_cmd_dif_parms - Extract DIF parameters from SCSI command
  * @sc:             in: SCSI command
- * @apptagmask      out: app tag mask
- * @apptagval       out: app tag value
- * @reftag          out: ref tag (reference tag)
+ * @apptagmask:     out: app tag mask
+ * @apptagval:      out: app tag value
+ * @reftag:         out: ref tag (reference tag)
  *
  * Description:
  *   Extract DIF paramters from the command if possible.  Otherwise,
@@ -1413,7 +1412,7 @@ out:
 }
 
 /**
- * lpfc_send_scsi_error_event: Posts an event when there is SCSI error.
+ * lpfc_send_scsi_error_event - Posts an event when there is SCSI error
  * @phba: Pointer to hba context object.
  * @vport: Pointer to vport object.
  * @lpfc_cmd: Pointer to lpfc scsi command which reported the error.
@@ -1505,7 +1504,7 @@ lpfc_send_scsi_error_event(struct lpfc_hba *phba, struct lpfc_vport *vport,
 }
 
 /**
- * lpfc_scsi_unprep_dma_buf: Routine to un-map DMA mapping of scatter gather.
+ * lpfc_scsi_unprep_dma_buf - Routine to un-map DMA mapping of scatter gather
  * @phba: The Hba for which this call is being executed.
  * @psb: The scsi buffer which is going to be un-mapped.
  *
@@ -1530,7 +1529,7 @@ lpfc_scsi_unprep_dma_buf(struct lpfc_hba * phba, struct lpfc_scsi_buf * psb)
 }
 
 /**
- * lpfc_handler_fcp_err: FCP response handler.
+ * lpfc_handler_fcp_err - FCP response handler
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
  * @rsp_iocb: The response IOCB which contains FCP error.
@@ -1674,7 +1673,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 }
 
 /**
- * lpfc_scsi_cmd_iocb_cmpl: Scsi cmnd IOCB completion routine.
+ * lpfc_scsi_cmd_iocb_cmpl - Scsi cmnd IOCB completion routine
  * @phba: The Hba for which this call is being executed.
  * @pIocbIn: The command IOCBQ for the scsi cmnd.
  * @pIocbOut: The response IOCBQ for the scsi cmnd .
@@ -1935,7 +1934,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 }
 
 /**
- * lpfc_fcpcmd_to_iocb - copy the fcp_cmd data into the IOCB.
+ * lpfc_fcpcmd_to_iocb - copy the fcp_cmd data into the IOCB
  * @data: A pointer to the immediate command data portion of the IOCB.
  * @fcp_cmnd: The FCP Command that is provided by the SCSI layer.
  *
@@ -1953,7 +1952,7 @@ lpfc_fcpcmd_to_iocb(uint8_t *data, struct fcp_cmnd *fcp_cmnd)
 }
 
 /**
- * lpfc_scsi_prep_cmnd:  Routine to convert scsi cmnd to FCP information unit.
+ * lpfc_scsi_prep_cmnd -  Routine to convert scsi cmnd to FCP information unit
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: The scsi command which needs to send.
  * @pnode: Pointer to lpfc_nodelist.
@@ -2047,7 +2046,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 }
 
 /**
- * lpfc_scsi_prep_task_mgmt_cmnd: Convert scsi TM cmnd to FCP information unit.
+ * lpfc_scsi_prep_task_mgmt_cmnd - Convert scsi TM cmnd to FCP information unit
  * @vport: The virtual port for which this call is being executed.
  * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure.
  * @lun: Logical unit number.
@@ -2110,7 +2109,7 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
 }
 
 /**
- * lpc_taskmgmt_def_cmpl: IOCB completion routine for task management command.
+ * lpfc_taskmgmt_def_cmpl - IOCB completion routine for task management command
  * @phba: The Hba for which this call is being executed.
  * @cmdiocbq: Pointer to lpfc_iocbq data structure.
  * @rspiocbq: Pointer to lpfc_iocbq data structure.
@@ -2131,7 +2130,7 @@ lpfc_tskmgmt_def_cmpl(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_scsi_tgt_reset: Target reset handler.
+ * lpfc_scsi_tgt_reset - Target reset handler
  * @lpfc_cmd: Pointer to lpfc_scsi_buf data structure
  * @vport: The virtual port for which this call is being executed.
  * @tgt_id: Target ID.
@@ -2198,7 +2197,7 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf *lpfc_cmd, struct lpfc_vport *vport,
 }
 
 /**
- * lpfc_info: Info entry point of scsi_host_template data structure.
+ * lpfc_info - Info entry point of scsi_host_template data structure
  * @host: The scsi host for which this call is being executed.
  *
  * This routine provides module information about hba.
@@ -2236,7 +2235,7 @@ lpfc_info(struct Scsi_Host *host)
 }
 
 /**
- * lpfc_poll_rearm_time: Routine to modify fcp_poll timer of hba.
+ * lpfc_poll_rearm_time - Routine to modify fcp_poll timer of hba
  * @phba: The Hba for which this call is being executed.
  *
  * This routine modifies fcp_poll_timer  field of @phba by cfg_poll_tmo.
@@ -2253,7 +2252,7 @@ static __inline__ void lpfc_poll_rearm_timer(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_poll_start_timer: Routine to start fcp_poll_timer of HBA.
+ * lpfc_poll_start_timer - Routine to start fcp_poll_timer of HBA
  * @phba: The Hba for which this call is being executed.
  *
  * This routine starts the fcp_poll_timer of @phba.
@@ -2264,7 +2263,7 @@ void lpfc_poll_start_timer(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_poll_timeout: Restart polling timer.
+ * lpfc_poll_timeout - Restart polling timer
  * @ptr: Map to lpfc_hba data structure pointer.
  *
  * This routine restarts fcp_poll timer, when FCP ring  polling is enable
@@ -2283,8 +2282,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 }
 
 /**
- * lpfc_queuecommand: Queuecommand entry point of Scsi Host Templater data
- * structure.
+ * lpfc_queuecommand - scsi_host_template queuecommand entry point
  * @cmnd: Pointer to scsi_cmnd data structure.
  * @done: Pointer to done routine.
  *
@@ -2450,7 +2448,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 }
 
 /**
- * lpfc_block_error_handler: Routine to block error  handler.
+ * lpfc_block_error_handler - Routine to block error  handler
  * @cmnd: Pointer to scsi_cmnd data structure.
  *
  *  This routine blocks execution till fc_rport state is not FC_PORSTAT_BLCOEKD.
@@ -2472,8 +2470,7 @@ lpfc_block_error_handler(struct scsi_cmnd *cmnd)
 }
 
 /**
- * lpfc_abort_handler: Eh_abort_handler entry point of Scsi Host Template data
- *structure.
+ * lpfc_abort_handler - scsi_host_template eh_abort_handler entry point
  * @cmnd: Pointer to scsi_cmnd data structure.
  *
  * This routine aborts @cmnd pending in base driver.
@@ -2578,8 +2575,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 }
 
 /**
- * lpfc_device_reset_handler: eh_device_reset entry point of Scsi Host Template
- *data structure.
+ * lpfc_device_reset_handler - scsi_host_template eh_device_reset entry point
  * @cmnd: Pointer to scsi_cmnd data structure.
  *
  * This routine does a device reset by sending a TARGET_RESET task management
@@ -2587,7 +2583,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
  *
  * Return code :
  *  0x2003 - Error
- *  0ex2002 - Success
+ *  0x2002 - Success
  **/
 static int
 lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
@@ -2707,8 +2703,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 }
 
 /**
- * lpfc_bus_reset_handler: eh_bus_reset_handler entry point of Scsi Host
- * Template data structure.
+ * lpfc_bus_reset_handler - scsi_host_template eh_bus_reset_handler entry point
  * @cmnd: Pointer to scsi_cmnd data structure.
  *
  * This routine does target reset to all target on @cmnd->device->host.
@@ -2808,8 +2803,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 }
 
 /**
- * lpfc_slave_alloc: slave_alloc entry point of Scsi Host Template data
- * structure.
+ * lpfc_slave_alloc - scsi_host_template slave_alloc entry point
  * @sdev: Pointer to scsi_device.
  *
  * This routine populates the cmds_per_lun count + 2 scsi_bufs into  this host's
@@ -2883,8 +2877,7 @@ lpfc_slave_alloc(struct scsi_device *sdev)
 }
 
 /**
- * lpfc_slave_configure: slave_configure entry point of Scsi Host Templater data
- *  structure.
+ * lpfc_slave_configure - scsi_host_template slave_configure entry point
  * @sdev: Pointer to scsi_device.
  *
  * This routine configures following items
@@ -2925,7 +2918,7 @@ lpfc_slave_configure(struct scsi_device *sdev)
 }
 
 /**
- * lpfc_slave_destroy: slave_destroy entry point of SHT data structure.
+ * lpfc_slave_destroy - slave_destroy entry point of SHT data structure
  * @sdev: Pointer to scsi_device.
  *
  * This routine sets @sdev hostatdata filed to null.


