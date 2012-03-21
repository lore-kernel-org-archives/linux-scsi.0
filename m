From: michaelc@cs.wisc.edu
Subject: [PATCH 10/17] be2iscsi: Update in Copyright information
Date: Tue, 20 Mar 2012 20:48:01 -0500
Message-ID: <1332294488-13684-11-git-send-email-michaelc@cs.wisc.edu>
References: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030413Ab2CUBsk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 21:48:40 -0400
In-Reply-To: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Minh Tran <MinhDuc.Tran@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

	change from Serverengines to Emulex

Signed-off-by: Minh Tran <MinhDuc.Tran@Emulex.Com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_cmds.h |    2 +-
 drivers/scsi/be2iscsi/be_main.c |    4 ++--
 drivers/scsi/be2iscsi/be_main.h |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 8b40a5b..c85d73c 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -23,7 +23,7 @@
  * firmware in the BE. These requests are communicated to the processor
  * using Work Request Blocks (WRBs) submitted to the MCC-WRB ring or via one
  * WRB inside a MAILBOX.
- * The commands are serviced by the ARM processor in the BladeEngine's MPU.
+ * The commands are serviced by the ARM processor in the OneConnect's MPU.
  */
 struct be_sge {
 	u32 pa_lo;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 52277f7..e38d694 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -48,7 +48,7 @@ static unsigned int num_hba = 0;
 
 MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
 MODULE_DESCRIPTION(DRV_DESC " " BUILD_STR);
-MODULE_AUTHOR("ServerEngines Corporation");
+MODULE_AUTHOR("Emulex Corporation");
 MODULE_LICENSE("GPL");
 module_param(be_iopoll_budget, int, 0);
 module_param(enable_msix, int, 0);
@@ -391,7 +391,7 @@ MODULE_DEVICE_TABLE(pci, beiscsi_pci_id_table);
 
 static struct scsi_host_template beiscsi_sht = {
 	.module = THIS_MODULE,
-	.name = "ServerEngines 10Gbe open-iscsi Initiator Driver",
+	.name = "Emulex 10Gbe open-iscsi Initiator Driver",
 	.proc_name = DRV_NAME,
 	.queuecommand = iscsi_queuecommand,
 	.change_queue_depth = iscsi_change_queue_depth,
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 50f231f..49289ef 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -35,8 +35,8 @@
 #include "be.h"
 #define DRV_NAME		"be2iscsi"
 #define BUILD_STR		"4.1.239.0"
-#define BE_NAME			"ServerEngines BladeEngine2" \
-				"Linux iSCSI Driver version" BUILD_STR
+#define BE_NAME			"Emulex OneConnect" \
+				"Open-iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
 
 #define BE_VENDOR_ID		0x19A2
-- 
1.7.7.6

