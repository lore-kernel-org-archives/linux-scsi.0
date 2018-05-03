From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: lpfc: fix spelling mistake: "mabilbox" -> "mailbox"
Date: Thu,  3 May 2018 10:19:01 +0100
Message-ID: <20180503091901.29547-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in lpfc_printf_log log message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 060f0e2f6ff5..dc4334fa41bb 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5117,7 +5117,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_FIP |
 					LOG_DISCOVERY,
-					"2772 Issue FCF rediscover mabilbox "
+					"2772 Issue FCF rediscover mailbox "
 					"command failed, fail through to FCF "
 					"dead event\n");
 			spin_lock_irq(&phba->hbalock);
@@ -5209,7 +5209,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
 				lpfc_printf_log(phba, KERN_ERR, LOG_FIP |
 						LOG_DISCOVERY,
 						"2774 Issue FCF rediscover "
-						"mabilbox command failed, "
+						"mailbox command failed, "
 						"through to CVL event\n");
 				spin_lock_irq(&phba->hbalock);
 				phba->fcf.fcf_flag &= ~FCF_ACVL_DISC;
-- 
2.17.0
