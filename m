From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/5]  qla2xxx: Update version number to 8.01.03-k.
Date: 8 Nov 2005 14:38:02 -0800
Message-ID: <20051108223758.25189.99594.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
References: <20051108223647.25189.23124.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:55375 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1030380AbVKHWiC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 17:38:02 -0500
In-Reply-To: <20051108223647.25189.23124.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>


Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

applies-to: a72fee1a1fdfe7d613b3f73b670e44c6cb473267
8ff631972f8fad61384acb7fe4114c2884c54397
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 0d5472f..f7937f7 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.01.00-k"
+#define QLA2XXX_VERSION      "8.01.03-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	1
-#define QLA_DRIVER_PATCH_VER	0
+#define QLA_DRIVER_PATCH_VER	3
 #define QLA_DRIVER_BETA_VER	0
---
0.99.9.GIT

-- 
Andrew Vasquez
