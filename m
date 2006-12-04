From: akpm@osdl.org
Subject: [patch 29/30] drivers/scsi/wd33c93.c: cleanups
Date: Mon, 04 Dec 2006 15:18:45 -0800
Message-ID: <200612042319.kB4NJsvc008819@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57545 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967803AbWLDXXN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Dec 2006 18:23:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de

From: Adrian Bunk <bunk@stusta.de>

- #include <asm/irq.h> for getting the prototypes of {dis,en}able_irq()

- make the needlessly global wd33c93_setup() static

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/wd33c93.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/wd33c93.c~drivers-scsi-wd33c93c-cleanups drivers/scsi/wd33c93.c
--- a/drivers/scsi/wd33c93.c~drivers-scsi-wd33c93c-cleanups
+++ a/drivers/scsi/wd33c93.c
@@ -85,6 +85,8 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 
+#include <asm/irq.h>
+
 #include "wd33c93.h"
 
 
@@ -1710,7 +1712,7 @@ static char setup_buffer[SETUP_BUFFER_SI
 static char setup_used[MAX_SETUP_ARGS];
 static int done_setup = 0;
 
-int
+static int
 wd33c93_setup(char *str)
 {
 	int i;
_
