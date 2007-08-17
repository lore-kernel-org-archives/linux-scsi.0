From: Joe Korty <joe.korty@ccur.com>
Subject: [PATCH] Fix section mismatch in the Adaptec DPT SCSI Raid driver
Date: Fri, 17 Aug 2007 16:51:15 -0400
Message-ID: <20070817205115.GA12416@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761793AbXHQUvo@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@osdl.org
Cc: aacraid@adaptec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fix section mismatch in the Adaptec DPT SCSI Raid driver.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.23-rc3-git1/drivers/scsi/dpt_i2o.c
===================================================================
--- 2.6.23-rc3-git1.orig/drivers/scsi/dpt_i2o.c	2007-08-17 16:36:05.000000000 -0400
+++ 2.6.23-rc3-git1/drivers/scsi/dpt_i2o.c	2007-08-17 16:50:13.000000000 -0400
@@ -3351,7 +3351,7 @@
 	return count > 0 ? 0 : -ENODEV;
 }
 
-static void __exit adpt_exit(void)
+static void adpt_exit(void)
 {
 	while (hba_chain)
 		adpt_release(hba_chain);
