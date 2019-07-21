From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: fcoe: fix a typo
Date: Sun, 21 Jul 2019 14:50:39 +0200
Message-ID: <20190721125039.13268-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.de, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

#define relative to FCOE CTLR start with FCOE_CTLR, except
FCOE_CTRL_SOL_TOV.

This is likely a typo and CTRL should be CTLR here as well.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 2 +-
 include/scsi/libfcoe.h        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 0d7770d07405..5aaa3298de6f 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1019,7 +1019,7 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
 	struct fcoe_fcf *fcf;
 	struct fcoe_fcf new;
-	unsigned long sol_tov = msecs_to_jiffies(FCOE_CTRL_SOL_TOV);
+	unsigned long sol_tov = msecs_to_jiffies(FCOE_CTLR_SOL_TOV);
 	int first = 0;
 	int mtu_valid;
 	int found = 0;
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index c50fb297e265..dc14b52577f7 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -31,7 +31,7 @@
  * FIP tunable parameters.
  */
 #define FCOE_CTLR_START_DELAY	2000	/* mS after first adv. to choose FCF */
-#define FCOE_CTRL_SOL_TOV	2000	/* min. solicitation interval (mS) */
+#define FCOE_CTLR_SOL_TOV	2000	/* min. solicitation interval (mS) */
 #define FCOE_CTLR_FCF_LIMIT	20	/* max. number of FCF entries */
 #define FCOE_CTLR_VN2VN_LOGIN_LIMIT 3	/* max. VN2VN rport login retries */
 
-- 
2.20.1
