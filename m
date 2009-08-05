From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 11/11] mpt2sas: [Resend]  Bump driver version 01.100.06.00
Date: Wed, 5 Aug 2009 11:48:48 +0530
Message-ID: <20090805061848.GL13733@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:45163 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684AbZHEGjv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 02:39:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Bump version to 01.100.06.00
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 22b7150..8627ae2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -69,10 +69,10 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"01.100.03.00"
+#define MPT2SAS_DRIVER_VERSION		"01.100.06.00"
 #define MPT2SAS_MAJOR_VERSION		01
 #define MPT2SAS_MINOR_VERSION		100
-#define MPT2SAS_BUILD_VERSION		03
+#define MPT2SAS_BUILD_VERSION		06
 #define MPT2SAS_RELEASE_VERSION		00
 
 /*
