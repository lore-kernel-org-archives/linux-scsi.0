From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] scsi_dh_hp_sw: fix return value on failed allocation
Date: Thu, 30 Oct 2014 10:19:13 +0100
Message-ID: <1414660754-8431-6-git-send-email-hch@lst.de>
References: <1414660754-8431-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50859 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507AbaJ3JTH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 05:19:07 -0400
In-Reply-To: <1414660754-8431-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Sean Stewart <Sean.Stewart@netapp.com>, Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index aa40fcb..471ffd1 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -363,7 +363,7 @@ static int hp_sw_bus_attach(struct scsi_device *sdev)
 	if (!h) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach Failed\n",
 			    HP_SW_NAME);
-		return 0;
+		return -ENOMEM;
 	}
 
 	h->dh_data.scsi_dh = &hp_sw_dh;
-- 
1.9.1

