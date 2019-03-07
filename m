From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] scsi/NCR5380: Avoid compiler warning when
 -Wimplicit-fallthrough is enabled
Date: Fri, 08 Mar 2019 08:49:02 +1100
Message-ID: <4e853f171366e040818346def7fb043347670662.1551995342.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Adjust comments accordingly.

Cc: Gustavo A. R. Silva <gustavo@embeddedor.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 7fed9bb72784..fe0535affc14 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1932,13 +1932,13 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					if (!hostdata->connected)
 						return;
 
-					/* Fall through to reject message */
-
+					/* Reject message */
+					/* Fall through */
+				default:
 					/*
 					 * If we get something weird that we aren't expecting,
-					 * reject it.
+					 * log it.
 					 */
-				default:
 					if (tmp == EXTENDED_MESSAGE)
 						scmd_printk(KERN_INFO, cmd,
 						            "rejecting unknown extended message code %02x, length %d\n",
-- 
2.19.2
