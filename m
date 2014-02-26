From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 2/7] scsi_debug: make pseudo_primary static
Date: Wed, 26 Feb 2014 22:56:59 +0900
Message-ID: <1393423024-8063-3-git-send-email-akinobu.mita@gmail.com>
References: <1393423024-8063-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51854 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaBZN5Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Feb 2014 08:57:24 -0500
Received: by mail-pa0-f45.google.com with SMTP id lf10so998664pab.32
        for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2014 05:57:24 -0800 (PST)
In-Reply-To: <1393423024-8063-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

As pseudo_primary is only used in scsi_debug.c, it should be static.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Reviewed-by: Douglas Gilbert <dgilbert@interlog.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index bdfb9be..9cd211e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3246,7 +3246,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 };
 ATTRIBUTE_GROUPS(sdebug_drv);
 
-struct device *pseudo_primary;
+static struct device *pseudo_primary;
 
 static int __init scsi_debug_init(void)
 {
-- 
1.8.3.2

