From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [22/22] Remove GFP_DMA in sr_vendor.c
Date: Mon, 25 Feb 2008 00:35:35 +0100 (CET)
Message-ID: <20080224233535.60C5A1B4183@basil.firstfloor.org>
References: <200802251235.889863872@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:15963 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbYBXXvh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 18:51:37 -0500
In-Reply-To: <200802251235.889863872@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com


Bounced by the block layer anyways

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/drivers/scsi/sr_vendor.c
===================================================================
--- linux.orig/drivers/scsi/sr_vendor.c
+++ linux/drivers/scsi/sr_vendor.c
@@ -117,7 +117,7 @@ int sr_set_blocklength(Scsi_CD *cd, int 
 		density = (blocklength > 2048) ? 0x81 : 0x83;
 #endif
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -164,7 +164,7 @@ int sr_cd_check(struct cdrom_device_info
 	if (cd->cdi.mask & CDC_MULTI_SESSION)
 		return 0;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
