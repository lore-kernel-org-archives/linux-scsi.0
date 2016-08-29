From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH] scsi: ufs: add missing header dependencies for tc-dwc-g210
Date: Mon, 29 Aug 2016 18:19:00 +0800
Message-ID: <1472465940-18570-1-git-send-email-baoyou.xie@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Joao.Pinto@synopsys.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@linaro.org, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn
List-Id: linux-scsi@vger.kernel.org

We get 2 warnings when build kernel with W=1:
drivers/scsi/ufs/tc-dwc-g210.c:261:5: warning: no previous prototype for 'tc_dwc_g210_config_40_bit' [-Wmissing-prototypes]
drivers/scsi/ufs/tc-dwc-g210.c:293:5: warning: no previous prototype for 'tc_dwc_g210_config_20_bit' [-Wmissing-prototypes]

In fact, these functions are declared in ufs/tc-dwc-g210.h, so this patch
add missing header dependencies

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/scsi/ufs/tc-dwc-g210.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/tc-dwc-g210.c b/drivers/scsi/ufs/tc-dwc-g210.c
index 70db6d9..dc03e47 100644
--- a/drivers/scsi/ufs/tc-dwc-g210.c
+++ b/drivers/scsi/ufs/tc-dwc-g210.c
@@ -15,6 +15,7 @@
 
 #include "ufshcd-dwc.h"
 #include "ufshci-dwc.h"
+#include "tc-dwc-g210.h"
 
 /**
  * tc_dwc_g210_setup_40bit_rmmi()
-- 
2.7.4
