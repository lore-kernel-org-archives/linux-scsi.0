From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 16/16] qla2xxx: Update version number to 8.01.00-k.
Date: Fri, 26 Aug 2005 19:10:30 -0700 (PDT)
Message-ID: <20050827021030.27275.42079.sendpatchset@plap.qlogic.com>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:2409 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751626AbVH0CKb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:10:31 -0400
In-Reply-To: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Update version number to 8.01.00-k.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

9fdabc46aa84637af6518661786d624da60830c5
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -19,9 +19,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.01.00b5-k"
+#define QLA2XXX_VERSION      "8.01.00-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	1
 #define QLA_DRIVER_PATCH_VER	0
-#define QLA_DRIVER_BETA_VER	5
+#define QLA_DRIVER_BETA_VER	0

-- 
Andrew Vasquez
