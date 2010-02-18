From: giridhar.malavali@qlogic.com
Subject: [PATCH 8/8] qla2xxx: Update version number to 8.03.02-k1.
Date: Thu, 18 Feb 2010 08:38:34 -0800
Message-ID: <1266511114-307-9-git-send-email-giridhar.malavali@qlogic.com>
References: <1266511114-307-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:34767 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1758595Ab0BRQil (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2010 11:38:41 -0500
In-Reply-To: <1266511114-307-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 082394b..8d2fc2f 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.02-k0"
+#define QLA2XXX_VERSION      "8.03.02-k1"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3
 #define QLA_DRIVER_PATCH_VER	2
-#define QLA_DRIVER_BETA_VER	0
+#define QLA_DRIVER_BETA_VER	1
-- 
1.6.2.rc1.30.gd43c

