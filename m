From: Matei Oprea <eu@opreamatei.ro>
Subject: [PATCH] scsi: lpfc: lpfc_init: use kcalloc for allocating memory
Date: Tue, 18 Mar 2014 22:51:40 +0200
Message-ID: <1395175900-9659-1-git-send-email-eu@opreamatei.ro>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jbottomley@parallels.com
Cc: james.smart@emulex.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Matei Oprea <eu@opreamatei.ro>, ROSEdu Kernel Community <firefly@lists.rosedu.org>
List-Id: linux-scsi@vger.kernel.org

It's easier to use kcalloc for allocating arrays. While at it
also remove useless casting value.

Signed-off-by: Matei Oprea <eu@opreamatei.ro>
Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
---
 drivers/scsi/lpfc/lpfc_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 68c94cc..0a51ca5 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4731,9 +4731,9 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
 	}
 
 	if (!phba->sli.ring)
-		phba->sli.ring = (struct lpfc_sli_ring *)
-			kzalloc(LPFC_SLI3_MAX_RING *
+		phba->sli.ring = kcalloc(LPFC_SLI3_MAX_RING,
 			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
+
 	if (!phba->sli.ring)
 		return -ENOMEM;
 
-- 
1.7.9.5
