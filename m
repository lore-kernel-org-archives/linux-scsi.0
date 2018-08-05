From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: csiostor: Use true and false for boolean values
Date: Sat, 4 Aug 2018 19:39:49 -0500
Message-ID: <20180805003949.GA32476@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

Return statements in functions returning bool should use true or false
instead of an integer value.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/csiostor/csio_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index dab0d3f..aae7abc 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -147,9 +147,9 @@ csio_scsi_itnexus_loss_error(uint16_t error)
 	case FW_ERR_RDEV_LOST:
 	case FW_ERR_RDEV_LOGO:
 	case FW_ERR_RDEV_IMPL_LOGO:
-		return 1;
+		return true;
 	}
-	return 0;
+	return false;
 }
 
 /*
-- 
2.7.4
