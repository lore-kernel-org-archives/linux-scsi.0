From: madhu.iyengar@qlogic.com
Subject: [PATCH 5/5] qla2xxx: Update version number to 8.03.05-k0.
Date: Tue, 23 Nov 2010 16:52:50 -0800
Message-ID: <1290559970-12123-6-git-send-email-madhu.iyengar@qlogic.com>
References: <1290559970-12123-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:59501 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754548Ab0KXBCi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2010 20:02:38 -0500
In-Reply-To: <1290559970-12123-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

From: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 8edbccb..cf0075a 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.04-k0"
+#define QLA2XXX_VERSION      "8.03.05-k0"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3
-#define QLA_DRIVER_PATCH_VER	4
+#define QLA_DRIVER_PATCH_VER	5
 #define QLA_DRIVER_BETA_VER	0
-- 
1.6.0.2

