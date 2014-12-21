From: Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 17/28] scsi: drop owner assignment from platform_drivers
Date: Sun, 21 Dec 2014 22:14:38 +0100
Message-ID: <1419196495-9626-18-git-send-email-wsa@the-dreams.de>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:52926 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbaLUVPm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Dec 2014 16:15:42 -0500
In-Reply-To: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

This platform_driver does not need to set an owner, it will be populated by the
driver core.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
Generated with coccinelle. SmPL file is in the introductory msg. The big
cleanup was pulled in this merge window. This series catches the bits fallen
through. The patches shall go in via the subsystem trees.

 drivers/scsi/atari_scsi.c | 1 -
 drivers/scsi/mac_scsi.c   | 1 -
 drivers/scsi/sun3_scsi.c  | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index d1c37a386947..5ede3daa93dc 100644
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
index 1e85c07e3b62..d64a769b8155 100644
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
index 2a906d1d34ba..22a42836d193 100644
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
2.1.3

