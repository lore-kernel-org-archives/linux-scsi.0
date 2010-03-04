From: giridhar.malavali@qlogic.com
Subject: [PATCH 2/2] qla2xxx: Update version number to 8.03.03-k0.
Date: Thu,  4 Mar 2010 14:12:57 -0800
Message-ID: <1267740777-3862-3-git-send-email-giridhar.malavali@qlogic.com>
References: <1267740777-3862-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52119 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755950Ab0CDWM6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Mar 2010 17:12:58 -0500
In-Reply-To: <1267740777-3862-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 8d2fc2f..9b49b08 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.02-k1"
+#define QLA2XXX_VERSION      "8.03.03-k0"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3
-#define QLA_DRIVER_PATCH_VER	2
-#define QLA_DRIVER_BETA_VER	1
+#define QLA_DRIVER_PATCH_VER	3
+#define QLA_DRIVER_BETA_VER	0
-- 
1.6.0.2

