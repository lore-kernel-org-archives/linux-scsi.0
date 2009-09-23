From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 20/20] mpt2sas: Bump version 03.100.03.00
Date: Wed, 23 Sep 2009 17:40:05 +0530
Message-ID: <20090923121005.GY6772@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:57205 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbZIWMdX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Sep 2009 08:33:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Bump version to 03.100.03.00

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index eb51fe9..bb4f146 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -69,8 +69,8 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"02.100.03.00"
-#define MPT2SAS_MAJOR_VERSION		02
+#define MPT2SAS_DRIVER_VERSION		"03.100.03.00"
+#define MPT2SAS_MAJOR_VERSION		03
 #define MPT2SAS_MINOR_VERSION		100
 #define MPT2SAS_BUILD_VERSION		03
 #define MPT2SAS_RELEASE_VERSION		00
