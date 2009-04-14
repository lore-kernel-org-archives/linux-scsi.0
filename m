From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 13/13] mpt2sas: bump driver version
Date: Mon, 13 Apr 2009 22:38:30 -0600
Message-ID: <20090414043826.GN20124@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og50.obsmtp.com ([64.18.14.165]:34772 "EHLO
	chip3og50.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbZDNSMj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2009 14:12:39 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id n3EICaTK005418
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2009 11:12:36 -0700 (PDT)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id n3EICekK023341
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2009 11:12:40 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Bump driver version.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -auarpN a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h	2009-04-13 16:40:47.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h	2009-04-13 17:31:07.000000000 -0600
@@ -69,11 +69,11 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"00.100.11.16"
-#define MPT2SAS_MAJOR_VERSION		00
+#define MPT2SAS_DRIVER_VERSION		"01.100.02.00"
+#define MPT2SAS_MAJOR_VERSION		01
 #define MPT2SAS_MINOR_VERSION		100
-#define MPT2SAS_BUILD_VERSION		11
-#define MPT2SAS_RELEASE_VERSION		16
+#define MPT2SAS_BUILD_VERSION		12
+#define MPT2SAS_RELEASE_VERSION		00
 
 /*
  * Set MPT2SAS_SG_DEPTH value based on user input.
