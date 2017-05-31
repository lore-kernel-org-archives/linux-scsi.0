From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH V2 15/15] qedf: Update version number to 8.18.22.0.
Date: Wed, 31 May 2017 06:34:02 -0700
Message-ID: <20170531133402.16629-16-chad.dupuis@cavium.com>
References: <20170531133402.16629-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0081.outbound.protection.outlook.com ([104.47.38.81]:11088
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751097AbdEaNfM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 May 2017 09:35:12 -0400
In-Reply-To: <20170531133402.16629-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_version.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_version.h b/drivers/scsi/qedf/qedf_version.h
index d46c487..6fa4420 100644
--- a/drivers/scsi/qedf/qedf_version.h
+++ b/drivers/scsi/qedf/qedf_version.h
@@ -7,9 +7,9 @@
  *  this source tree.
  */
 
-#define QEDF_VERSION		"8.10.7.0"
+#define QEDF_VERSION		"8.18.22.0"
 #define QEDF_DRIVER_MAJOR_VER		8
-#define QEDF_DRIVER_MINOR_VER		10
-#define QEDF_DRIVER_REV_VER		7
+#define QEDF_DRIVER_MINOR_VER		18
+#define QEDF_DRIVER_REV_VER		22
 #define QEDF_DRIVER_ENG_VER		0
 
-- 
1.8.5.6
