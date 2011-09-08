From: <nagalakshmi.nandigama@lsi.com>
Subject: [[PATCH] mpt2sas: Bump driver version 09.100.00.01
Date: Thu, 8 Sep 2011 07:13:35 +0530
Message-ID: <201109080746.p887kw2R010297@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:38959 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932192Ab1IHHrE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2011 03:47:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Bumped driver vesion to 09.100.00.01

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 051da49..59354db 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -69,11 +69,11 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"09.100.00.00"
+#define MPT2SAS_DRIVER_VERSION		"09.100.00.01"
 #define MPT2SAS_MAJOR_VERSION		09
 #define MPT2SAS_MINOR_VERSION		100
 #define MPT2SAS_BUILD_VERSION		00
-#define MPT2SAS_RELEASE_VERSION		00
+#define MPT2SAS_RELEASE_VERSION		01
 
 /*
  * Set MPT2SAS_SG_DEPTH value based on user input.
