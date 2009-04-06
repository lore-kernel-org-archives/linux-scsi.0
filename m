From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 4/7] lpfc 8.3.1 : Fix up kernel-doc function comments (Take
	2) - Part 4 of 5
Date: Mon, 6 Apr 2009 18:47:47 -0400
Message-ID: <1239058067.2344.27.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:43033 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbZDFWrz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 18:47:55 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n36MlrIN017055
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 15:47:54 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix up kernel-doc function comments (Take 2) - Part 4 of 5

This patch cleans up the kernel-doc formatting in:
lpfc_debugfs.c
lpfc_hbadisc.c
lpfc_init.c
lpfc_vport.c

Signed-off-by: James Smart <James.Smart@emulex.com>
---

 drivers/scsi/lpfc/lpfc_debugfs.c |   40 ++++++++-------
 drivers/scsi/lpfc/lpfc_hbadisc.c |    8 ++-
 drivers/scsi/lpfc/lpfc_init.c    |  101 +++++++++++++++++++-------------------
 drivers/scsi/lpfc/lpfc_vport.c   |   10 ++--
 4 files changed, 78 insertions(+), 81 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -47,7 +47,7 @@
 #include "lpfc_debugfs.h"
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
-/**
+/*
  * debugfs interface
  *
  * To access this interface the user should:
@@ -127,7 +127,7 @@ static atomic_t lpfc_debugfs_seq_trc_cnt = ATOMIC_INIT(0);
 static unsigned long lpfc_debugfs_start_time = 0L;
 
 /**
- * lpfc_debugfs_disc_trc_data - Dump discovery logging to a buffer.
+ * lpfc_debugfs_disc_trc_data - Dump discovery logging to a buffer
  * @vport: The vport to gather the log info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -187,7 +187,7 @@ lpfc_debugfs_disc_trc_data(struct lpfc_vport *vport, char *buf, int size)
 }
 
 /**
- * lpfc_debugfs_slow_ring_trc_data - Dump slow ring logging to a buffer.
+ * lpfc_debugfs_slow_ring_trc_data - Dump slow ring logging to a buffer
  * @phba: The HBA to gather the log info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -250,7 +250,7 @@ lpfc_debugfs_slow_ring_trc_data(struct lpfc_hba *phba, char *buf, int size)
 static int lpfc_debugfs_last_hbq = -1;
 
 /**
- * lpfc_debugfs_hbqinfo_data - Dump host buffer queue info to a buffer.
+ * lpfc_debugfs_hbqinfo_data - Dump host buffer queue info to a buffer
  * @phba: The HBA to gather host buffer info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -369,7 +369,7 @@ skipit:
 static int lpfc_debugfs_last_hba_slim_off;
 
 /**
- * lpfc_debugfs_dumpHBASlim_data - Dump HBA SLIM info to a buffer.
+ * lpfc_debugfs_dumpHBASlim_data - Dump HBA SLIM info to a buffer
  * @phba: The HBA to gather SLIM info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -426,7 +426,7 @@ lpfc_debugfs_dumpHBASlim_data(struct lpfc_hba *phba, char *buf, int size)
 }
 
 /**
- * lpfc_debugfs_dumpHostSlim_data - Dump host SLIM info to a buffer.
+ * lpfc_debugfs_dumpHostSlim_data - Dump host SLIM info to a buffer
  * @phba: The HBA to gather Host SLIM info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -501,7 +501,7 @@ lpfc_debugfs_dumpHostSlim_data(struct lpfc_hba *phba, char *buf, int size)
 }
 
 /**
- * lpfc_debugfs_nodelist_data - Dump target node list to a buffer.
+ * lpfc_debugfs_nodelist_data - Dump target node list to a buffer
  * @vport: The vport to gather target node info from.
  * @buf: The buffer to dump log into.
  * @size: The maximum amount of data to process.
@@ -599,7 +599,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 #endif
 
 /**
- * lpfc_debugfs_disc_trc - Store discovery trace log.
+ * lpfc_debugfs_disc_trc - Store discovery trace log
  * @vport: The vport to associate this trace string with for retrieval.
  * @mask: Log entry classification.
  * @fmt: Format string to be displayed when dumping the log.
@@ -643,7 +643,7 @@ lpfc_debugfs_disc_trc(struct lpfc_vport *vport, int mask, char *fmt,
 }
 
 /**
- * lpfc_debugfs_slow_ring_trc - Store slow ring trace log.
+ * lpfc_debugfs_slow_ring_trc - Store slow ring trace log
  * @phba: The phba to associate this trace string with for retrieval.
  * @fmt: Format string to be displayed when dumping the log.
  * @data1: 1st data parameter to be applied to @fmt.
@@ -682,7 +682,7 @@ lpfc_debugfs_slow_ring_trc(struct lpfc_hba *phba, char *fmt,
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 /**
- * lpfc_debugfs_disc_trc_open - Open the discovery trace log.
+ * lpfc_debugfs_disc_trc_open - Open the discovery trace log
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -732,7 +732,7 @@ out:
 }
 
 /**
- * lpfc_debugfs_slow_ring_trc_open - Open the Slow Ring trace log.
+ * lpfc_debugfs_slow_ring_trc_open - Open the Slow Ring trace log
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -782,7 +782,7 @@ out:
 }
 
 /**
- * lpfc_debugfs_hbqinfo_open - Open the hbqinfo debugfs buffer.
+ * lpfc_debugfs_hbqinfo_open - Open the hbqinfo debugfs buffer
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -824,7 +824,7 @@ out:
 }
 
 /**
- * lpfc_debugfs_dumpHBASlim_open - Open the Dump HBA SLIM debugfs buffer.
+ * lpfc_debugfs_dumpHBASlim_open - Open the Dump HBA SLIM debugfs buffer
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -866,7 +866,7 @@ out:
 }
 
 /**
- * lpfc_debugfs_dumpHostSlim_open - Open the Dump Host SLIM debugfs buffer.
+ * lpfc_debugfs_dumpHostSlim_open - Open the Dump Host SLIM debugfs buffer
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -993,7 +993,7 @@ lpfc_debugfs_dumpDataDif_write(struct file *file, const char __user *buf,
 

 /**
- * lpfc_debugfs_nodelist_open - Open the nodelist debugfs file.
+ * lpfc_debugfs_nodelist_open - Open the nodelist debugfs file
  * @inode: The inode pointer that contains a vport pointer.
  * @file: The file pointer to attach the log output.
  *
@@ -1035,7 +1035,7 @@ out:
 }
 
 /**
- * lpfc_debugfs_lseek - Seek through a debugfs file.
+ * lpfc_debugfs_lseek - Seek through a debugfs file
  * @file: The file pointer to seek through.
  * @off: The offset to seek to or the amount to seek by.
  * @whence: Indicates how to seek.
@@ -1073,7 +1073,7 @@ lpfc_debugfs_lseek(struct file *file, loff_t off, int whence)
 }
 
 /**
- * lpfc_debugfs_read - Read a debugfs file.
+ * lpfc_debugfs_read - Read a debugfs file
  * @file: The file pointer to read from.
  * @buf: The buffer to copy the data to.
  * @nbytes: The number of bytes to read.
@@ -1098,7 +1098,7 @@ lpfc_debugfs_read(struct file *file, char __user *buf,
 }
 
 /**
- * lpfc_debugfs_release - Release the buffer used to store debugfs file data.
+ * lpfc_debugfs_release - Release the buffer used to store debugfs file data
  * @inode: The inode pointer that contains a vport pointer. (unused)
  * @file: The file pointer that contains the buffer to release.
  *
@@ -1210,7 +1210,7 @@ static atomic_t lpfc_debugfs_hba_count;
 #endif
 
 /**
- * lpfc_debugfs_initialize - Initialize debugfs for a vport.
+ * lpfc_debugfs_initialize - Initialize debugfs for a vport
  * @vport: The vport pointer to initialize.
  *
  * Description:
@@ -1434,7 +1434,7 @@ debug_failed:
 }
 
 /**
- * lpfc_debugfs_terminate -  Tear down debugfs infrastructure for this vport.
+ * lpfc_debugfs_terminate -  Tear down debugfs infrastructure for this vport
  * @vport: The vport pointer to remove from debugfs.
  *
  * Description:
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -276,7 +276,7 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 }
 
 /**
- * lpfc_alloc_fast_evt: Allocates data structure for posting event.
+ * lpfc_alloc_fast_evt - Allocates data structure for posting event
  * @phba: Pointer to hba context object.
  *
  * This function is called from the functions which need to post
@@ -303,7 +303,7 @@ lpfc_alloc_fast_evt(struct lpfc_hba *phba) {
 }
 
 /**
- * lpfc_free_fast_evt: Frees event data structure.
+ * lpfc_free_fast_evt - Frees event data structure
  * @phba: Pointer to hba context object.
  * @evt:  Event object which need to be freed.
  *
@@ -319,7 +319,7 @@ lpfc_free_fast_evt(struct lpfc_hba *phba,
 }
 
 /**
- * lpfc_send_fastpath_evt: Posts events generated from fast path.
+ * lpfc_send_fastpath_evt - Posts events generated from fast path
  * @phba: Pointer to hba context object.
  * @evtp: Event data structure.
  *
@@ -1858,7 +1858,7 @@ lpfc_disable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				NLP_STE_UNUSED_NODE);
 }
 /**
- * lpfc_initialize_node: Initialize all fields of node object.
+ * lpfc_initialize_node - Initialize all fields of node object
  * @vport: Pointer to Virtual Port object.
  * @ndlp: Pointer to FC node object.
  * @did: FC_ID of the node.
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -60,7 +60,7 @@ static struct scsi_transport_template *lpfc_vport_transport_template = NULL;
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
@@ -242,8 +242,7 @@ lpfc_config_async_cmpl(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq)
 }
 
 /**
- * lpfc_dump_wakeup_param_cmpl: Completion handler for dump memory mailbox
- *     command used for getting wake up parameters.
+ * lpfc_dump_wakeup_param_cmpl - dump memory mailbox command completion handler
  * @phba: pointer to lpfc hba data structure.
  * @pmboxq: pointer to the driver internal queue element for mailbox command.
  *
@@ -287,7 +286,7 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 }
 
 /**
- * lpfc_config_port_post: Perform lpfc initialization after config port.
+ * lpfc_config_port_post - Perform lpfc initialization after config port
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine will do LPFC initialization after the CONFIG_PORT mailbox
@@ -551,7 +550,7 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_hba_down_prep: Perform lpfc uninitialization prior to HBA reset.
+ * lpfc_hba_down_prep - Perform lpfc uninitialization prior to HBA reset
  * @phba: pointer to lpfc HBA data structure.
  *
  * This routine will do LPFC uninitialization before the HBA is reset when
@@ -583,7 +582,7 @@ lpfc_hba_down_prep(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_hba_down_post: Perform lpfc uninitialization after HBA reset.
+ * lpfc_hba_down_post - Perform lpfc uninitialization after HBA reset
  * @phba: pointer to lpfc HBA data structure.
  *
  * This routine will do uninitialization after the HBA is reset when bring
@@ -652,7 +651,7 @@ lpfc_hba_down_post(struct lpfc_hba *phba)
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
@@ -721,7 +720,7 @@ lpfc_hb_mbox_cmpl(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq)
 }
 
 /**
- * lpfc_hb_timeout_handler: The HBA-timer timeout handler.
+ * lpfc_hb_timeout_handler - The HBA-timer timeout handler
  * @phba: pointer to lpfc hba data structure.
  *
  * This is the actual HBA-timer timeout handler to be invoked by the worker
@@ -830,7 +829,7 @@ lpfc_hb_timeout_handler(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_offline_eratt: Bring lpfc offline on hardware error attention.
+ * lpfc_offline_eratt - Bring lpfc offline on hardware error attention
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is called to bring the HBA offline when HBA hardware error
@@ -857,7 +856,7 @@ lpfc_offline_eratt(struct lpfc_hba *phba)
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
@@ -1213,7 +1212,7 @@ lpfc_parse_vpd(struct lpfc_hba *phba, uint8_t *vpd, int len)
 }
 
 /**
- * lpfc_get_hba_model_desc: Retrieve HBA device model name and description.
+ * lpfc_get_hba_model_desc - Retrieve HBA device model name and description
  * @phba: pointer to lpfc hba data structure.
  * @mdp: pointer to the data structure to hold the derived model name.
  * @descp: pointer to the data structure to hold the derived description.
@@ -1392,7 +1391,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 }
 
 /**
- * lpfc_post_buffer: Post IOCB(s) with DMA buffer descriptor(s) to a IOCB ring.
+ * lpfc_post_buffer - Post IOCB(s) with DMA buffer descriptor(s) to a IOCB ring
  * @phba: pointer to lpfc hba data structure.
  * @pring: pointer to a IOCB ring.
  * @cnt: the number of IOCBs to be posted to the IOCB ring.
@@ -1493,7 +1492,7 @@ lpfc_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cnt)
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
@@ -1535,7 +1534,7 @@ lpfc_sha_init(uint32_t * HashResultPointer)
 }
 
 /**
- * lpfc_sha_iterate: Iterate initial hash table with the working hash table.
+ * lpfc_sha_iterate - Iterate initial hash table with the working hash table
  * @HashResultPointer: pointer to an initial/result hash table.
  * @HashWorkingPointer: pointer to an working hash table.
  *
@@ -1592,7 +1591,7 @@ lpfc_sha_iterate(uint32_t * HashResultPointer, uint32_t * HashWorkingPointer)
 }
 
 /**
- * lpfc_challenge_key: Create challenge key based on WWPN of the HBA.
+ * lpfc_challenge_key - Create challenge key based on WWPN of the HBA
  * @RandomChallenge: pointer to the entry of host challenge random number array.
  * @HashWorking: pointer to the entry of the working hash array.
  *
@@ -1608,7 +1607,7 @@ lpfc_challenge_key(uint32_t * RandomChallenge, uint32_t * HashWorking)
 }
 
 /**
- * lpfc_hba_init: Perform special handling for LC HBA initialization.
+ * lpfc_hba_init - Perform special handling for LC HBA initialization
  * @phba: pointer to lpfc hba data structure.
  * @hbainit: pointer to an array of unsigned 32-bit integers.
  *
@@ -1637,7 +1636,7 @@ lpfc_hba_init(struct lpfc_hba *phba, uint32_t *hbainit)
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
@@ -1741,7 +1740,7 @@ lpfc_stop_vport_timers(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_stop_phba_timers: Stop all the timers associated with an HBA.
+ * lpfc_stop_phba_timers - Stop all the timers associated with an HBA
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine stops all the timers associated with a HBA. This function is
@@ -1761,7 +1760,7 @@ lpfc_stop_phba_timers(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_block_mgmt_io: Mark a HBA's management interface as blocked.
+ * lpfc_block_mgmt_io - Mark a HBA's management interface as blocked
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine marks a HBA's management interface as blocked. Once the HBA's
@@ -1781,7 +1780,7 @@ lpfc_block_mgmt_io(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_online: Initialize and bring a HBA online.
+ * lpfc_online - Initialize and bring a HBA online
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine initializes the HBA and brings a HBA online. During this
@@ -1839,7 +1838,7 @@ lpfc_online(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_unblock_mgmt_io: Mark a HBA's management interface to be not blocked.
+ * lpfc_unblock_mgmt_io - Mark a HBA's management interface to be not blocked
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine marks a HBA's management interface as not blocked. Once the
@@ -1860,7 +1859,7 @@ lpfc_unblock_mgmt_io(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_offline_prep: Prepare a HBA to be brought offline.
+ * lpfc_offline_prep - Prepare a HBA to be brought offline
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to prepare a HBA to be brought offline. It performs
@@ -1917,7 +1916,7 @@ lpfc_offline_prep(struct lpfc_hba * phba)
 }
 
 /**
- * lpfc_offline: Bring a HBA offline.
+ * lpfc_offline - Bring a HBA offline
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine actually brings a HBA offline. It stops all the timers
@@ -1962,7 +1961,7 @@ lpfc_offline(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_scsi_free: Free all the SCSI buffers and IOCBs from driver lists.
+ * lpfc_scsi_free - Free all the SCSI buffers and IOCBs from driver lists
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is to free all the SCSI buffers and IOCBs from the driver
@@ -2001,7 +2000,7 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_create_port: Create an FC port.
+ * lpfc_create_port - Create an FC port
  * @phba: pointer to lpfc hba data structure.
  * @instance: a unique integer ID to this FC port.
  * @dev: pointer to the device data structure.
@@ -2091,7 +2090,7 @@ out:
 }
 
 /**
- * destroy_port: Destroy an FC port.
+ * destroy_port -  destroy an FC port
  * @vport: pointer to an lpfc virtual N_Port data structure.
  *
  * This routine destroys a FC port from the upper layer protocol. All the
@@ -2116,7 +2115,7 @@ destroy_port(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_get_instance: Get a unique integer ID.
+ * lpfc_get_instance - Get a unique integer ID
  *
  * This routine allocates a unique integer ID from lpfc_hba_index pool. It
  * uses the kernel idr facility to perform the task.
@@ -2139,7 +2138,7 @@ lpfc_get_instance(void)
 }
 
 /**
- * lpfc_scan_finished: method for SCSI layer to detect whether scan is done.
+ * lpfc_scan_finished - method for SCSI layer to detect whether scan is done
  * @shost: pointer to SCSI host data structure.
  * @time: elapsed time of the scan in jiffies.
  *
@@ -2197,7 +2196,7 @@ finished:
 }
 
 /**
- * lpfc_host_attrib_init: Initialize SCSI host attributes on a FC port.
+ * lpfc_host_attrib_init - Initialize SCSI host attributes on a FC port
  * @shost: pointer to SCSI host data structure.
  *
  * This routine initializes a given SCSI host attributes on a FC port. The
@@ -2252,7 +2251,7 @@ void lpfc_host_attrib_init(struct Scsi_Host *shost)
 }
 
 /**
- * lpfc_enable_msix: Enable MSI-X interrupt mode.
+ * lpfc_enable_msix - Enable MSI-X interrupt mode
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI-X interrupt vectors. The kernel
@@ -2366,7 +2365,7 @@ msi_fail_out:
 }
 
 /**
- * lpfc_disable_msix: Disable MSI-X interrupt mode.
+ * lpfc_disable_msix - Disable MSI-X interrupt mode
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to release the MSI-X vectors and then disable the
@@ -2385,7 +2384,7 @@ lpfc_disable_msix(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_enable_msi: Enable MSI interrupt mode.
+ * lpfc_enable_msi - Enable MSI interrupt mode
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable the MSI interrupt mode. The kernel
@@ -2423,7 +2422,7 @@ lpfc_enable_msi(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_disable_msi: Disable MSI interrupt mode.
+ * lpfc_disable_msi - Disable MSI interrupt mode
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to disable the MSI interrupt mode. The driver
@@ -2441,7 +2440,7 @@ lpfc_disable_msi(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_log_intr_mode: Log the active interrupt mode
+ * lpfc_log_intr_mode - Log the active interrupt mode
  * @phba: pointer to lpfc hba data structure.
  * @intr_mode: active interrupt mode adopted.
  *
@@ -2490,7 +2489,7 @@ lpfc_stop_port(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_enable_intr: Enable device interrupt.
+ * lpfc_enable_intr - Enable device interrupt
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to enable device interrupt and associate driver's
@@ -2547,7 +2546,7 @@ lpfc_enable_intr(struct lpfc_hba *phba, uint32_t cfg_mode)
 }
 
 /**
- * lpfc_disable_intr: Disable device interrupt.
+ * lpfc_disable_intr - Disable device interrupt
  * @phba: pointer to lpfc hba data structure.
  *
  * This routine is invoked to disable device interrupt and disassociate the
@@ -2574,7 +2573,7 @@ lpfc_disable_intr(struct lpfc_hba *phba)
 }
 
 /**
- * lpfc_pci_probe_one: lpfc PCI probe func to register device to PCI subsystem.
+ * lpfc_pci_probe_one - lpfc PCI probe func to register device to PCI subsystem
  * @pdev: pointer to PCI device
  * @pid: pointer to PCI device identifier
  *
@@ -3010,7 +3009,7 @@ out:
 }
 
 /**
- * lpfc_pci_remove_one: lpfc PCI func to unregister device from PCI subsystem.
+ * lpfc_pci_remove_one - lpfc PCI func to unregister device from PCI subsystem
  * @pdev: pointer to PCI device
  *
  * This routine is to be registered to the kernel's PCI subsystem. When an
@@ -3095,7 +3094,7 @@ lpfc_pci_remove_one(struct pci_dev *pdev)
 }
 
 /**
- * lpfc_pci_suspend_one: lpfc PCI func to suspend device for power management.
+ * lpfc_pci_suspend_one - lpfc PCI func to suspend device for power management
  * @pdev: pointer to PCI device
  * @msg: power management message
  *
@@ -3139,7 +3138,7 @@ lpfc_pci_suspend_one(struct pci_dev *pdev, pm_message_t msg)
 }
 
 /**
- * lpfc_pci_resume_one: lpfc PCI func to resume device for power management.
+ * lpfc_pci_resume_one - lpfc PCI func to resume device for power management
  * @pdev: pointer to PCI device
  *
  * This routine is to be registered to the kernel's PCI subsystem to support
@@ -3204,7 +3203,7 @@ lpfc_pci_resume_one(struct pci_dev *pdev)
 }
 
 /**
- * lpfc_io_error_detected: Driver method for handling PCI I/O error detected.
+ * lpfc_io_error_detected - Driver method for handling PCI I/O error detected
  * @pdev: pointer to PCI device.
  * @state: the current PCI connection state.
  *
@@ -3254,7 +3253,7 @@ static pci_ers_result_t lpfc_io_error_detected(struct pci_dev *pdev,
 }
 
 /**
- * lpfc_io_slot_reset: Restart a PCI device from scratch.
+ * lpfc_io_slot_reset - Restart a PCI device from scratch
  * @pdev: pointer to PCI device.
  *
  * This routine is registered to the PCI subsystem for error handling. This is
@@ -3313,7 +3312,7 @@ static pci_ers_result_t lpfc_io_slot_reset(struct pci_dev *pdev)
 }
 
 /**
- * lpfc_io_resume: Resume PCI I/O operation.
+ * lpfc_io_resume - Resume PCI I/O operation
  * @pdev: pointer to PCI device
  *
  * This routine is registered to the PCI subsystem for error handling. It is
@@ -3426,7 +3425,7 @@ static struct pci_driver lpfc_driver = {
 };
 
 /**
- * lpfc_init: lpfc module initialization routine.
+ * lpfc_init - lpfc module initialization routine
  *
  * This routine is to be invoked when the lpfc module is loaded into the
  * kernel. The special kernel macro module_init() is used to indicate the
@@ -3472,7 +3471,7 @@ lpfc_init(void)
 }
 
 /**
- * lpfc_exit: lpfc module removal routine.
+ * lpfc_exit - lpfc module removal routine
  *
  * This routine is invoked when the lpfc module is removed from the kernel.
  * The special kernel macro module_exit() is used to indicate the role of
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -206,7 +206,7 @@ lpfc_unique_wwpn(struct lpfc_hba *phba, struct lpfc_vport *new_vport)
 }
 
 /**
- * lpfc_discovery_wait: Wait for driver discovery to quiesce.
+ * lpfc_discovery_wait - Wait for driver discovery to quiesce
  * @vport: The virtual port for which this call is being executed.
  *
  * This driver calls this routine specifically from lpfc_vport_delete
@@ -741,7 +741,7 @@ lpfc_destroy_vport_work_array(struct lpfc_hba *phba, struct lpfc_vport **vports)
 

 /**
- * lpfc_vport_reset_stat_data: Reset the statistical data for the vport.
+ * lpfc_vport_reset_stat_data - Reset the statistical data for the vport
  * @vport: Pointer to vport object.
  *
  * This function resets the statistical data for the vport. This function
@@ -763,8 +763,7 @@ lpfc_vport_reset_stat_data(struct lpfc_vport *vport)
 

 /**
- * lpfc_alloc_bucket: Allocate data buffer required for collecting
- *  statistical data.
+ * lpfc_alloc_bucket - Allocate data buffer required for statistical data
  * @vport: Pointer to vport object.
  *
  * This function allocates data buffer required for all the FC
@@ -797,8 +796,7 @@ lpfc_alloc_bucket(struct lpfc_vport *vport)
 }
 
 /**
- * lpfc_free_bucket: Free data buffer required for collecting
- *  statistical data.
+ * lpfc_free_bucket - Free data buffer required for statistical data
  * @vport: Pointer to vport object.
  *
  * Th function frees statistical data buffer of all the FC


