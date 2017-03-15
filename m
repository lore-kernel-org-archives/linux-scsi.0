From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v4 14/14] qla2xxx: Update driver version to 9.00.00.00-k
Date: Wed, 15 Mar 2017 09:48:56 -0700
Message-ID: <20170315164856.17255-15-himanshu.madhani@cavium.com>
References: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0075.outbound.protection.outlook.com ([104.47.36.75]:58497
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753165AbdCOQtf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 12:49:35 -0400
In-Reply-To: <20170315164856.17255-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 3cb1964b7786..45bc84e8e3bf 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.07.00.38-k"
+#define QLA2XXX_VERSION      "9.00.00.00-k"
 
-#define QLA_DRIVER_MAJOR_VER	8
-#define QLA_DRIVER_MINOR_VER	7
+#define QLA_DRIVER_MAJOR_VER	9
+#define QLA_DRIVER_MINOR_VER	0
 #define QLA_DRIVER_PATCH_VER	0
 #define QLA_DRIVER_BETA_VER	0
-- 
2.12.0
