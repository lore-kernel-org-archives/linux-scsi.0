From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 25/31] qla2xxx: Enable Async TMF processing
Date: Wed, 23 Aug 2017 15:05:19 -0700
Message-ID: <20170823220525.3115-26-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0076.outbound.protection.outlook.com ([104.47.41.76]:13088
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751076AbdHWWk3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:40:29 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c217cec4dd49..0814ff4fa2c0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -200,7 +200,7 @@ MODULE_PARM_DESC(ql2xgffidenable,
 		"Enables GFF_ID checks of port type. "
 		"Default is 0 - Do not use GFF_ID information.");
 
-int ql2xasynctmfenable;
+int ql2xasynctmfenable = 1;
 module_param(ql2xasynctmfenable, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xasynctmfenable,
 		"Enables issue of TM IOCBs asynchronously via IOCB mechanism"
-- 
2.12.0
