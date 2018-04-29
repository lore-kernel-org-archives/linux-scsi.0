From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: mpt3sas: fix spelling mistake: "disbale" -> "disable"
Date: Sun, 29 Apr 2018 13:31:49 +0100
Message-ID: <20180429123149.11077-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in module parameter description text

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 61f93a134956..4edf1fc0e80c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -87,7 +87,7 @@ MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (default=0)");
 
 static int smp_affinity_enable = 1;
 module_param(smp_affinity_enable, int, S_IRUGO);
-MODULE_PARM_DESC(smp_affinity_enable, "SMP affinity feature enable/disbale Default: enable(1)");
+MODULE_PARM_DESC(smp_affinity_enable, "SMP affinity feature enable/disable Default: enable(1)");
 
 static int max_msix_vectors = -1;
 module_param(max_msix_vectors, int, 0);
-- 
2.17.0
