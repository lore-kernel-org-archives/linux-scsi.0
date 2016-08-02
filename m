From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0911/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:57:19 +0800
Message-ID: <20160802115719.10699-1-baolex.ni@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41070 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965104AbcHBMfO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Aug 2016 08:35:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kxie@chelsio.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, heiko.carstens@de.ibm.com, dwmw2@infradead.org, m.chehab@samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, baolex.ni@intel.com

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index e22a268..59fa6fd 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -44,28 +44,28 @@ MODULE_DESCRIPTION(DRV_MODULE_DESC);
 MODULE_VERSION(DRV_MODULE_VERSION);
 MODULE_LICENSE("GPL");
 
-module_param(dbg_level, uint, 0644);
+module_param(dbg_level, uint, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(dbg_level, "debug flag (default=0)");
 
 static int cxgb3i_rcv_win = 256 * 1024;
-module_param(cxgb3i_rcv_win, int, 0644);
+module_param(cxgb3i_rcv_win, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(cxgb3i_rcv_win, "TCP receive window in bytes (default=256KB)");
 
 static int cxgb3i_snd_win = 128 * 1024;
-module_param(cxgb3i_snd_win, int, 0644);
+module_param(cxgb3i_snd_win, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(cxgb3i_snd_win, "TCP send window in bytes (default=128KB)");
 
 static int cxgb3i_rx_credit_thres = 10 * 1024;
-module_param(cxgb3i_rx_credit_thres, int, 0644);
+module_param(cxgb3i_rx_credit_thres, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(cxgb3i_rx_credit_thres,
 		 "RX credits return threshold in bytes (default=10KB)");
 
 static unsigned int cxgb3i_max_connect = 8 * 1024;
-module_param(cxgb3i_max_connect, uint, 0644);
+module_param(cxgb3i_max_connect, uint, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(cxgb3i_max_connect, "Max. # of connections (default=8092)");
 
 static unsigned int cxgb3i_sport_base = 20000;
-module_param(cxgb3i_sport_base, uint, 0644);
+module_param(cxgb3i_sport_base, uint, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(cxgb3i_sport_base, "starting port number (default=20000)");
 
 static void cxgb3i_dev_open(struct t3cdev *);
-- 
2.9.2

