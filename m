From: Ying Chu <jasonchu@marvell.com>
Subject: [PATCH 4/4] mvsas: Fine-tuned tags array for alignment
Date: Fri, 8 May 2009 14:18:52 +0800
Message-ID: <20090508061852.GA1893@jason.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:53445 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754347AbZEHGTA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 May 2009 02:19:00 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jeff@garzik.org, james.bottomley@hansenpartnership.com

>From 2269b0ff3c2573f76cb0569eb5da99e9f12711d1 Mon Sep 17 00:00:00 2001
From: ayan <ayan@marvell.com>
Date: Fri, 8 May 2009 19:59:39 +0800
Subject: [PATCH 4/4] bug fix: alignment 

Fine-tuned tags array with u32 for alignment. 

Signed-off-by: Ying Chu <jasonchu@marvell.com>
Signed-off-by: Andy Yan <ayan@marvell.com>
Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas/mv_sas.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 75b9748..04f27bf 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -313,7 +313,7 @@ struct mvs_info {
 	const struct mvs_chip_info *chip;
 
 	int tags_num;
-	u8 tags[MVS_SLOTS >> 3];
+	u32 tags[MVS_SLOTS >> 5];
 
 	/* further per-slot information */
 	struct mvs_phy phy[MVS_MAX_PHYS];
-- 
1.6.0.3

-- 
Regards,
Ying Chu
