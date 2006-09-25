From: akpm@osdl.org
Subject: [patch 20/28] drivers/message/fusion/linux_compat.h Removal of old code
Date: Mon, 25 Sep 2006 16:59:06 -0700
Message-ID: <200609252359.k8PNx6lx003515@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:36283 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751768AbWIYX7O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 19:59:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, michal.k.k.piotrowski@gmail.com, Eric.Moore@lsil.com

From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Acked-by: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/message/fusion/linux_compat.h |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN drivers/message/fusion/linux_compat.h~drivers-message-fusion-linux_compath-removal-of-old-code drivers/message/fusion/linux_compat.h
--- a/drivers/message/fusion/linux_compat.h~drivers-message-fusion-linux_compath-removal-of-old-code
+++ a/drivers/message/fusion/linux_compat.h
@@ -6,13 +6,4 @@
 #include <linux/version.h>
 #include <scsi/scsi_device.h>
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,6))
-static int inline scsi_device_online(struct scsi_device *sdev)
-{
-	return sdev->online;
-}
-#endif
-
-
-/*}-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 #endif /* _LINUX_COMPAT_H */
_
