From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 5/5] qla2xxx: Update the driver version to 8.05.00.03-k.
Date: Thu, 28 Mar 2013 08:21:27 -0400
Message-ID: <1364473287-27640-6-git-send-email-saurav.kashyap@qlogic.com>
References: <1364473287-27640-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:3451 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755420Ab3C1MoU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Mar 2013 08:44:20 -0400
In-Reply-To: <1364473287-27640-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index ec54036..6c66d22 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.04.00.13-k"
+#define QLA2XXX_VERSION      "8.05.00.03-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
-#define QLA_DRIVER_MINOR_VER	4
+#define QLA_DRIVER_MINOR_VER	5
 #define QLA_DRIVER_PATCH_VER	0
 #define QLA_DRIVER_BETA_VER	0
-- 
1.7.7

