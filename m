From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 1/3] qla2xxx: Clear fc4f_nvme flag
Date: Wed, 30 Aug 2017 10:16:48 -0700
Message-ID: <20170830171650.32341-2-himanshu.madhani@cavium.com>
References: <20170830171650.32341-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0058.outbound.protection.outlook.com ([104.47.37.58]:19456
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751883AbdH3RQ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Aug 2017 13:16:57 -0400
In-Reply-To: <20170830171650.32341-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Darren Trap <darren.trap@cavium.com>

Signed-off-by: Darren Trap <darren.trap@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 30b3acacbfca..73a6c3abb115 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4937,6 +4937,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 				new_fcport->fc4_type = swl[swl_idx].fc4_type;
 
 				new_fcport->nvme_flag = 0;
+				new_fcport->fc4f_nvme = 0;
 				if (vha->flags.nvme_enabled &&
 				    swl[swl_idx].fc4f_nvme) {
 					new_fcport->fc4f_nvme =
-- 
2.12.0
