From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 17/17] mpt2sas: Bump version 06.100.00.00
Date: Thu, 17 Jun 2010 13:50:57 +0530
Message-ID: <20100617082057.GR28921@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:45417 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932802Ab0FQI4e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 04:56:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com, Sathya.Prakash@lsi.com


Version upgrade patch

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 026e7f7..54327b6 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -69,11 +69,11 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"05.100.00.03"
-#define MPT2SAS_MAJOR_VERSION		05
+#define MPT2SAS_DRIVER_VERSION		"06.100.00.00"
+#define MPT2SAS_MAJOR_VERSION		06
 #define MPT2SAS_MINOR_VERSION		100
 #define MPT2SAS_BUILD_VERSION		00
-#define MPT2SAS_RELEASE_VERSION		03
+#define MPT2SAS_RELEASE_VERSION		00
 
 /*
  * Set MPT2SAS_SG_DEPTH value based on user input.
