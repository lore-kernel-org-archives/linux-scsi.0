From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 1/3] ncr5380: Drop owner assignment from platform_drivers
Date: Thu, 29 Jan 2015 17:54:46 +1100
Message-ID: <3ab42e92abc10ea42a358bce58300524f9594e0b.1425880089.git.fthain@telegraphics.com.au>
References: <cover.1425880089.git.fthain@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:44148 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbbCIICD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2015 04:02:03 -0400
In-Reply-To: <cover.1425880089.git.fthain@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

From: Wolfram Sang <wsa@the-dreams.de>

This platform_driver does not need to set an owner, it will be populated by
the driver core.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/atari_scsi.c | 1 -
 drivers/scsi/mac_scsi.c   | 1 -
 drivers/scsi/sun3_scsi.c  | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index d1c37a3..5ede3da 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -1014,7 +1014,6 @@ static struct platform_driver atari_scsi_driver = {
 	.remove = __exit_p(atari_scsi_remove),
 	.driver = {
 		.name	= DRV_MODULE_NAME,
-		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 1e85c07..d64a769 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -483,7 +483,6 @@ static struct platform_driver mac_scsi_driver = {
 	.remove = __exit_p(mac_scsi_remove),
 	.driver = {
 		.name	= DRV_MODULE_NAME,
-		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 2a906d1..22a4283 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -676,7 +676,6 @@ static struct platform_driver sun3_scsi_driver = {
 	.remove = __exit_p(sun3_scsi_remove),
 	.driver = {
 		.name	= DRV_MODULE_NAME,
-		.owner	= THIS_MODULE,
 	},
 };
 
-- 
2.0.5

