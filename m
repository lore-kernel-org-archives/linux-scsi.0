From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] have CONFIG_SCSI_PROC_FS depend on CONFIG_PROC_FS
Date: Wed, 18 Feb 2004 10:08:12 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040218100812.A21561@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:5090 "EHLO e33.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S267726AbUBRSI7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2004 13:08:59 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Patch against recent 2.6: have CONFIG_SCSI_PROC_FS depend on
CONFIG_PROC_FS, as configuring CONFIG_SCSI_PROC_FS without
CONFIG_PROC_FS prevents scsi core from initializing.

===== drivers/scsi/Kconfig 1.54 vs edited =====
--- 1.54/drivers/scsi/Kconfig	Sat Feb  7 08:38:00 2004
+++ edited/drivers/scsi/Kconfig	Wed Feb 18 09:50:09 2004
@@ -23,7 +23,7 @@
 
 config SCSI_PROC_FS
 	bool "legacy /proc/scsi/ support"
-	depends on SCSI
+	depends on SCSI && PROC_FS
 	default y
 	---help---
 	  This option enables support for the various files in
