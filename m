From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 05/05] mpt2sas: Upgrade version 05.100.00.01
Date: Mon, 5 Apr 2010 14:21:48 +0530
Message-ID: <20100405085139.GF28900@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:52041 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752226Ab0DEJXk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2010 05:23:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Upgraded version string.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 454a74a..21aa397 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -69,11 +69,11 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"05.100.00.00"
+#define MPT2SAS_DRIVER_VERSION		"05.100.00.01"
 #define MPT2SAS_MAJOR_VERSION		05
 #define MPT2SAS_MINOR_VERSION		100
 #define MPT2SAS_BUILD_VERSION		00
-#define MPT2SAS_RELEASE_VERSION		00
+#define MPT2SAS_RELEASE_VERSION		01
 
 /*
  * Set MPT2SAS_SG_DEPTH value based on user input.
