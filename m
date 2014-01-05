From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 2/6] scsi_debug: make pseudo_primary static
Date: Mon,  6 Jan 2014 08:33:08 +0900
Message-ID: <1388964792-3546-3-git-send-email-akinobu.mita@gmail.com>
References: <1388964792-3546-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:52372 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaAEXd3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jan 2014 18:33:29 -0500
Received: by mail-pb0-f52.google.com with SMTP id uo5so17809706pbc.39
        for <linux-scsi@vger.kernel.org>; Sun, 05 Jan 2014 15:33:29 -0800 (PST)
In-Reply-To: <1388964792-3546-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

As pseudo_primary is only used in scsi_debug.c, it should be static.

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

