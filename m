From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 3/3] mpt2sas: Driver version upgrade 08.100.00.02
Date: Wed, 4 May 2011 16:37:04 +0530
Message-ID: <20110504110700.GC17855@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:54725 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751315Ab1EDKpC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2011 06:45:02 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Driver version upgrade patch.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 2a3c05f..dcc289c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -69,11 +69,11 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"08.100.00.01"
+#define MPT2SAS_DRIVER_VERSION		"08.100.00.02"
 #define MPT2SAS_MAJOR_VERSION		08
 #define MPT2SAS_MINOR_VERSION		100
 #define MPT2SAS_BUILD_VERSION		00
-#define MPT2SAS_RELEASE_VERSION		01
+#define MPT2SAS_RELEASE_VERSION		02
 
 /*
  * Set MPT2SAS_SG_DEPTH value based on user input.
