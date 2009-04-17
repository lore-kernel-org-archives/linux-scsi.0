From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 14/14 - 2nd post] mpt2sas: bump driver version to 01.100.02.00
Date: Fri, 17 Apr 2009 10:35:32 -0600
Message-ID: <20090417163530.GA7088@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og63.obsmtp.com ([64.18.14.203]:39568 "EHLO
	chip3og63.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758410AbZDQQef (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 12:34:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com

Bump driver version.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uarpN a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h	2009-04-13 16:40:47.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h	2009-04-17 09:11:51.000000000 -0600
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
+#define MPT2SAS_BUILD_VERSION		02
+#define MPT2SAS_RELEASE_VERSION		00
 
 /*
  * Set MPT2SAS_SG_DEPTH value based on user input.
