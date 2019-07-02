From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: bfa: Make two functions static
Date: Tue, 2 Jul 2019 21:23:24 +0800
Message-ID: <20190702132324.48136-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Fix sparse warnings:

drivers/scsi/bfa/bfa_ioc.c:6982:1: warning: symbol 'bfa_flash_sem_get' was not declared. Should it be static?
drivers/scsi/bfa/bfa_ioc.c:6995:1: warning: symbol 'bfa_flash_sem_put' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/bfa/bfa_ioc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 93471d7..aae1db1 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -6970,7 +6970,7 @@ bfa_raw_sem_get(void __iomem *bar)
 
 }
 
-bfa_status_t
+static bfa_status_t
 bfa_flash_sem_get(void __iomem *bar)
 {
 	u32 n = FLASH_BLOCKING_OP_MAX;
@@ -6983,7 +6983,7 @@ bfa_flash_sem_get(void __iomem *bar)
 	return BFA_STATUS_OK;
 }
 
-void
+static void
 bfa_flash_sem_put(void __iomem *bar)
 {
 	writel(0, (bar + FLASH_SEM_LOCK_REG));
-- 
2.7.4
