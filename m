From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [15/15] qla2xxx: Update driver version
Date: Sun, 14 Mar 2004 00:26:25 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314082625.GA3489@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:22455 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263328AbUCNIXz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 03:23:55 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Update version number to 8.00.00b11-k (to indicate embedded driver).

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/24_update_version.patch

===== drivers/scsi/qla2xxx/qla_version.h 1.2 vs edited =====
--- 1.2/drivers/scsi/qla2xxx/qla_version.h	Mon Feb  2 08:02:01 2004
+++ edited/drivers/scsi/qla2xxx/qla_version.h	Sat Mar 13 22:33:17 2004
@@ -19,9 +19,9 @@
 /*
  * Driver version 
  */
-#define QLA2XXX_VERSION      "8.00.00b10"
+#define QLA2XXX_VERSION      "8.00.00b11-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	0
 #define QLA_DRIVER_PATCH_VER	0
-#define QLA_DRIVER_BETA_VER	10
+#define QLA_DRIVER_BETA_VER	11
