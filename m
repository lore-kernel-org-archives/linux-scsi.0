From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0909/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:57:10 +0800
Message-ID: <20160802115710.10567-1-baolex.ni@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934967AbcHBMgG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Aug 2016 08:36:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, QLogic-Storage-Upstream@qlogic.com, heiko.carstens@de.ibm.com, dwmw2@infradead.org, m.chehab@samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, baolex.ni@intel.com

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index c8b410c..2bdf2cf 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -39,31 +39,31 @@ MODULE_VERSION(DRV_MODULE_VERSION);
 static DEFINE_MUTEX(bnx2i_dev_lock);
 
 unsigned int event_coal_min = 24;
-module_param(event_coal_min, int, 0664);
+module_param(event_coal_min, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
 MODULE_PARM_DESC(event_coal_min, "Event Coalescing Minimum Commands");
 
 unsigned int event_coal_div = 2;
-module_param(event_coal_div, int, 0664);
+module_param(event_coal_div, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
 MODULE_PARM_DESC(event_coal_div, "Event Coalescing Divide Factor");
 
 unsigned int en_tcp_dack = 1;
-module_param(en_tcp_dack, int, 0664);
+module_param(en_tcp_dack, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
 MODULE_PARM_DESC(en_tcp_dack, "Enable TCP Delayed ACK");
 
 unsigned int error_mask1 = 0x00;
-module_param(error_mask1, uint, 0664);
+module_param(error_mask1, uint, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
 MODULE_PARM_DESC(error_mask1, "Config FW iSCSI Error Mask #1");
 
 unsigned int error_mask2 = 0x00;
-module_param(error_mask2, uint, 0664);
+module_param(error_mask2, uint, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
 MODULE_PARM_DESC(error_mask2, "Config FW iSCSI Error Mask #2");
 
 unsigned int sq_size;
-module_param(sq_size, int, 0664);
+module_param(sq_size, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
 MODULE_PARM_DESC(sq_size, "Configure SQ size");
 
 unsigned int rq_size = BNX2I_RQ_WQES_DEFAULT;
-module_param(rq_size, int, 0664);
+module_param(rq_size, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
 MODULE_PARM_DESC(rq_size, "Configure RQ size");
 
 u64 iscsi_error_mask = 0x00;
-- 
2.9.2

