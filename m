From: Joe Perches <joe@perches.com>
Subject: [PATCH 13/25] csiostor: Use bool function return values of true/false not 1/0
Date: Mon, 30 Mar 2015 16:46:11 -0700
Message-ID: <8e9f2c8a93f5575b5a502757fa45096fa4f01f98.1427759009.git.joe@perches.com>
References: <cover.1427759009.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1427759009.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use the normal return values for bool functions

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/csiostor/csio_scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 2c4562d..5754fb6 100644
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
2.1.2
