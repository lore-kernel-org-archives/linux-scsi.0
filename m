From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] fix typo in scsi_handle_queue_ramp_up()
Date: Mon, 1 Nov 2010 21:25:04 +0800
Message-ID: <AANLkTi=5cnxWBjHcBKSpWjX+osgWJNNsqLdNtovCzpjo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64394 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725Ab0KANZG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2010 09:25:06 -0400
Received: by wwe15 with SMTP id 15so6026453wwe.1
        for <linux-scsi@vger.kernel.org>; Mon, 01 Nov 2010 06:25:05 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

There seems cleanup of typo needed.

If only sdev is concerned its time mark could be updated after scanning devices.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/scsi_error.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/scsi_error.c	2010-11-01 20:50:32.000000000 +0800
@@ -394,7 +394,7 @@ static void scsi_handle_queue_ramp_up(st
 		 */
 		sht->change_queue_depth(tmp_sdev, tmp_sdev->queue_depth + 1,
 					SCSI_QDEPTH_RAMP_UP);
-		sdev->last_queue_ramp_up = jiffies;
+		tmp_sdev->last_queue_ramp_up = jiffies;
 	}
 }
