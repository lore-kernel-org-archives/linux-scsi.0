From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0906/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:56:56 +0800
Message-ID: <20160802115656.10369-1-baolex.ni@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37590 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934856AbcHBMf4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Aug 2016 08:35:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, heiko.carstens@de.ibm.com, dwmw2@infradead.org, m.chehab@samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, baolex.ni@intel.com

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/scsi/aic7xxx/aic7xxx_osm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index fc6a831..0fbbd81 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -330,7 +330,7 @@ MODULE_AUTHOR("Maintainer: Hannes Reinecke <hare@suse.de>");
 MODULE_DESCRIPTION("Adaptec AIC77XX/78XX SCSI Host Bus Adapter driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(AIC7XXX_DRIVER_VERSION);
-module_param(aic7xxx, charp, 0444);
+module_param(aic7xxx, charp, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(aic7xxx,
 "period-delimited options string:\n"
 "	verbose			Enable verbose/diagnostic logging\n"
-- 
2.9.2

