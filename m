From: giridhar.malavali@qlogic.com
Subject: [PATCH 6/6] qla2xxx: Updated version number to 8.03.02-k2.
Date: Fri, 19 Mar 2010 16:59:21 -0700
Message-ID: <1269043161-2265-7-git-send-email-giridhar.malavali@qlogic.com>
References: <1269043161-2265-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46308 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752336Ab0CSX71 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 19:59:27 -0400
In-Reply-To: <1269043161-2265-1-git-send-email-giridhar.malavali@qlogic.com>
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
index 8d2fc2f..109068d 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.02-k1"
+#define QLA2XXX_VERSION      "8.03.02-k2"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3
 #define QLA_DRIVER_PATCH_VER	2
-#define QLA_DRIVER_BETA_VER	1
+#define QLA_DRIVER_BETA_VER	2
-- 
1.6.2.rc1.30.gd43c

