From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0912/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:57:24 +0800
Message-ID: <20160802115724.10765-1-baolex.ni@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6327 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934906AbcHBMfR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Aug 2016 08:35:17 -0400
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
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 339f6b7..eb393c9 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -49,30 +49,30 @@ MODULE_DESCRIPTION(DRV_MODULE_DESC);
 MODULE_VERSION(DRV_MODULE_VERSION);
 MODULE_LICENSE("GPL");
 
-module_param(dbg_level, uint, 0644);
+module_param(dbg_level, uint, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(dbg_level, "Debug flag (default=0)");
 
 #define CXGB4I_DEFAULT_10G_RCV_WIN (256 * 1024)
 static int cxgb4i_rcv_win = -1;
-module_param(cxgb4i_rcv_win, int, 0644);
+module_param(cxgb4i_rcv_win, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(cxgb4i_rcv_win, "TCP reveive window in bytes");
 
 #define CXGB4I_DEFAULT_10G_SND_WIN (128 * 1024)
 static int cxgb4i_snd_win = -1;
-module_param(cxgb4i_snd_win, int, 0644);
+module_param(cxgb4i_snd_win, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(cxgb4i_snd_win, "TCP send window in bytes");
 
 static int cxgb4i_rx_credit_thres = 10 * 1024;
-module_param(cxgb4i_rx_credit_thres, int, 0644);
+module_param(cxgb4i_rx_credit_thres, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(cxgb4i_rx_credit_thres,
 		"RX credits return threshold in bytes (default=10KB)");
 
 static unsigned int cxgb4i_max_connect = (8 * 1024);
-module_param(cxgb4i_max_connect, uint, 0644);
+module_param(cxgb4i_max_connect, uint, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(cxgb4i_max_connect, "Maximum number of connections");
 
 static unsigned short cxgb4i_sport_base = 20000;
-module_param(cxgb4i_sport_base, ushort, 0644);
+module_param(cxgb4i_sport_base, ushort, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(cxgb4i_sport_base, "Starting port number (default 20000)");
 
 typedef void (*cxgb4i_cplhandler_func)(struct cxgbi_device *, struct sk_buff *);
-- 
2.9.2

