From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 4/4] qla2xxx: Update the driver version to 8.04.00.13-k.
Date: Sat,  9 Mar 2013 06:04:54 -0500
Message-ID: <1362827094-13912-5-git-send-email-chad.dupuis@qlogic.com>
References: <1362827094-13912-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:56193 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757584Ab3CIL1F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Mar 2013 06:27:05 -0500
In-Reply-To: <1362827094-13912-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 2b6e478..ec54036 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.04.00.08-k"
+#define QLA2XXX_VERSION      "8.04.00.13-k"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	4
-- 
1.7.7

