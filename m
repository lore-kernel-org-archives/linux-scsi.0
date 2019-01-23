From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: qlogicfas408: clean up a couple of indentation issues
Date: Wed, 23 Jan 2019 13:10:04 +0000
Message-ID: <20190123131004.24460-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

An if statement is indented correctly and an outb statement has
a redundant empty comment and incorrect indentation. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qlogicfas408.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index 8b471a925b43..136681ad18a5 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -139,7 +139,7 @@ static int ql_pdma(struct qlogicfas408_priv *priv, int phase, char *request, int
 	} else {		/* out */
 #if QL_TURBO_PDMA
 		rtrc(4)
-		    if (reqlen >= 128 && inb(qbase + 8) & 0x10) {	/* empty */
+		if (reqlen >= 128 && inb(qbase + 8) & 0x10) {	/* empty */
 			outsl(qbase + 4, request, 32);
 			reqlen -= 128;
 			request += 128;
@@ -240,7 +240,7 @@ static void ql_icmd(struct scsi_cmnd *cmd)
 	outb(0x40 | qlcfg8 | priv->qinitid, qbase + 8);
 	outb(qlcfg7, qbase + 7);
 	outb(qlcfg6, qbase + 6);
-	 /**/ outb(qlcfg5, qbase + 5);	/* select timer */
+	outb(qlcfg5, qbase + 5);	/* select timer */
 	outb(qlcfg9 & 7, qbase + 9);	/* prescaler */
 /*	outb(0x99, qbase + 5);	*/
 	outb(scmd_id(cmd), qbase + 4);
-- 
2.19.1
