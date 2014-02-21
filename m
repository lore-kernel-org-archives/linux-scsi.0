From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: [PATCH] [SCSI] lpfc 8.3.43: use NULL instead of 0 for pointer
Date: Fri, 21 Feb 2014 10:10:24 +0900
Message-ID: <1790992.BDi3De8mQ2@daeseok-laptop.cloud.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: james.smart@emulex.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>From 9e7478f6e953fac5b2bef0f5abe76fe8dc9e59d1 Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Fri, 21 Feb 2014 09:03:32 +0900
Subject: [PATCH] [SCSI] lpfc 8.3.43: use NULL instead of 0 for pointer

sparse says:
drivers/scsi/lpfc/lpfc_sli.c:16547:37: warning:
 Using plain integer as NULL pointer

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 8f580fd..a218ecd 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -16544,7 +16544,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 {
 	LIST_HEAD(completions);
 	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
-	struct lpfc_iocbq *piocbq = 0;
+	struct lpfc_iocbq *piocbq = NULL;
 	unsigned long iflags = 0;
 	char *fail_msg = NULL;
 	struct lpfc_sglq *sglq;
-- 
1.7.9.5

---
