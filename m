From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 6/7] qla4xxx: Cleanup modinfo display
Date: Wed, 11 Jan 2012 02:44:20 -0800
Message-ID: <1326278661-16368-7-git-send-email-vikas.chaudhary@qlogic.com>
References: <1326278661-16368-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:45874 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757182Ab2AKK7Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2012 05:59:24 -0500
In-Reply-To: <1326278661-16368-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Karen Higgins <karen.higgins@qlogic.com>

From: Karen Higgins <karen.higgins@qlogic.com>

 * Beautify modinfo display.
 * Display correct info for ql4xextended_error_logging

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   33 +++++++++++++++++----------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index cb9dcd8..4d99f9e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -35,43 +35,44 @@ static struct kmem_cache *srb_cachep;
 int ql4xdisablesysfsboot = 1;
 module_param(ql4xdisablesysfsboot, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql4xdisablesysfsboot,
-		"Set to disable exporting boot targets to sysfs\n"
-		" 0 - Export boot targets\n"
-		" 1 - Do not export boot targets (Default)");
+		 " Set to disable exporting boot targets to sysfs.\n"
+		 "\t\t  0 - Export boot targets\n"
+		 "\t\t  1 - Do not export boot targets (Default)");
 
 int ql4xdontresethba = 0;
 module_param(ql4xdontresethba, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql4xdontresethba,
-		"Don't reset the HBA for driver recovery \n"
-		" 0 - It will reset HBA (Default)\n"
-		" 1 - It will NOT reset HBA");
+		 " Don't reset the HBA for driver recovery.\n"
+		 "\t\t  0 - It will reset HBA (Default)\n"
+		 "\t\t  1 - It will NOT reset HBA");
 
-int ql4xextended_error_logging = 0; /* 0 = off, 1 = log errors */
+int ql4xextended_error_logging = 0;
 module_param(ql4xextended_error_logging, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql4xextended_error_logging,
-		 "Option to enable extended error logging, "
-		 "Default is 0 - no logging, 1 - debug logging");
+		 " Option to enable extended error logging.\n"
+		 "\t\t  0 - no logging (Default)\n"
+		 "\t\t  2 - debug logging");
 
 int ql4xenablemsix = 1;
 module_param(ql4xenablemsix, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql4xenablemsix,
-		"Set to enable MSI or MSI-X interrupt mechanism.\n"
-		" 0 = enable INTx interrupt mechanism.\n"
-		" 1 = enable MSI-X interrupt mechanism (Default).\n"
-		" 2 = enable MSI interrupt mechanism.");
+		 " Set to enable MSI or MSI-X interrupt mechanism.\n"
+		 "\t\t  0 = enable INTx interrupt mechanism.\n"
+		 "\t\t  1 = enable MSI-X interrupt mechanism (Default).\n"
+		 "\t\t  2 = enable MSI interrupt mechanism.");
 
 #define QL4_DEF_QDEPTH 32
 static int ql4xmaxqdepth = QL4_DEF_QDEPTH;
 module_param(ql4xmaxqdepth, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql4xmaxqdepth,
-		"Maximum queue depth to report for target devices.\n"
-		" Default: 32.");
+		 " Maximum queue depth to report for target devices.\n"
+		 "\t\t  Default: 32.");
 
 static int ql4xsess_recovery_tmo = QL4_SESS_RECOVERY_TMO;
 module_param(ql4xsess_recovery_tmo, int, S_IRUGO);
 MODULE_PARM_DESC(ql4xsess_recovery_tmo,
 		"Target Session Recovery Timeout.\n"
-		" Default: 120 sec.");
+		"\t\t  Default: 120 sec.");
 
 static int qla4xxx_wait_for_hba_online(struct scsi_qla_host *ha);
 /*
-- 
1.7.8.rc2.3.g0911


