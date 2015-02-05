From: Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH] scsi: fix sparse warning
Date: Thu,  5 Feb 2015 11:29:27 +0000
Message-ID: <1423135767-18498-1-git-send-email-prabhakar.csengg@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch fixes following sparse warning:

scsi_debug.c:2687:6: warning: symbol 'dump_sector' was not declared. Should it be static?

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Found this issue on linux-next (gcc  version 4.9.2,
 sparse version  0.4.5-rc1)and applies on top linux-next.

 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1f8e2dc..e8c048b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2684,7 +2684,7 @@ resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return 0;
 }
 
-void dump_sector(unsigned char *buf, int len)
+static void dump_sector(unsigned char *buf, int len)
 {
 	int i, j, n;
 
-- 
1.9.1
