From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 10/10] mpt2sas: Bump version 04.100.01.00
Date: Wed, 16 Dec 2009 18:57:02 +0530
Message-ID: <20091216132654.GK31161@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:56118 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756281AbZLPNyZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 08:54:25 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Version upgraded to 04.100.01.00.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Reviewed-by: Eric Moore <eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 67b831e..b0c8c05 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -69,10 +69,10 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"03.100.03.00"
-#define MPT2SAS_MAJOR_VERSION		03
+#define MPT2SAS_DRIVER_VERSION		"04.100.01.00"
+#define MPT2SAS_MAJOR_VERSION		04
 #define MPT2SAS_MINOR_VERSION		100
-#define MPT2SAS_BUILD_VERSION		03
+#define MPT2SAS_BUILD_VERSION		01
 #define MPT2SAS_RELEASE_VERSION		00
 
 /*
