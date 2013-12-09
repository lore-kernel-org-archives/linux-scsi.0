From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] scsi_debug: make pseudo_primary static
Date: Mon,  9 Dec 2013 22:54:47 +0900
Message-ID: <1386597287-3154-2-git-send-email-akinobu.mita@gmail.com>
References: <1386597287-3154-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:43340 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651Ab3LINzC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2013 08:55:02 -0500
Received: by mail-pb0-f47.google.com with SMTP id um1so5495231pbc.34
        for <linux-scsi@vger.kernel.org>; Mon, 09 Dec 2013 05:55:02 -0800 (PST)
In-Reply-To: <1386597287-3154-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

It is not necessary to declare pseudo_primary as global, becuase it
is only used in scsi_debug.c.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
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

