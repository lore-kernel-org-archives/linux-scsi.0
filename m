From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 5/5] qla2xxx: Update version number to 8.04.00.03-k.
Date: Wed, 25 Apr 2012 07:26:17 -0700
Message-ID: <1335363977-6816-6-git-send-email-chad.dupuis@qlogic.com>
References: <1335363977-6816-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:37519
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230Ab2DYOl5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Apr 2012 10:41:57 -0400
Received: from mail78-db3 (localhost [127.0.0.1])	by mail78-db3-R.bigfish.com
 (Postfix) with ESMTP id E330A4E04C3	for <linux-scsi@vger.kernel.org>; Wed, 25
 Apr 2012 14:41:56 +0000 (UTC)
In-Reply-To: <1335363977-6816-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 29d780c..f5fdb16 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.07.13-k"
+#define QLA2XXX_VERSION      "8.04.00.03-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
-#define QLA_DRIVER_MINOR_VER	3
-#define QLA_DRIVER_PATCH_VER	7
+#define QLA_DRIVER_MINOR_VER	4
+#define QLA_DRIVER_PATCH_VER	0
 #define QLA_DRIVER_BETA_VER	3
-- 
1.6.0.2


