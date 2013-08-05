From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH] drivers/scsi/lpfc/lpfc_init.c: adjust code alignment
Date: Mon,  5 Aug 2013 16:47:37 +0200
Message-ID: <1375714059-29567-3-git-send-email-Julia.Lawall@lip6.fr>
References: <1375714059-29567-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1375714059-29567-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Adjust code alignment so that each statement is lined up with its neighbor.

In the second case, it could be desirable to put the call to
lpfc_destroy_vport_work_array under the if.  The call, is, however, safe
in case vports is NULL, so the patch just adjusts the indentation to
reflect the current semantics.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---

 drivers/scsi/lpfc/lpfc_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index e0b20fa..f870421 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -692,7 +692,7 @@ lpfc_hba_init_link_fc_topology(struct lpfc_hba *phba, uint32_t fc_topology,
 			"1302 Invalid speed for this board:%d "
 			"Reset link speed to auto.\n",
 			phba->cfg_link_speed);
-			phba->cfg_link_speed = LPFC_USER_LINK_SPEED_AUTO;
+		phba->cfg_link_speed = LPFC_USER_LINK_SPEED_AUTO;
 	}
 	lpfc_init_link(phba, pmb, fc_topology, phba->cfg_link_speed);
 	pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
@@ -2702,7 +2702,7 @@ lpfc_online(struct lpfc_hba *phba)
 			}
 			spin_unlock_irq(shost->host_lock);
 		}
-		lpfc_destroy_vport_work_array(phba, vports);
+	lpfc_destroy_vport_work_array(phba, vports);
 
 	lpfc_unblock_mgmt_io(phba);
 	return 0;
