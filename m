From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 6/6] qla2xxx: Update Driver version to 10.00.00.00-k
Date: Fri, 16 Jun 2017 15:47:44 -0700
Message-ID: <20170616224744.3681-7-himanshu.madhani@cavium.com>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0080.outbound.protection.outlook.com ([104.47.41.80]:5392
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752094AbdFPWsP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 18:48:15 -0400
In-Reply-To: <20170616224744.3681-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org, giridhar.malaval@cavium.com, darren.trapp@cavium.com

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index dcbb9bb05e99..005a378f7fab 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "9.01.00.00-k"
+#define QLA2XXX_VERSION      "10.00.00.00-k"
 
-#define QLA_DRIVER_MAJOR_VER	9
-#define QLA_DRIVER_MINOR_VER	1
+#define QLA_DRIVER_MAJOR_VER	10
+#define QLA_DRIVER_MINOR_VER	0
 #define QLA_DRIVER_PATCH_VER	0
 #define QLA_DRIVER_BETA_VER	0
-- 
2.12.0
