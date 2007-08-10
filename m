From: akpm@linux-foundation.org
Subject: [patch 20/30] drivers/scsi/gdth.c: kmalloc + memset conversion to kzalloc
Date: Fri, 10 Aug 2007 14:50:46 -0700
Message-ID: <200708102150.l7ALokrZ011378@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54337 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326AbXHJV6i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 17:58:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, m.kozlowski@tuxland.pl

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/gdth.c | 189401 -> 189342 (-59 bytes)
 drivers/scsi/gdth.o | 331028 -> 330324 (-704 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/gdth.c~drivers-scsi-gdthc-kmalloc-memset-conversion-to-kzalloc drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~drivers-scsi-gdthc-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/scsi/gdth.c
@@ -726,10 +726,10 @@ int __gdth_execute(struct scsi_device *s
     DECLARE_COMPLETION_ONSTACK(wait);
     int rval;
 
-    scp = kmalloc(sizeof(*scp), GFP_KERNEL);
+    scp = kzalloc(sizeof(*scp), GFP_KERNEL);
     if (!scp)
         return -ENOMEM;
-    memset(scp, 0, sizeof(*scp));
+
     scp->device = sdev;
     /* use request field to save the ptr. to completion struct. */
     scp->request = (struct request *)&wait;
_
