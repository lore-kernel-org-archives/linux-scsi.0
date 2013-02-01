From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 8/8] [SCSI] mpt2sas : Bump driver vesion to v15.100.00.00
Date: Fri, 1 Feb 2013 22:03:17 +0530
Message-ID: <20130201163317.GA21735@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:41237 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040Ab3BAFjM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2013 00:39:12 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, sreekanth.reddy@lsi.com, Nagalakshmi.Nandigama@lsi.com, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, sathya.prakash@lsi.com

Bump mpt2sas driver version to v15.100.00.00

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index ee7a030..e97f9d5 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -69,8 +69,8 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"14.100.00.00"
-#define MPT2SAS_MAJOR_VERSION		14
+#define MPT2SAS_DRIVER_VERSION		"15.100.00.00"
+#define MPT2SAS_MAJOR_VERSION		15
 #define MPT2SAS_MINOR_VERSION		100
 #define MPT2SAS_BUILD_VERSION		00
 #define MPT2SAS_RELEASE_VERSION		00
