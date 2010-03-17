From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 11/11] mpt2sas: Bump version 05.100.00.00
Date: Wed, 17 Mar 2010 16:28:34 +0530
Message-ID: <20100317105825.GL21264@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:60145 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754464Ab0CQL3d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2010 07:29:33 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Upgraded version string.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 9cf0104..454a74a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -69,11 +69,11 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"04.100.01.02"
-#define MPT2SAS_MAJOR_VERSION		04
+#define MPT2SAS_DRIVER_VERSION		"05.100.00.00"
+#define MPT2SAS_MAJOR_VERSION		05
 #define MPT2SAS_MINOR_VERSION		100
-#define MPT2SAS_BUILD_VERSION		01
-#define MPT2SAS_RELEASE_VERSION		02
+#define MPT2SAS_BUILD_VERSION		00
+#define MPT2SAS_RELEASE_VERSION		00
 
 /*
  * Set MPT2SAS_SG_DEPTH value based on user input.
