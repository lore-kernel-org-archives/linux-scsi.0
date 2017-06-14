From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 15/15] qla2xxx: Update driver version to 9.01.00.00-k
Date: Tue, 13 Jun 2017 20:47:30 -0700
Message-ID: <20170614034730.15428-16-himanshu.madhani@cavium.com>
References: <20170614034730.15428-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0076.outbound.protection.outlook.com ([104.47.40.76]:34480
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754224AbdFNDs1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jun 2017 23:48:27 -0400
In-Reply-To: <20170614034730.15428-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, nab@linux-iscsi.org
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 45bc84e8e3bf..dcbb9bb05e99 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "9.00.00.00-k"
+#define QLA2XXX_VERSION      "9.01.00.00-k"
 
 #define QLA_DRIVER_MAJOR_VER	9
-#define QLA_DRIVER_MINOR_VER	0
+#define QLA_DRIVER_MINOR_VER	1
 #define QLA_DRIVER_PATCH_VER	0
 #define QLA_DRIVER_BETA_VER	0
-- 
2.12.0
