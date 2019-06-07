From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial] [SCSI] aic7xxx: Spelling s/configuraion/configuration/
Date: Fri,  7 Jun 2019 13:27:36 +0200
Message-ID: <20190607112736.14004-1-geert+renesas@glider.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jiri Kosina <trivial@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/scsi/aic7xxx/aic7xxx.reg | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx.reg b/drivers/scsi/aic7xxx/aic7xxx.reg
index ba0b411d03e2e1fa..00fde2243e486cbd 100644
--- a/drivers/scsi/aic7xxx/aic7xxx.reg
+++ b/drivers/scsi/aic7xxx/aic7xxx.reg
@@ -1666,7 +1666,7 @@ scratch_ram {
 	size		6
 	/*
 	 * These are reserved registers in the card's scratch ram on the 2742.
-	 * The EISA configuraiton chip is mapped here.  On Rev E. of the
+	 * The EISA configuration chip is mapped here.  On Rev E. of the
 	 * aic7770, the sequencer can use this area for scratch, but the
 	 * host cannot directly access these registers.  On later chips, this
 	 * area can be read and written by both the host and the sequencer.
-- 
2.17.1
