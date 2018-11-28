From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 21/41] scsi: libfc: fc_rport: Mark expected switch
 fall-through
Date: Tue, 27 Nov 2018 22:30:55 -0600
Message-ID: <1713e55b2fa29809530bc694c37d9cadb22c6f98.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/libfc/fc_rport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 638f42a5200e..9192a1d9dec6 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1722,6 +1722,7 @@ static void fc_rport_recv_els_req(struct fc_lport *lport, struct fc_frame *fp)
 			kref_put(&rdata->kref, fc_rport_destroy);
 			goto busy;
 		}
+		/* fall through */
 	default:
 		FC_RPORT_DBG(rdata,
 			     "Reject ELS 0x%02x while in state %s\n",
-- 
2.17.1
