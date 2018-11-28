From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 35/41] scsi: ppa: mark expected switch fall-through
Date: Tue, 27 Nov 2018 22:33:36 -0600
Message-ID: <ac6de237bf4ee2d748eed7bbc3b2582f54650c0a.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 114988 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/ppa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index ee86a0c62dbf..d29999ba5458 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -717,6 +717,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 			}
 			cmd->SCp.phase++;
 		}
+		/* fall through */
 
 	case 2:		/* Phase 2 - We are now talking to the scsi bus */
 		if (!ppa_select(dev, scmd_id(cmd))) {
-- 
2.17.1
