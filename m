From: madhu.iyengar@qlogic.com
Subject: [PATCH 7/7] qla2xxx: Update version number to 8.03.04-k0.
Date: Fri,  3 Sep 2010 14:57:06 -0700
Message-ID: <1283551026-3886-8-git-send-email-madhu.iyengar@qlogic.com>
References: <1283551026-3886-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:42968 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1757669Ab0ICWDI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:03:08 -0400
In-Reply-To: <1283551026-3886-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nkmi@yahoo.com

From: Madhuranath Iyengar <madhuranath.iyengar@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index e75ccb9..8edbccb 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.03-k0"
+#define QLA2XXX_VERSION      "8.03.04-k0"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3
-#define QLA_DRIVER_PATCH_VER	3
+#define QLA_DRIVER_PATCH_VER	4
 #define QLA_DRIVER_BETA_VER	0
-- 
1.6.0.2

