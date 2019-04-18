From: Pedro Sousa <PedroM.Sousa@synopsys.com>
Subject: [PATCH] scsi: ufs: Fix RX_TERMINATION_FORCE_ENABLE define value
Date: Thu, 18 Apr 2019 21:13:34 +0200
Message-ID: <87405e9b14c6eb01b395f01eac4ab085e8020ff7.1555614814.git.sousa@synopsys.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: alim.akhtar@samsung.com, avri.altman@wdc.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, Pedro Sousa <PedroM.Sousa@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

Fix RX_TERMINATION_FORCE_ENABLE define value from 0x0089 to 0x00A9
according to MIPI Alliance MPHY specification.

Fixes: e785060ea3a1 ("ufs: definitions for phy interface")
Cc: stable@vger.kernel.org
Signed-off-by: Pedro Sousa <sousa@synopsys.com>
---
 drivers/scsi/ufs/unipro.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 23129d7..c77e365 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -52,7 +52,7 @@
 #define RX_HS_UNTERMINATED_ENABLE		0x00A6
 #define RX_ENTER_HIBERN8			0x00A7
 #define RX_BYPASS_8B10B_ENABLE			0x00A8
-#define RX_TERMINATION_FORCE_ENABLE		0x0089
+#define RX_TERMINATION_FORCE_ENABLE		0x00A9
 #define RX_MIN_ACTIVATETIME_CAPABILITY		0x008F
 #define RX_HIBERN8TIME_CAPABILITY		0x0092
 #define RX_REFCLKFREQ				0x00EB
-- 
2.7.4
