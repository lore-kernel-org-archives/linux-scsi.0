From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] tcm_fc: missing curly braces in ft_invl_hw_context()
Date: Wed, 25 Feb 2015 16:21:03 +0300
Message-ID: <20150225132103.GH19745@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Kiran Patil <kiran.patil@intel.com>
Cc: Vasu Dev <vasu.dev@linux.intel.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>From the indenting, it looks like curly braces were intended here.

Fixes: dcd998ccdbf7 ('tcm_fc: Handle DDP/SW fc_frame_payload_get failures in ft_recv_write_data')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 97b486c..583e755 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -359,7 +359,7 @@ void ft_invl_hw_context(struct ft_cmd *cmd)
 		ep = fc_seq_exch(seq);
 		if (ep) {
 			lport = ep->lp;
-			if (lport && (ep->xid <= lport->lro_xid))
+			if (lport && (ep->xid <= lport->lro_xid)) {
 				/*
 				 * "ddp_done" trigger invalidation of HW
 				 * specific DDP context
@@ -374,6 +374,7 @@ void ft_invl_hw_context(struct ft_cmd *cmd)
 				 * identified using ep->xid)
 				 */
 				cmd->was_ddp_setup = 0;
+			}
 		}
 	}
 }
