From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] mvsas: fix a sparse annotation
Date: Wed, 17 Apr 2013 10:13:33 +0300
Message-ID: <20130417071332.GC7923@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26209 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965736Ab3DQHN5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 03:13:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

It doesn't make sense to label a 22 bit bitfield as __le32.  It just
causes a Sparse error.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/mvsas/mv_94xx.h b/drivers/scsi/mvsas/mv_94xx.h
index 487aa6f..b11f90d 100644
--- a/drivers/scsi/mvsas/mv_94xx.h
+++ b/drivers/scsi/mvsas/mv_94xx.h
@@ -220,7 +220,7 @@ union reg_phy_cfg {
 
 struct mvs_prd_imt {
 #ifndef __BIG_ENDIAN
-	__le32			len:22;
+	u32			len:22;
 	u8			_r_a:2;
 	u8			misc_ctl:4;
 	u8			inter_sel:4;
