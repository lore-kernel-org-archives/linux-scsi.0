From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 4/5] lpfc : Correct kdoc syntax errors in
	lpfc_debugfs.c/hbadisc.c/init.c/vport.c
Date: Tue, 16 Dec 2008 11:01:53 -0500
Message-ID: <1229443313.4621.21.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63336 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757445AbYLPQA2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2008 11:00:28 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id mBGG0PN0026219
	for <linux-scsi@vger.kernel.org>; Tue, 16 Dec 2008 08:00:26 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_debugfs.c |   47 ++++++++++++--------------
 lpfc_hbadisc.c |    8 ++--
 lpfc_init.c    |  101 ++++++++++++++++++++++++++++-----------------------------
 lpfc_vport.c   |   10 ++---
 4 files changed, 81 insertions(+), 85 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2008-12-16 09:34:12.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2008-12-16 10:50:41.000000000 -0500
@@ -47,7 +47,7 @@
 #include "lpfc_debugfs.h"
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
-/**
+/*
  * debugfs interface
  *
  * To access this interface the user should:
@@ -62,7 +62,7 @@
  * Debugging services available per vport:
  * discovery_trace
  * This is an ACSII readable file that contains a trace of the last
- * lpfc_debugfs_max_disc_trc events that happened on a specific vport.
+ * lpfc_debugfs_max_disc_trc events that happened on a specific vport
  * See lpfc_debugfs.h for different categories of  discovery events.
  * To enable the discovery trace, the following module parameters must be set:
  * lpfc_debugfs_enable=1         Turns on lpfc debugfs filesystem support
@@ -73,13 +73,12 @@
  *
  * slow_ring_trace
  * This is an ACSII readable file that contains a trace of the last
- * lpfc_debugfs_max_slow_ring_trc events that happened on a specific HBA.
+ * lpfc_debugfs_max_slow_ring_trc events that happened on a specific HBA
  * To enable the slow ring trace, the following module parameters must be set:
  * lpfc_debugfs_enable=1         Turns on lpfc debugfs filesystem support
  * lpfc_debugfs_max_slow_ring_trc=X   Where X is the event trace depth for
  *                               the HBA. X MUST also be a power of 2.
- */
-static int lpfc_debugfs_enable = 1;
+ */static int lpfc_debugfs_enable = 1;
 module_param(lpfc_debugfs_enable, int, 0);
 MODULE_PARM_DESC(lpfc_debugfs_enable, "Enable debugfs services");
 
