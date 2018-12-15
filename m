From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: bfa: clean up a couple of indentation issues
Date: Sat, 15 Dec 2018 14:28:09 +0000
Message-ID: <20181215142809.31115-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a break statement with an extra space that needs removed and
a call to bfa_trc that is indented one level too much. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/bfa/bfa_ioc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 16d3aeb0e572..9631877aba4f 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -3819,7 +3819,7 @@ bfa_sfp_scn(struct bfa_sfp_s *sfp, struct bfi_mbmsg_s *msg)
 		sfp->state = BFA_SFP_STATE_REMOVED;
 		sfp->data_valid = 0;
 		bfa_sfp_scn_aen_post(sfp, rsp);
-		 break;
+		break;
 	case BFA_SFP_SCN_FAILED:
 		sfp->state = BFA_SFP_STATE_FAILED;
 		sfp->data_valid = 0;
@@ -5763,7 +5763,7 @@ bfa_phy_intr(void *phyarg, struct bfi_mbmsg_s *msg)
 				(struct bfa_phy_stats_s *) phy->ubuf;
 			bfa_phy_ntoh32((u32 *)stats, (u32 *)phy->dbuf_kva,
 				sizeof(struct bfa_phy_stats_s));
-				bfa_trc(phy, stats->status);
+			bfa_trc(phy, stats->status);
 		}
 
 		phy->status = status;
-- 
2.19.1
