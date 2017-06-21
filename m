From: "Madhani, Himanshu" <himanshu.madhani@cavium.com>
Subject: [PATCH v2 6/6] qla2xxx: Update Driver version to 10.00.00.00-k
Date: Wed, 21 Jun 2017 13:48:46 -0700
Message-ID: <20170621204846.21663-7-himanshu.madhani@cavium.com>
References: <20170621204846.21663-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0064.outbound.protection.outlook.com ([104.47.33.64]:13907
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751884AbdFUUtK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 16:49:10 -0400
In-Reply-To: <20170621204846.21663-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org, darren.trapp@cavium.com, giridhar.malavali@cavium.com, linux-nvme@lists.infradead.org

From: Himanshu Madhani <himanshu.madhani@cavium.com>

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: James Smart <james.smart@broadcom.com>
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
