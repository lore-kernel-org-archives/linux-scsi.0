From: Andy Yan <ayan@marvell.com>
Subject: [PATCH 7/7]MVSAS: Update to match latest libsas
Date: Mon, 9 Nov 2009 20:29:42 +0800
Message-ID: <20091109122942.GF32336@Andy.marvell.com>
Reply-To: ayan@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:56497 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbZKIDdG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Nov 2009 22:33:06 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, jeff@garzik.org, linux-scsi@vger.kernel.org
Cc: qswang@marvell.com, jfeng@marvell.com


>From 8687e06d9f636828e006fc4938513ce4731ea356 Mon Sep 17 00:00:00 2001
From: Andy <ayan@marvell.com>
Date: Sun, 8 Nov 2009 14:26:39 +0800
Subject: [PATCH 7/7] Update to match latest libsas

Signed-off-by: Andy <ayan@marvell.com>
Signed-off-by: Jacky <jfeng@marvell.com>
Signed-off-by: Ke <kewei@marvell.com>

---
 drivers/scsi/mvsas/mv_sas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 7ced157..51bb6fe 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -414,7 +414,7 @@ int mvs_slave_configure(struct scsi_device *sdev)
 		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, 1);
 	#endif
 	} else
-		sas_change_queue_depth(sdev, MVS_QUEUE_SIZE);
+		sas_change_queue_depth(sdev, MVS_QUEUE_SIZE, SCSI_QDEPTH_DEFAULT);
 
 	return 0;
 }
-- 
1.6.2.2

