From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Missing const in sr_vendor
Date: Fri, 16 Dec 2005 21:11:37 -0700
Message-ID: <20051217041137.GG2361@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56710 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751078AbVLQELi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2005 23:11:38 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix compile warnings with current scsi-misc git tree

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/scsi/sr_vendor.c b/drivers/scsi/sr_vendor.c
index 78274dc..9dde8df 100644
--- a/drivers/scsi/sr_vendor.c
+++ b/drivers/scsi/sr_vendor.c
@@ -68,8 +68,8 @@ void sr_vendor_init(Scsi_CD *cd)
 #ifndef CONFIG_BLK_DEV_SR_VENDOR
 	cd->vendor = VENDOR_SCSI3;
 #else
-	char *vendor = cd->device->vendor;
-	char *model = cd->device->model;
+	const char *vendor = cd->device->vendor;
+	const char *model = cd->device->model;
 	
 	/* default */
 	cd->vendor = VENDOR_SCSI3;
