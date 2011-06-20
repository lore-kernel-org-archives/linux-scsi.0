From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH][Trivial] SCSI, Target, tcm_loop: Remove include duplicate
Date: Mon, 20 Jun 2011 10:49:52 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1106201044310.18991@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, linux-kernel@vger.kernel.org, trivial@kernel.org, "Nicholas A. Bellinger" <nab@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

Commit e66ecd50 added a duplicate include of scsi/scsi_tcq.h to 
drivers/target/loopback/tcm_loop.c - this patch removes the duplicate.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 tcm_loop.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index dee2a2c..ee95903 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -31,7 +31,6 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_tcq.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_transport.h>

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
