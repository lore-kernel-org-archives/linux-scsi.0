From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] scsi: remove duplicated code in scsi_adjust_queue_depth.
Date: Wed,  6 Jun 2012 08:23:46 -0400
Message-ID: <1338985426-9796-1-git-send-email-linkinjeon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Remove duplicated code in scsi_adjust_queue_depth.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 drivers/scsi/scsi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 61c82a3..b570d9c 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -909,7 +909,6 @@ void scsi_adjust_queue_depth(struct scsi_device *sdev, int tagged, int tags)
 				    "disabled\n");
 		case 0:
 			sdev->ordered_tags = sdev->simple_tags = 0;
-			sdev->queue_depth = tags;
 			break;
 	}
  out:
-- 
1.7.9.5
