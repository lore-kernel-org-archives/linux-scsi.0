From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: lpfc: fix spelling mistake "Resrouce" -> "Resource"
Date: Tue, 16 Oct 2018 18:28:53 +0100
Message-ID: <20181016172853.1398-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in lpfc_printf_log message text.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0bd3ae99c4a6..20fa6785a0e2 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7993,7 +7993,7 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 	else
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"3028 GET_FUNCTION_CONFIG: failed to find "
-				"Resrouce Descriptor:x%x\n",
+				"Resource Descriptor:x%x\n",
 				LPFC_RSRC_DESC_TYPE_FCFCOE);
 
 read_cfg_out:
-- 
2.19.1
