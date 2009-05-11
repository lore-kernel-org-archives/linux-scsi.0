From: Andy Yan <ayan@marvell.com>
Subject: [PATCH 4/5] bit map usage
Date: Tue, 12 May 2009 01:00:59 +0800
Message-ID: <20090511170059.GB9638@Andy.marvell.com>
Reply-To: ayan@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:60504 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752530AbZEKIKN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2009 04:10:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, jeff@garzik.org

>From dc94fa636af60eaebc9aaeb80c1b78b52edeea57 Mon Sep 17 00:00:00 2001
From: Andy Yan <ayan@marvell.com>
Date: Mon, 11 May 2009 21:56:31 +0800
Subject: [PATCH 4/5] bit map usage

Utilize DECLARE_BITMAP to define the tags array.

Signed-off-by: Ying Chu <jasonchu@marvell.com>
Signed-off-by: Andy Yan <ayan@marvell.com>
Signed-off-by: Ke Wei <kewei@marvell.com>

---
 drivers/scsi/mvsas/mv_sas.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 75b9748..93735ed 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -313,8 +313,7 @@ struct mvs_info {
 	const struct mvs_chip_info *chip;
 
 	int tags_num;
-	u8 tags[MVS_SLOTS >> 3];
-
+	DECLARE_BITMAP(tags, MVS_SLOTS);
 	/* further per-slot information */
 	struct mvs_phy phy[MVS_MAX_PHYS];
 	struct mvs_port port[MVS_MAX_PHYS];
-- 
1.6.2.1

