From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 17/17] qla2xxx: Update version number to 8.01.00b5-k.
Date: Wed,  6 Jul 2005 10:32:47 -0700 (PDT)
Message-ID: <20050706173247.10568.45578.sendpatchset@plap.qlogic.com>
References: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:88 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262441AbVGFRcs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2005 13:32:48 -0400
In-Reply-To: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Update version number to 8.01.00b5-k.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_version.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

cb2ccfbc4f91e62e69d2f84992a45a557c02230d
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -19,9 +19,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.00.02b5-k"
+#define QLA2XXX_VERSION      "8.01.00b5-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
-#define QLA_DRIVER_MINOR_VER	0
-#define QLA_DRIVER_PATCH_VER	2
+#define QLA_DRIVER_MINOR_VER	1
+#define QLA_DRIVER_PATCH_VER	0
 #define QLA_DRIVER_BETA_VER	5

-- 
Andrew Vasquez
