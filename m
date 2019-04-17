From: Yue Haibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: lpfc: Make lpfc_sli4_oas_verify static
Date: Wed, 17 Apr 2019 23:05:54 +0800
Message-ID: <20190417150554.34844-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fix sparse warning:

drivers/scsi/lpfc/lpfc_init.c:13091:1: warning:
 symbol 'lpfc_sli4_oas_verify' was not declared. Should it be static?

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 8e0de48..eaaef68 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13087,7 +13087,7 @@ lpfc_io_resume(struct pci_dev *pdev)
  * is destroyed.
  *
  **/
-void
+static void
 lpfc_sli4_oas_verify(struct lpfc_hba *phba)
 {
 
-- 
2.7.4
