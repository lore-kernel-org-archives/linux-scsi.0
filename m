From: Matei Oprea <eu@opreamatei.ro>
Subject: [PATCH] Scsi: lpfc: lpfc_init: Remove useless casting value
Date: Wed, 12 Mar 2014 23:20:47 +0200
Message-ID: <1394659247-20037-1-git-send-email-eu@opreamatei.ro>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Matei Oprea <eu@opreamatei.ro>, ROSEdu Kernel Community <firefly@lists.rosedu.org>
List-Id: linux-scsi@vger.kernel.org

Remove useless casting value returned by k[cmz]alloc
to (struct lpfc_sli_ring *).

Found using coccinelle

Signed-off-by: Matei Oprea <eu@opreamatei.ro>
Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
---
 drivers/scsi/lpfc/lpfc_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 68c94cc..47d2c20 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4731,8 +4731,7 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	}
 
 	if (!phba->sli.ring)
-		phba->sli.ring = (struct lpfc_sli_ring *)
-			kzalloc(LPFC_SLI3_MAX_RING *
+		phba->sli.ring = kzalloc(LPFC_SLI3_MAX_RING *
 			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
 	if (!phba->sli.ring)
 		return -ENOMEM;
-- 
1.7.9.5
