From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI: dpt_i2o.c: make some code static
Date: Fri, 11 Feb 2005 19:54:22 +0100
Message-ID: <20050211185422.GD3736@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mailout.stusta.mhn.de ([141.84.69.5]:31250 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S262306AbVBKSy2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2005 13:54:28 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch makes some needlessly global code static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was already sent on:
- 15 Nov 2004
- 24 Nov 2004

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/dpt_i2o.c.old	2004-11-13 21:01:47.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/dpt_i2o.c	2004-11-13 21:01:57.000000000 +0100
@@ -108,7 +108,7 @@
  *============================================================================
  */
 
-DECLARE_MUTEX(adpt_configuration_lock);
+static DECLARE_MUTEX(adpt_configuration_lock);
 
 static struct i2o_sys_tbl *sys_tbl = NULL;
 static int sys_tbl_ind = 0;

