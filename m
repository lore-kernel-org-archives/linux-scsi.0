From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 04/41] scsi: aacraid: linit: Mark expected switch fall-through
Date: Tue, 27 Nov 2018 22:26:09 -0600
Message-ID: <d59c13880a70724c3645d96945bf8a128f835244.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/aacraid/linit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 2d4e4ddc5ace..42defee90eb2 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -759,6 +759,7 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 			    !(aac->raw_io_64) ||
 			    ((cmd->cmnd[1] & 0x1f) != SAI_READ_CAPACITY_16))
 				break;
+			/* fall through */
 		case INQUIRY:
 		case READ_CAPACITY:
 			/*
-- 
2.17.1
