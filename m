From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: [PATCH 6/6] qedf: Update driver version to 8.20.5.0.
Date: Tue, 15 Aug 2017 10:08:21 -0700
Message-ID: <20170815170821.20806-7-chad.dupuis@cavium.com>
References: <20170815170821.20806-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0089.outbound.protection.outlook.com ([104.47.42.89]:55734
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752609AbdHORJb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 13:09:31 -0400
In-Reply-To: <20170815170821.20806-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_version.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_version.h b/drivers/scsi/qedf/qedf_version.h
index 6fa442061c32..397b3b8ee51a 100644
--- a/drivers/scsi/qedf/qedf_version.h
+++ b/drivers/scsi/qedf/qedf_version.h
@@ -7,9 +7,9 @@
  *  this source tree.
  */
 
-#define QEDF_VERSION		"8.18.22.0"
+#define QEDF_VERSION		"8.20.5.0"
 #define QEDF_DRIVER_MAJOR_VER		8
-#define QEDF_DRIVER_MINOR_VER		18
-#define QEDF_DRIVER_REV_VER		22
+#define QEDF_DRIVER_MINOR_VER		20
+#define QEDF_DRIVER_REV_VER		5
 #define QEDF_DRIVER_ENG_VER		0
 
-- 
2.12.3
