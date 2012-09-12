From: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 6/15] drivers/scsi/pmcraid.c: removes unnecessary semicolon
Date: Wed, 12 Sep 2012 19:03:13 +0200
Message-ID: <1347469402-27557-6-git-send-email-peter.senna@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/scsi/pmcraid.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index af763ea..5fb03c9 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3186,7 +3186,7 @@ static u8 pmcraid_task_attributes(struct scsi_cmnd *scsi_cmd)
 		case MSG_ORDERED_TAG:
 			rc = TASK_TAG_ORDERED;
 			break;
-		};
+		}
 	}
 
 	return rc;
@@ -5325,7 +5325,7 @@ static int __devinit pmcraid_init_instance(
 			mapped_pci_addr + chip_cfg->ioa_host_mask_clr;
 		pint_regs->global_interrupt_mask_reg =
 			mapped_pci_addr + chip_cfg->global_intr_mask;
-	};
+	}
 
 	pinstance->ioa_reset_attempts = 0;
 	init_waitqueue_head(&pinstance->reset_wait_q);
