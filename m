From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH V2 07/15] qedf: Set qed logging level to QED_LEVEL_NOTICE.
Date: Wed, 31 May 2017 06:33:54 -0700
Message-ID: <20170531133402.16629-8-chad.dupuis@cavium.com>
References: <20170531133402.16629-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0040.outbound.protection.outlook.com ([104.47.38.40]:11429
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751022AbdEaNe3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 May 2017 09:34:29 -0400
In-Reply-To: <20170531133402.16629-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Reduce the logging level we set for qed messages pertaining to this PCI
function so that unnecessary messages are not printed in the kernel
message log.

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 884103b..d08793e 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -95,7 +95,7 @@
 MODULE_PARM_DESC(dp_module, " bit flags control for verbose printk passed "
 	"qed module during probe.");
 
-static uint qedf_dp_level;
+static uint qedf_dp_level = QED_LEVEL_NOTICE;
 module_param_named(dp_level, qedf_dp_level, uint, S_IRUGO);
 MODULE_PARM_DESC(dp_level, " printk verbosity control passed to qed module  "
 	"during probe (0-3: 0 more verbose).");
-- 
1.8.5.6
