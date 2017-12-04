From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 22/22] qla2xxx: Update driver version to 10.00.00.03-k
Date: Mon, 4 Dec 2017 14:45:17 -0800
Message-ID: <20171204224517.3409-23-himanshu.madhani@cavium.com>
References: <20171204224517.3409-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0081.outbound.protection.outlook.com ([104.47.32.81]:24800
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751582AbdLDWqE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Dec 2017 17:46:04 -0500
In-Reply-To: <20171204224517.3409-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index b6ec02b96d3d..911b82226d13 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,7 +7,7 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.00.00.02-k"
+#define QLA2XXX_VERSION      "10.00.00.03-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	0
-- 
2.12.0
