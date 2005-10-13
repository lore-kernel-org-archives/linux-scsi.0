From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 12/12] qla2xxx: Update version number to 8.01.02-k.
Date: Thu, 13 Oct 2005 16:17:34 -0700 (PDT)
Message-ID: <20051013231734.27191.85270.sendpatchset@plap.qlogic.com>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:34730 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932539AbVJMXRe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Oct 2005 19:17:34 -0400
In-Reply-To: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Subject: Update version number to 8.01.02-k.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

applies-to: f44b3c5228b9cfb0393117daae32056473bae8eb
056de35b9be3bd58c4e6760f0629a1a931405e38
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 0d5472f..13c47ef 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.01.00-k"
+#define QLA2XXX_VERSION      "8.01.02-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	1
-#define QLA_DRIVER_PATCH_VER	0
+#define QLA_DRIVER_PATCH_VER	2
 #define QLA_DRIVER_BETA_VER	0
---
0.99.8.GIT

-- 
Andrew Vasquez
