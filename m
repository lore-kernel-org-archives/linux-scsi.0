From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] [SCSI] qla2xxx: Get rid of unneeded includes of version.h
Date: Sun, 10 Jun 2012 02:59:44 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1206100258400.15651@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-driver@qlogic.com, Andrew Vasquez <andrew.vasquez@qlogic.com>, trivial@kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/qla2xxx/qla_target.c |    1 -
 drivers/scsi/qla2xxx/qla_target.h |    2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 04f80eb..f7a49e4 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -26,7 +26,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/types.h>
-#include <linux/version.h>
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 9ec19bc..7df4df5 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -919,8 +919,6 @@ struct qla_tgt_srr_ctio {
 #define QLA_TGT_XMIT_STATUS		2
 #define QLA_TGT_XMIT_ALL		(QLA_TGT_XMIT_STATUS|QLA_TGT_XMIT_DATA)
 
-#include <linux/version.h>
-
 extern struct qla_tgt_data qla_target;
 /*
  * Internal function prototypes
-- 
1.7.10.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
