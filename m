From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH V2 13/15] qedf: Change cmd_per_lun in scsi_host_template to 32 to increase performance.
Date: Wed, 31 May 2017 06:34:00 -0700
Message-ID: <20170531133402.16629-14-chad.dupuis@cavium.com>
References: <20170531133402.16629-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0056.outbound.protection.outlook.com ([104.47.38.56]:4971
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751019AbdEaNfE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 May 2017 09:35:04 -0400
In-Reply-To: <20170531133402.16629-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Increase the default number of commands that the driver tells the
SCSI mid-layer it can do to increase the default performance of the
driver.

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 4b688d6..27a9e26 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -708,7 +708,7 @@ static int qedf_slave_configure(struct scsi_device *sdev)
 	.module 	= THIS_MODULE,
 	.name 		= QEDF_MODULE_NAME,
 	.this_id 	= -1,
-	.cmd_per_lun 	= 3,
+	.cmd_per_lun	= 32,
 	.use_clustering = ENABLE_CLUSTERING,
 	.max_sectors 	= 0xffff,
 	.queuecommand 	= qedf_queuecommand,
-- 
1.8.5.6
