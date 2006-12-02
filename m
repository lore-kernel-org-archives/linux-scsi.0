From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/wd33c93.c: cleanups
Date: Sat, 2 Dec 2006 18:54:51 +0100
Message-ID: <20061202175451.GR11084@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:54021 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1163057AbWLBRyq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Dec 2006 12:54:46 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- #include <asm/irq.h> for getting the prototypes of
  {dis,en}able_irq()
- make the needlessly global wd33c93_setup() static

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was already sent on:
- 4 Sep 2006

--- linux-2.6.18-rc5-mm1/drivers/scsi/wd33c93.c.old	2006-09-04 01:45:57.000000000 +0200
+++ linux-2.6.18-rc5-mm1/drivers/scsi/wd33c93.c	2006-09-04 01:46:26.000000000 +0200
@@ -85,6 +85,8 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 
+#include <asm/irq.h>
+
 #include "wd33c93.h"
 
 
@@ -1710,7 +1712,7 @@
 static char setup_used[MAX_SETUP_ARGS];
 static int done_setup = 0;
 
-int
+static int
 wd33c93_setup(char *str)
 {
 	int i;


