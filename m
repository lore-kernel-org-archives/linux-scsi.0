From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 30/41] scsi: megaraid_sas_fusion: Mark expected switch
 fall-through
Date: Tue, 27 Nov 2018 22:32:34 -0600
Message-ID: <5fceeac101cc3dfe4a129764a139c1b616cba292.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, megaraidlinux.pdl@broadcom.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Notice that, in this particular case, I replaced "Fall thru" with a
"Fall through" annotation and added a dash as a token in order to
separate the "Fall through" annotation from the rest of the comment
on the same line, which is what GCC is expecting to find.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index c5e6bccb0895..8f37ad83be9a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3453,7 +3453,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 				atomic_dec(&lbinfo->scsi_pending_cmds[cmd_fusion->pd_r1_lb]);
 				cmd_fusion->scmd->SCp.Status &= ~MEGASAS_LOAD_BALANCE_FLAG;
 			}
-			//Fall thru and complete IO
+			/* Fall through - and complete IO */
 		case MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST: /* LD-IO Path */
 			atomic_dec(&instance->fw_outstanding);
 			if (cmd_fusion->r1_alt_dev_handle == MR_DEVHANDLE_INVALID) {
-- 
2.17.1
