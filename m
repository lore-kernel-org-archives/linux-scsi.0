From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 1/1] target: target_core_xcopy: Remove version.h header inclusion
Date: Thu, 29 Aug 2013 11:28:05 +0530
Message-ID: <1377755885-16825-1-git-send-email-sachin.kamat@linaro.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org, sachin.kamat@linaro.org
List-Id: linux-scsi@vger.kernel.org

version.h header inclusion is not necessary as detected by
versioncheck.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/target/target_core_xcopy.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 7e12286..fb4b0c5 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -21,7 +21,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
-- 
1.7.9.5
