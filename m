From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 3/4] sd: use <linux/uaccess.h> include instead of <asm/uaccess.h> one
Date: Wed, 29 Apr 2009 22:08:52 +0200
Message-ID: <200904292208.52749.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50903 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbZD2UHT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 16:07:19 -0400
Received: by fxm2 with SMTP id 2so1411638fxm.37
        for <linux-scsi@vger.kernel.org>; Wed, 29 Apr 2009 13:07:18 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

Fix

	WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
	#52: FILE: scsi/sd.c:52:
	+#include <asm/uaccess.h>

issue detected by checkpatch.pl.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/scsi/sd.c
===================================================================
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -49,7 +49,7 @@
 #include <linux/mutex.h>
 #include <linux/string_helpers.h>
 #include <linux/async.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
