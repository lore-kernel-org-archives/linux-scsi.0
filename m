From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] scsi.c::scsi_adjust_queue_depth(): adjust only once
Date: Wed, 13 Oct 2004 21:40:02 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0410132135240.3426@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:25526 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S267807AbUJMUFa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 16:05:30 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Well, I spent, I think, about 5 minutes looking at this, and I still 
cannot understand why this is needed. The best way to find out if I am 
right or not is to send a patch:-) So, here goes.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

diff -u a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	17 Aug 2004 20:34:45
+++ b/drivers/scsi/scsi.c	13 Oct 2004 19:09:25
@@ -924,7 +924,6 @@
 				sdev->channel, sdev->id, sdev->lun); 
 		case 0:
 			sdev->ordered_tags = sdev->simple_tags = 0;
-			sdev->queue_depth = tags;
 			break;
 	}
  out:
 
Thanks
Guennadi
---
Guennadi Liakhovetski