@@ -127,7 +126,7 @@ static atomic_t lpfc_debugfs_seq_trc_cnt
 static unsigned long lpfc_debugfs_start_time = 0L;
 
 /**
- * lpfc_debugfs_disc_trc_data - Dump discovery logging to a buffer.
+ * lpfc_debugfs_disc_trc_data - Dump discovery logging to a buffer
  * @vport: The vport to gather the log info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -187,7 +186,7 @@ lpfc_debugfs_disc_trc_data(struct lpfc_v
 }
 
 /**
- * lpfc_debugfs_slow_ring_trc_data - Dump slow ring logging to a buffer.
+ * lpfc_debugfs_slow_ring_trc_data - Dump slow ring logging to a buffer
  * @phba: The HBA to gather the log info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -250,7 +249,7 @@ lpfc_debugfs_slow_ring_trc_data(struct l
 static int lpfc_debugfs_last_hbq = -1;
 
 /**
- * lpfc_debugfs_hbqinfo_data - Dump host buffer queue info to a buffer.
+ * lpfc_debugfs_hbqinfo_data - Dump host buffer queue info to a buffer
  * @phba: The HBA to gather host buffer info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -369,7 +368,7 @@ skipit:
 static int lpfc_debugfs_last_hba_slim_off;
 
 /**
- * lpfc_debugfs_dumpHBASlim_data - Dump HBA SLIM info to a buffer.
+ * lpfc_debugfs_dumpHBASlim_data - Dump HBA SLIM info to a buffer
  * @phba: The HBA to gather SLIM info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -426,7 +425,7 @@ lpfc_debugfs_dumpHBASlim_data(struct lpf
 }
 
 /**
- * lpfc_debugfs_dumpHostSlim_data - Dump host SLIM info to a buffer.
+ * lpfc_debugfs_dumpHostSlim_data - Dump host SLIM info to a buffer
  * @phba: The HBA to gather Host SLIM info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -501,7 +500,7 @@ lpfc_debugfs_dumpHostSlim_data(struct lp
 }
 
 /**
- * lpfc_debugfs_nodelist_data - Dump target node list to a buffer.
+ * lpfc_debugfs_nodelist_data - Dump target node list to a buffer
  * @vport: The vport to gather target node info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -599,7 +598,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_v
 #endif
 
 /**
- * lpfc_debugfs_disc_trc - Store discovery trace log.
+ * lpfc_debugfs_disc_trc - Store discovery trace log
  * @vport: The vport to associate this trace string with for retrieval.
  * @mask: Log entry classification.
  * @fmt: Format string to be displayed when dumping the log.
@@ -643,7 +642,7 @@ lpfc_debugfs_disc_trc(struct lpfc_vport 
 }
 
 /**
- * lpfc_debugfs_slow_ring_trc - Store slow ring trace log.
+ * lpfc_debugfs_slow_ring_trc - Store slow ring trace log
  * @phba: The phba to associate this trace string with for retrieval.
  * @fmt: Format string to be displayed when dumping the log.
  * @data1: 1st data parameter to be applied to @fmt.
@@ -682,7 +681,7 @@ lpfc_debugfs_slow_ring_trc(struct lpfc_h
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 /**
- * lpfc_debugfs_disc_trc_open - Open the discovery trace log.
+ * lpfc_debugfs_disc_trc_open - Open the discovery trace log
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -732,7 +731,7 @@ out:
 }
 
 /**
- * lpfc_debugfs_slow_ring_trc_open - Open the Slow Ring trace log.
+ * lpfc_debugfs_slow_ring_trc_open - Open the Slow Ring trace log
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -782,7 +781,7 @@ out:
 }
 
 /**
- * lpfc_debugfs_hbqinfo_open - Open the hbqinfo debugfs buffer.
+ * lpfc_debugfs_hbqinfo_open - Open the hbqinfo debugfs buffer
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -824,7 +823,7 @@ out:
 }
 
 /**
- * lpfc_debugfs_dumpHBASlim_open - Open the Dump HBA SLIM debugfs buffer.
+ * lpfc_debugfs_dumpHBASlim_open - Open the Dump HBA SLIM debugfs buffer
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -866,7 +865,7 @@ out:
 }
 
 /**
- * lpfc_debugfs_dumpHostSlim_open - Open the Dump Host SLIM debugfs buffer.
+ * lpfc_debugfs_dumpHostSlim_open - Open the Dump Host SLIM debugfs buffer
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -993,7 +992,7 @@ lpfc_debugfs_dumpDataDif_write(struct fi
 

 /**
- * lpfc_debugfs_nodelist_open - Open the nodelist debugfs file.
+ * lpfc_debugfs_nodelist_open - Open the nodelist debugfs file
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -1035,7 +1034,7 @@ out:
 }
 
 /**
- * lpfc_debugfs_lseek - Seek through a debugfs file.
+ * lpfc_debugfs_lseek - Seek through a debugfs file
  * @file: The file pointer to seek through.
  * @off: The offset to seek to or the amount to seek by.
  * @whence: Indicates how to seek.
@@ -1073,7 +1072,7 @@ lpfc_debugfs_lseek(struct file *file, lo
 }
 
 /**
- * lpfc_debugfs_read - Read a debugfs file.
+ * lpfc_debugfs_read - Read a debugfs file
  * @file: The file pointer to read from.
  * @buf: The buffer to copy the data to.
  * @nbytes: The number of bytes to read.
@@ -1098,7 +1097,7 @@ lpfc_debugfs_read(struct file *file, cha
 }
 
 /**
- * lpfc_debugfs_release - Release the buffer used to store debugfs file data.
+ * lpfc_debugfs_release - Release the buffer used to store debugfs file data
  * @inode: The inode pointer that contains a vport pointer. (unused)
  * @file: The file pointer that contains the buffer to release.
  *
@@ -1210,7 +1209,7 @@ static atomic_t lpfc_debugfs_hba_count;
 #endif
 
 /**
- * lpfc_debugfs_initialize - Initialize debugfs for a vport.
+ * lpfc_debugfs_initialize - Initialize debugfs for a vport
  * @vport: The vport pointer to initialize.
  *
  * Description:
@@ -1434,7 +1433,7 @@ debug_failed:
 }
 
 /**
- * lpfc_debugfs_terminate -  Tear down debugfs infrastructure for this vport.
+ * lpfc_debugfs_terminate -  Tear down debugfs infrastructure for this vport
  * @vport: The vport pointer to remove from debugfs.
  *
  * Description:
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-12-16 09:34:12.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-12-16 10:50:41.000000000 -0500
@@ -276,7 +276,7 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 }
 
 /**
- * lpfc_alloc_fast_evt: Allocates data structure for posting event.
+ * lpfc_alloc_fast_evt - Allocates data structure for posting event
  * @phba: Pointer to hba context object.
  *
  * This function is called from the functions which need to post
@@ -303,7 +303,7 @@ lpfc_alloc_fast_evt(struct lpfc_hba *phb
 }
 
 /**
- * lpfc_free_fast_evt: Frees event data structure.
+ * lpfc_free_fast_evt - Frees event data structure
  * @phba: Pointer to hba context object.
  * @evt:  Event object which need to be freed.
  *
@@ -319,7 +319,7 @@ lpfc_free_fast_evt(struct lpfc_hba *phba
 }
 
 /**
- * lpfc_send_fastpath_evt: Posts events generated from fast path.
+ * lpfc_send_fastpath_evt - Posts events generated from fast path
  * @phba: Pointer to hba context object.
  * @evtp: Event data structure.
  *
@@ -1858,7 +1858,7 @@ lpfc_disable_node(struct lpfc_vport *vpo
 				NLP_STE_UNUSED_NODE);
 }
 /**
- * lpfc_initialize_node: Initialize all fields of node object.
+ * lpfc_initialize_node - Initialize all fields of node object
  * @vport: Pointer to Virtual Port object.
  * @ndlp: Pointer to FC node object.
  * @did: FC_ID of the node.
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-12-16 09:34:12.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-12-16 10:50:41.000000000 -0500
@@ -60,7 +60,7 @@ static struct scsi_transport_template *l
 static DEFINE_IDR(lpfc_hba_index);
 
 /**
- * lpfc_config_port_prep: Perform lpfc initialization prior to config port.
+ * lpfc_config_port_prep - Perform lpfc initialization prior to config port
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine will do LPFC initialization prior to issuing the CONFIG_PORT
@@ -221,7 +221,7 @@ out_free_mbox:
 }
 
 /**
- * lpfc_config_async_cmpl: Completion handler for config async event mbox cmd.
+ * lpfc_config_async_cmpl - Completion handler for config async event mbox cmd
  * @phba: pointer to lpfc hba data structure.
  * @pmboxq: pointer to the driver internal queue element for mailbox command.
  *
@@ -242,8 +242,7 @@ lpfc_config_async_cmpl(struct lpfc_hba *
 }
 
 /**
- * lpfc_dump_wakeup_param_cmpl: Completion handler for dump memory mailbox
- *     command used for getting wake up parameters.
+ * lpfc_dump_wakeup_param_cmpl - dump memory mailbox command completion handler
  * @phba: pointer to lpfc hba data structure.
  * @pmboxq: pointer to the driver internal queue element for mailbox command.
  *
@@ -287,7 +286,7 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_
 }
 
 /**
- * lpfc_config_port_post: Perform lpfc initialization after config port.
+ * lpfc_config_port_post - Perform lpfc initialization after config port
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine will do LPFC initialization after the CONFIG_PORT mailbox
@@ -551,7 +550,7 @@ lpfc_config_port_post(struct lpfc_hba *p
 }
 
 /**
- * lpfc_hba_down_prep: Perform lpfc uninitialization prior to HBA reset.
+ * lpfc_hba_down_prep - Perform lpfc uninitialization prior to HBA reset
  * @phba: pointer to lpfc HBA data structure.
  *
  * This routine will do LPFC uninitialization before the HBA is reset when
@@ -583,7 +582,7 @@ lpfc_hba_down_prep(struct lpfc_hba *phba
 }
 
 /**
- * lpfc_hba_down_post: Perform lpfc uninitialization after HBA reset.
+ * lpfc_hba_down_post - Perform lpfc uninitialization after HBA reset
  * @phba: pointer to lpfc HBA data structure.
  *
  * This routine will do uninitialization after the HBA is reset when bring
@@ -652,7 +651,7 @@ lpfc_hba_down_post(struct lpfc_hba *phba
 }
 
 /**
- * lpfc_hb_timeout: The HBA-timer timeout handler.
+ * lpfc_hb_timeout - The HBA-timer timeout handler
  * @ptr: unsigned long holds the pointer to lpfc hba data structure.
  *
  * This is the HBA-timer timeout handler registered to the lpfc driver. When
@@ -686,7 +685,7 @@ lpfc_hb_timeout(unsigned long ptr)
 }
 
 /**
- * lpfc_hb_mbox_cmpl: The lpfc heart-beat mailbox command callback function.
+ * lpfc_hb_mbox_cmpl - The lpfc heart-beat mailbox command callback function
  * @phba: pointer to lpfc hba data structure.
  * @pmboxq: pointer to the driver internal queue element for mailbox command.
  *
@@ -721,7 +720,7 @@ lpfc_hb_mbox_cmpl(struct lpfc_hba * phba
 }
 
 /**
- * lpfc_hb_timeout_handler: The HBA-timer timeout handler.
+ * lpfc_hb_timeout_handler - The HBA-timer timeout handler
  * @phba: pointer to lpfc hba data structure.
  *
  * This is the actual HBA-timer timeout handler to be invoked by the worker
@@ -830,7 +829,7 @@ lpfc_hb_timeout_handler(struct lpfc_hba 
 }
 
 /**
- * lpfc_offline_eratt: Bring lpfc offline on hardware error attention.
+ * lpfc_offline_eratt - Bring lpfc offline on hardware error attention
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is called to bring the HBA offline when HBA hardware error
@@ -857,7 +856,7 @@ lpfc_offline_eratt(struct lpfc_hba *phba
 }
 
 /**
- * lpfc_handle_eratt: The HBA hardware error handler.
+ * lpfc_handle_eratt - The HBA hardware error handler
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to handle the following HBA hardware error
@@ -976,7 +975,7 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_handle_latt: The HBA link event handler.
+ * lpfc_handle_latt - The HBA link event handler
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked from the worker thread to handle a HBA host
@@ -1063,7 +1062,7 @@ lpfc_handle_latt_err_exit:
 }
 
 /**
- * lpfc_parse_vpd: Parse VPD (Vital Product Data).
+ * lpfc_parse_vpd - Parse VPD (Vital Product Data)
  * @phba: pointer to lpfc hba data structure.
  * @vpd: pointer to the vital product data.
  * @len: length of the vital product data in bytes.
@@ -1213,7 +1212,7 @@ lpfc_parse_vpd(struct lpfc_hba *phba, ui
 }
 
 /**
- * lpfc_get_hba_model_desc: Retrieve HBA device model name and description.
+ * lpfc_get_hba_model_desc - Retrieve HBA device model name and description
  * @phba: pointer to lpfc hba data structure.
  * @mdp: pointer to the data structure to hold the derived model name.
  * @descp: pointer to the data structure to hold the derived description.
@@ -1392,7 +1391,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 }
 
 /**
- * lpfc_post_buffer: Post IOCB(s) with DMA buffer descriptor(s) to a IOCB ring.
+ * lpfc_post_buffer - Post IOCB(s) with DMA buffer descriptor(s) to a IOCB ring
  * @phba: pointer to lpfc hba data structure.
  * @pring: pointer to a IOCB ring.
  * @cnt: the number of IOCBs to be posted to the IOCB ring.
@@ -1493,7 +1492,7 @@ lpfc_post_buffer(struct lpfc_hba *phba, 
 }
 
 /**
- * lpfc_post_rcv_buf: Post the initial receive IOCB buffers to ELS ring.
+ * lpfc_post_rcv_buf - Post the initial receive IOCB buffers to ELS ring
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine posts initial receive IOCB buffers to the ELS ring. The
@@ -1518,7 +1517,7 @@ lpfc_post_rcv_buf(struct lpfc_hba *phba)
 #define S(N,V) (((V)<<(N))|((V)>>(32-(N))))
 
 /**
- * lpfc_sha_init: Set up initial array of hash table entries.
+ * lpfc_sha_init - Set up initial array of hash table entries
  * @HashResultPointer: pointer to an array as hash table.
  *
  * This routine sets up the initial values to the array of hash table entries
@@ -1535,7 +1534,7 @@ lpfc_sha_init(uint32_t * HashResultPoint
 }
 
 /**
- * lpfc_sha_iterate: Iterate initial hash table with the working hash table.
+ * lpfc_sha_iterate - Iterate initial hash table with the working hash table
  * @HashResultPointer: pointer to an initial/result hash table.
  * @HashWorkingPointer: pointer to an working hash table.
  *
@@ -1592,7 +1591,7 @@ lpfc_sha_iterate(uint32_t * HashResultPo
 }
 
 /**
- * lpfc_challenge_key: Create challenge key based on WWPN of the HBA.
+ * lpfc_challenge_key - Create challenge key based on WWPN of the HBA
  * @RandomChallenge: pointer to the entry of host challenge random number array.
  * @HashWorking: pointer to the entry of the working hash array.
  *
@@ -1608,7 +1607,7 @@ lpfc_challenge_key(uint32_t * RandomChal
 }
 
 /**
- * lpfc_hba_init: Perform special handling for LC HBA initialization.
+ * lpfc_hba_init - Perform special handling for LC HBA initialization
  * @phba: pointer to lpfc hba data structure.
  * @hbainit: pointer to an array of unsigned 32-bit integers.
  *
@@ -1637,7 +1636,7 @@ lpfc_hba_init(struct lpfc_hba *phba, uin
 }
 
 /**
- * lpfc_cleanup: Performs vport cleanups before deleting a vport.
+ * lpfc_cleanup - Performs vport cleanups before deleting a vport
  * @vport: pointer to a virtual N_Port data structure.
  *
  * This routine performs the necessary cleanups before deleting the @vport.
@@ -1724,7 +1723,7 @@ lpfc_cleanup(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_stop_vport_timers: Stop all the timers associated with a vport.
+ * lpfc_stop_vport_timers - Stop all the timers associated with a vport
  * @vport: pointer to a virtual N_Port data structure.
  *
  * This routine stops all the timers associated with a @vport. This function
@@ -1741,7 +1740,7 @@ lpfc_stop_vport_timers(struct lpfc_vport
 }
 
 /**
- * lpfc_stop_phba_timers: Stop all the timers associated with an HBA.
+ * lpfc_stop_phba_timers - Stop all the timers associated with an HBA
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine stops all the timers associated with a HBA. This function is
@@ -1761,7 +1760,7 @@ lpfc_stop_phba_timers(struct lpfc_hba *p
 }
 
 /**
- * lpfc_block_mgmt_io: Mark a HBA's management interface as blocked.
+ * lpfc_block_mgmt_io - Mark a HBA's management interface as blocked
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine marks a HBA's management interface as blocked. Once the HBA's
@@ -1781,7 +1780,7 @@ lpfc_block_mgmt_io(struct lpfc_hba * phb
 }
 
 /**
- * lpfc_online: Initialize and bring a HBA online.
+ * lpfc_online - Initialize and bring a HBA online
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine initializes the HBA and brings a HBA online. During this
@@ -1838,7 +1837,7 @@ lpfc_online(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_unblock_mgmt_io: Mark a HBA's management interface to be not blocked.
+ * lpfc_unblock_mgmt_io - Mark a HBA's management interface to be not blocked
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine marks a HBA's management interface as not blocked. Once the
@@ -1859,7 +1858,7 @@ lpfc_unblock_mgmt_io(struct lpfc_hba * p
 }
 
 /**
- * lpfc_offline_prep: Prepare a HBA to be brought offline.
+ * lpfc_offline_prep - Prepare a HBA to be brought offline
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to prepare a HBA to be brought offline. It performs
@@ -1916,7 +1915,7 @@ lpfc_offline_prep(struct lpfc_hba * phba
 }
 
 /**
- * lpfc_offline: Bring a HBA offline.
+ * lpfc_offline - Bring a HBA offline
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine actually brings a HBA offline. It stops all the timers
@@ -1961,7 +1960,7 @@ lpfc_offline(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_scsi_free: Free all the SCSI buffers and IOCBs from driver lists.
+ * lpfc_scsi_free - Free all the SCSI buffers and IOCBs from driver lists
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is to free all the SCSI buffers and IOCBs from the driver
@@ -2000,7 +1999,7 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_create_port: Create an FC port.
+ * lpfc_create_port - Create an FC port
  * @phba: pointer to lpfc hba data structure.
  * @instance: a unique integer ID to this FC port.
  * @dev: pointer to the device data structure.
@@ -2090,7 +2089,7 @@ out:
 }
 
 /**
- * destroy_port: Destroy an FC port.
+ * destroy_port -  destroy an FC port
  * @vport: pointer to an lpfc virtual N_Port data structure.
  *
  * This routine destroys a FC port from the upper layer protocol. All the
@@ -2115,7 +2114,7 @@ destroy_port(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_get_instance: Get a unique integer ID.
+ * lpfc_get_instance - Get a unique integer ID
  *
  * This routine allocates a unique integer ID from lpfc_hba_index pool. It
  * uses the kernel idr facility to perform the task.
@@ -2138,7 +2137,7 @@ lpfc_get_instance(void)
 }
 
 /**
- * lpfc_scan_finished: method for SCSI layer to detect whether scan is done.
+ * lpfc_scan_finished - method for SCSI layer to detect whether scan is done
  * @shost: pointer to SCSI host data structure.
  * @time: elapsed time of the scan in jiffies.
  *
@@ -2196,7 +2195,7 @@ finished:
 }
 
 /**
- * lpfc_host_attrib_init: Initialize SCSI host attributes on a FC port.
+ * lpfc_host_attrib_init - Initialize SCSI host attributes on a FC port
  * @shost: pointer to SCSI host data structure.
  *
  * This routine initializes a given SCSI host attributes on a FC port. The
@@ -2251,7 +2250,7 @@ void lpfc_host_attrib_init(struct Scsi_H
 }
 
 /**
- * lpfc_enable_msix: Enable MSI-X interrupt mode.
+ * lpfc_enable_msix - Enable MSI-X interrupt mode
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI-X interrupt vectors. The kernel
@@ -2365,7 +2364,7 @@ msi_fail_out:
 }
 
 /**
- * lpfc_disable_msix: Disable MSI-X interrupt mode.
+ * lpfc_disable_msix - Disable MSI-X interrupt mode
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to release the MSI-X vectors and then disable the
@@ -2384,7 +2383,7 @@ lpfc_disable_msix(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_enable_msi: Enable MSI interrupt mode.
+ * lpfc_enable_msi - Enable MSI interrupt mode
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI interrupt mode. The kernel
@@ -2422,7 +2421,7 @@ lpfc_enable_msi(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_disable_msi: Disable MSI interrupt mode.
+ * lpfc_disable_msi - Disable MSI interrupt mode
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to disable the MSI interrupt mode. The driver
@@ -2440,7 +2439,7 @@ lpfc_disable_msi(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_log_intr_mode: Log the active interrupt mode
+ * lpfc_log_intr_mode - Log the active interrupt mode
  * @phba: pointer to lpfc hba data structure.
  * @intr_mode: active interrupt mode adopted.
  *
@@ -2489,7 +2488,7 @@ lpfc_stop_port(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_enable_intr: Enable device interrupt.
+ * lpfc_enable_intr - Enable device interrupt
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable device interrupt and associate driver's
@@ -2546,7 +2545,7 @@ lpfc_enable_intr(struct lpfc_hba *phba, 
 }
 
 /**
- * lpfc_disable_intr: Disable device interrupt.
+ * lpfc_disable_intr - Disable device interrupt
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to disable device interrupt and disassociate the
@@ -2573,7 +2572,7 @@ lpfc_disable_intr(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_pci_probe_one: lpfc PCI probe func to register device to PCI subsystem.
+ * lpfc_pci_probe_one - lpfc PCI probe func to register device to PCI subsystem
  * @pdev: pointer to PCI device
  * @pid: pointer to PCI device identifier
  *
@@ -3009,7 +3008,7 @@ out:
 }
 
 /**
- * lpfc_pci_remove_one: lpfc PCI func to unregister device from PCI subsystem.
+ * lpfc_pci_remove_one - lpfc PCI func to unregister device from PCI subsystem
  * @pdev: pointer to PCI device
  *
  * This routine is to be registered to the kernel's PCI subsystem. When an
@@ -3094,7 +3093,7 @@ lpfc_pci_remove_one(struct pci_dev *pdev
 }
 
 /**
- * lpfc_pci_suspend_one: lpfc PCI func to suspend device for power management.
+ * lpfc_pci_suspend_one - lpfc PCI func to suspend device for power management
  * @pdev: pointer to PCI device
  * @msg: power management message
  *
@@ -3138,7 +3137,7 @@ lpfc_pci_suspend_one(struct pci_dev *pde
 }
 
 /**
- * lpfc_pci_resume_one: lpfc PCI func to resume device for power management.
+ * lpfc_pci_resume_one - lpfc PCI func to resume device for power management
  * @pdev: pointer to PCI device
  *
  * This routine is to be registered to the kernel's PCI subsystem to support
@@ -3203,7 +3202,7 @@ lpfc_pci_resume_one(struct pci_dev *pdev
 }
 
 /**
- * lpfc_io_error_detected: Driver method for handling PCI I/O error detected.
+ * lpfc_io_error_detected - Driver method for handling PCI I/O error detected
  * @pdev: pointer to PCI device.
  * @state: the current PCI connection state.
  *
@@ -3253,7 +3252,7 @@ static pci_ers_result_t lpfc_io_error_de
 }
 
 /**
- * lpfc_io_slot_reset: Restart a PCI device from scratch.
+ * lpfc_io_slot_reset - Restart a PCI device from scratch
  * @pdev: pointer to PCI device.
  *
  * This routine is registered to the PCI subsystem for error handling. This is
@@ -3312,7 +3311,7 @@ static pci_ers_result_t lpfc_io_slot_res
 }
 
 /**
- * lpfc_io_resume: Resume PCI I/O operation.
+ * lpfc_io_resume - Resume PCI I/O operation
  * @pdev: pointer to PCI device
  *
  * This routine is registered to the PCI subsystem for error handling. It is
@@ -3425,7 +3424,7 @@ static struct pci_driver lpfc_driver = {
 };
 
 /**
- * lpfc_init: lpfc module initialization routine.
+ * lpfc_init - lpfc module initialization routine
  *
  * This routine is to be invoked when the lpfc module is loaded into the
  * kernel. The special kernel macro module_init() is used to indicate the
@@ -3471,7 +3470,7 @@ lpfc_init(void)
 }
 
 /**
- * lpfc_exit: lpfc module removal routine.
+ * lpfc_exit - lpfc module removal routine
  *
  * This routine is invoked when the lpfc module is removed from the kernel.
  * The special kernel macro module_exit() is used to indicate the role of
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2008-12-16 09:34:12.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2008-12-16 10:50:41.000000000 -0500
@@ -206,7 +206,7 @@ lpfc_unique_wwpn(struct lpfc_hba *phba, 
 }
 
 /**
- * lpfc_discovery_wait: Wait for driver discovery to quiesce.
+ * lpfc_discovery_wait - Wait for driver discovery to quiesce
  * @vport: The virtual port for which this call is being executed.
  *
  * This driver calls this routine specifically from lpfc_vport_delete
@@ -741,7 +741,7 @@ lpfc_destroy_vport_work_array(struct lpf
 

 /**
- * lpfc_vport_reset_stat_data: Reset the statistical data for the vport.
+ * lpfc_vport_reset_stat_data - Reset the statistical data for the vport
  * @vport: Pointer to vport object.
  *
  * This function resets the statistical data for the vport. This function
@@ -763,8 +763,7 @@ lpfc_vport_reset_stat_data(struct lpfc_v
 

 /**
- * lpfc_alloc_bucket: Allocate data buffer required for collecting
- *  statistical data.
+ * lpfc_alloc_bucket - Allocate data buffer required for statistical data
  * @vport: Pointer to vport object.
  *
  * This function allocates data buffer required for all the FC
@@ -797,8 +796,7 @@ lpfc_alloc_bucket(struct lpfc_vport *vpo
 }
 
 /**
- * lpfc_free_bucket: Free data buffer required for collecting
- *  statistical data.
+ * lpfc_free_bucket - Free data buffer required for statistical data
  * @vport: Pointer to vport object.
  *
  * Th function frees statistical data buffer of all the FC


