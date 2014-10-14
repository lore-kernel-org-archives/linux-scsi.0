From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] scsi: Resolve some missing-field-initializers warnings
Date: Tue, 14 Oct 2014 06:38:53 -0700
Message-ID: <1413293933-31164-1-git-send-email-jeffrey.t.kirsher@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
List-Id: linux-scsi@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Resolve some missing-field-initializers warnings by using
designated initialization.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index db8c449..4d59256 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -47,7 +47,7 @@ struct scsi_host_sg_pool {
 	mempool_t	*pool;
 };
 
-#define SP(x) { x, "sgpool-" __stringify(x) }
+#define SP(x) { .size = x, "sgpool-" __stringify(x) }
 #if (SCSI_MAX_SG_SEGMENTS < 32)
 #error SCSI_MAX_SG_SEGMENTS is too small (must be 32 or greater)
 #endif
-- 
1.9.3
