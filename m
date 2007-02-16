From: akpm@linux-foundation.org
Subject: [patch 17/30] drivers/scsi/wd33c93.c: cleanups
Date: Fri, 16 Feb 2007 01:46:34 -0800
Message-ID: <200702160946.l1G9kZJF026666@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37219 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423533AbXBPJtt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Feb 2007 04:49:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@stusta.de

From: Adrian Bunk <bunk@stusta.de>

- #include <asm/irq.h> for getting the prototypes of {dis,en}able_irq()

- make the needlessly global wd33c93_setup() static

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/wd33c93.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/wd33c93.c~drivers-scsi-wd33c93c-cleanups drivers/scsi/wd33c93.c
--- a/drivers/scsi/wd33c93.c~drivers-scsi-wd33c93c-cleanups
+++ a/drivers/scsi/wd33c93.c
@@ -84,6 +84,8 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 
+#include <asm/irq.h>
+
 #include "wd33c93.h"
 
 
@@ -1709,7 +1711,7 @@ static char setup_buffer[SETUP_BUFFER_SI
 static char setup_used[MAX_SETUP_ARGS];
 static int done_setup = 0;
 
-int
+static int
 wd33c93_setup(char *str)
 {
 	int i;
_
