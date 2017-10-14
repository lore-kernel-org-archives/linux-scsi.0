From: Christos Gkekas <chris.gekas@gmail.com>
Subject: [PATCH] [SCSI] sym53c8xx: Remove pointers scriptb0
Date: Sat, 14 Oct 2017 13:03:08 +0100
Message-ID: <1507982588-19955-1-git-send-email-chris.gekas@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christos Gkekas <chris.gekas@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Pointers 'scriptb0' are set but never used, so need to be deleted.

Signed-off-by: Christos Gkekas <chris.gekas@gmail.com>
---
 drivers/scsi/sym53c8xx_2/sym_fw.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_fw.c b/drivers/scsi/sym53c8xx_2/sym_fw.c
index 190770b..91db177 100644
--- a/drivers/scsi/sym53c8xx_2/sym_fw.c
+++ b/drivers/scsi/sym53c8xx_2/sym_fw.c
@@ -295,10 +295,8 @@ static void
 sym_fw1_setup(struct sym_hcb *np, struct sym_fw *fw)
 {
 	struct sym_fw1a_scr *scripta0;
-	struct sym_fw1b_scr *scriptb0;
 
 	scripta0 = (struct sym_fw1a_scr *) np->scripta0;
-	scriptb0 = (struct sym_fw1b_scr *) np->scriptb0;
 
 	/*
 	 *  Fill variable parts in scripts.
@@ -319,10 +317,8 @@ static void
 sym_fw2_setup(struct sym_hcb *np, struct sym_fw *fw)
 {
 	struct sym_fw2a_scr *scripta0;
-	struct sym_fw2b_scr *scriptb0;
 
 	scripta0 = (struct sym_fw2a_scr *) np->scripta0;
-	scriptb0 = (struct sym_fw2b_scr *) np->scriptb0;
 
 	/*
 	 *  Fill variable parts in scripts.
-- 
2.7.4
