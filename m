From: Baole Ni <baolex.ni@intel.com>
Subject: [PATCH 0905/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:56:51 +0800
Message-ID: <20160802115651.10303-1-baolex.ni@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, heiko.carstens@de.ibm.com, dwmw2@infradead.org, m.chehab@samsung.com, pawel@osciak.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com, baolex.ni@intel.com
List-Id: linux-scsi@vger.kernel.org

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 2588b8f..efc6256 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -320,7 +320,7 @@ MODULE_AUTHOR("Maintainer: Hannes Reinecke <hare@suse.de>");
 MODULE_DESCRIPTION("Adaptec AIC790X U320 SCSI Host Bus Adapter driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(AIC79XX_DRIVER_VERSION);
-module_param(aic79xx, charp, 0444);
+module_param(aic79xx, charp, S_IRUSR | S_IRGRP | S_IROTH);
 MODULE_PARM_DESC(aic79xx,
 "period-delimited options string:\n"
 "	verbose			Enable verbose/diagnostic logging\n"
-- 
2.9.2
