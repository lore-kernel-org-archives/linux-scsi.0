From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: [PATCH 5/6] qedf: Fix up modinfo parameter name for 'debug' in modinfo output.
Date: Tue, 15 Aug 2017 10:08:20 -0700
Message-ID: <20170815170821.20806-6-chad.dupuis@cavium.com>
References: <20170815170821.20806-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0071.outbound.protection.outlook.com ([104.47.41.71]:14528
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752613AbdHORJT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 13:09:19 -0400
In-Reply-To: <20170815170821.20806-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Because we were passing 'qedf_debug' instead of 'debug' to the
MODULE_PARM_DESC() macro, modinfo listed the parameter name as 'qedf_debug'
instead of it's proper name 'debug'.  Correct the parameter name.

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 24e8d2ab099c..e192bde73147 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -43,7 +43,7 @@ MODULE_PARM_DESC(dev_loss_tmo,  " dev_loss_tmo setting for attached "
 
 uint qedf_debug = QEDF_LOG_INFO;
 module_param_named(debug, qedf_debug, uint, S_IRUGO);
-MODULE_PARM_DESC(qedf_debug, " Debug mask. Pass '1' to enable default debugging"
+MODULE_PARM_DESC(debug, " Debug mask. Pass '1' to enable default debugging"
 	" mask");
 
 static uint qedf_fipvlan_retries = 30;
-- 
2.12.3
