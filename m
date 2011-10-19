From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH] mpt2sas: Bump driver version to 10.100.00.00
Date: Wed, 19 Oct 2011 10:24:20 +0530
Message-ID: <201110191100.p9JB0GXl027630@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:38608 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750731Ab1JSLAU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2011 07:00:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Bump driver vesion to 10.100.00.00

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---
diff --git a/old/mpt2sas_base.h b/new/mpt2sas_base.h
index a69849b..3605e5e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -69,11 +69,11 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"09.100.00.01"
-#define MPT2SAS_MAJOR_VERSION		09
+#define MPT2SAS_DRIVER_VERSION		"10.100.00.00"
+#define MPT2SAS_MAJOR_VERSION		10
 #define MPT2SAS_MINOR_VERSION		100
 #define MPT2SAS_BUILD_VERSION		00
-#define MPT2SAS_RELEASE_VERSION		01
+#define MPT2SAS_RELEASE_VERSION		00
 
 /*
  * Set MPT2SAS_SG_DEPTH value based on user input.
