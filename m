From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 15/15] qla2xxx: Update driver version to 9.01.00.00-k
Date: Wed, 7 Jun 2017 14:43:33 -0700
Message-ID: <20170607214333.23110-16-himanshu.madhani@cavium.com>
References: <20170607214333.23110-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0083.outbound.protection.outlook.com ([104.47.32.83]:59616
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751778AbdFGVoM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Jun 2017 17:44:12 -0400
In-Reply-To: <20170607214333.23110-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

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
