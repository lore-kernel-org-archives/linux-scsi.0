From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 9/9] mpt2sas: Bump version 02.100.03.00
Date: Mon, 14 Sep 2009 11:08:13 +0530
Message-ID: <20090914053755.GK31450@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og123.obsmtp.com ([64.18.2.24]:56962 "EHLO
	exprod7og123.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbZINGBE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2009 02:01:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Bump version to 02.100.03.00

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 7f94be9..0cf6bc2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -69,10 +69,10 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"01.100.06.00"
-#define MPT2SAS_MAJOR_VERSION		01
+#define MPT2SAS_DRIVER_VERSION		"02.100.03.00"
+#define MPT2SAS_MAJOR_VERSION		02
 #define MPT2SAS_MINOR_VERSION		100
-#define MPT2SAS_BUILD_VERSION		06
+#define MPT2SAS_BUILD_VERSION		03
 #define MPT2SAS_RELEASE_VERSION		00
 
 /*
