From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [patch 13/17] mark unused exports in drivers/scsi
Date: Tue, 02 May 2006 17:00:36 +0200
Message-ID: <1146582036.32045.66.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a222036.upc-a.chello.nl ([62.163.222.36]:15554 "EHLO
	laptopd505.fenrus.org") by vger.kernel.org with ESMTP
	id S964861AbWEBPDJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 May 2006 11:03:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: linux-scsi@vger.kernel.org

The unused symbols in drivers/scsi


CC: jgarzik@pobox.net
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/scsi/constants.c  |    2 +-
 drivers/scsi/hosts.c      |    2 +-
 drivers/scsi/scsi.c       |    6 +++---
 drivers/scsi/scsi_error.c |    2 +-
 drivers/scsi/scsi_lib.c   |    8 ++++----
 5 files changed, 10 insertions(+), 10 deletions(-)

Index: linux-2.6.17-rc3-mm1-unused/drivers/scsi/constants.c
===================================================================
--- linux-2.6.17-rc3-mm1-unused.orig/drivers/scsi/constants.c
+++ linux-2.6.17-rc3-mm1-unused/drivers/scsi/constants.c
@@ -405,7 +405,7 @@ scsi_print_status(unsigned char scsi_sta
 	printk(KERN_INFO "0x%0x", scsi_status);
 #endif
 }
-EXPORT_SYMBOL(scsi_print_status);
+EXPORT_UNUSED_SYMBOL(scsi_print_status); /* removal in 2.6.19 */
 
 #ifdef CONFIG_SCSI_CONSTANTS
 
Index: linux-2.6.17-rc3-mm1-unused/drivers/scsi/hosts.c
===================================================================
--- linux-2.6.17-rc3-mm1-unused.orig/drivers/scsi/hosts.c
+++ linux-2.6.17-rc3-mm1-unused/drivers/scsi/hosts.c
@@ -147,7 +147,7 @@ int scsi_host_set_state(struct Scsi_Host
 					     scsi_host_state_name(state)));
 	return -EINVAL;
 }
-EXPORT_SYMBOL(scsi_host_set_state);
+EXPORT_UNUSED_SYMBOL(scsi_host_set_state); /* removal in 2.6.19 */
 
 /**
  * scsi_remove_host - remove a scsi host
Index: linux-2.6.17-rc3-mm1-unused/drivers/scsi/scsi.c
===================================================================
--- linux-2.6.17-rc3-mm1-unused.orig/drivers/scsi/scsi.c
+++ linux-2.6.17-rc3-mm1-unused/drivers/scsi/scsi.c
@@ -1172,7 +1172,7 @@ struct scsi_device *__scsi_device_lookup
 
 	return NULL;
 }
-EXPORT_SYMBOL(__scsi_device_lookup_by_target);
+EXPORT_UNUSED_SYMBOL(__scsi_device_lookup_by_target); /* removal in 2.6.19 */
 
 /**
  * scsi_device_lookup_by_target - find a device given the target
@@ -1198,7 +1198,7 @@ struct scsi_device *scsi_device_lookup_b
 
 	return sdev;
 }
-EXPORT_SYMBOL(scsi_device_lookup_by_target);
+EXPORT_UNUSED_SYMBOL(scsi_device_lookup_by_target); /* removal in 2.6.19 */
 
 /**
  * scsi_device_lookup - find a device given the host (UNLOCKED)
@@ -1302,7 +1302,7 @@ int scsi_device_cancel(struct scsi_devic
 
 	return 0;
 }
-EXPORT_SYMBOL(scsi_device_cancel);
+EXPORT_UNUSED_SYMBOL(scsi_device_cancel); /* removal in 2.6.19 */
 
 MODULE_DESCRIPTION("SCSI core");
 MODULE_LICENSE("GPL");
Index: linux-2.6.17-rc3-mm1-unused/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.17-rc3-mm1-unused.orig/drivers/scsi/scsi_error.c
+++ linux-2.6.17-rc3-mm1-unused/drivers/scsi/scsi_error.c
@@ -1775,7 +1775,7 @@ int scsi_request_normalize_sense(struct 
 	return scsi_normalize_sense(sreq->sr_sense_buffer,
 			sizeof(sreq->sr_sense_buffer), sshdr);
 }
-EXPORT_SYMBOL(scsi_request_normalize_sense);
+EXPORT_UNUSED_SYMBOL(scsi_request_normalize_sense); /* removal in 2.6.19 */
 
 int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
 				 struct scsi_sense_hdr *sshdr)
Index: linux-2.6.17-rc3-mm1-unused/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.17-rc3-mm1-unused.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6.17-rc3-mm1-unused/drivers/scsi/scsi_lib.c
@@ -1716,7 +1716,7 @@ u64 scsi_calculate_bounce_limit(struct S
 
 	return bounce_limit;
 }
-EXPORT_SYMBOL(scsi_calculate_bounce_limit);
+EXPORT_UNUSED_SYMBOL(scsi_calculate_bounce_limit); /* removal in 2.6.19 */
 
 struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 					 request_fn_proc *request_fn)
@@ -2218,7 +2218,7 @@ scsi_device_resume(struct scsi_device *s
 		return;
 	scsi_run_queue(sdev->request_queue);
 }
-EXPORT_SYMBOL(scsi_device_resume);
+EXPORT_UNUSED_SYMBOL(scsi_device_resume); /* removal in 2.6.19 */
 
 static void
 device_quiesce_fn(struct scsi_device *sdev, void *data)
@@ -2286,7 +2286,7 @@ scsi_internal_device_block(struct scsi_d
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(scsi_internal_device_block);
+EXPORT_UNUSED_SYMBOL_GPL(scsi_internal_device_block); /* removal in 2.6.19 */
  
 /**
  * scsi_internal_device_unblock - resume a device after a block request
@@ -2325,7 +2325,7 @@ scsi_internal_device_unblock(struct scsi
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(scsi_internal_device_unblock);
+EXPORT_UNUSED_SYMBOL_GPL(scsi_internal_device_unblock); /* removal in 2.6.19 */
 
 static void
 device_block(struct scsi_device *sdev, void *data)

