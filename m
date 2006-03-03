From: Ralf Baechle <ralf@linux-mips.org>
Subject: [SCSI] Fix missing prototypes by including <linux/interrupt.h>.
Date: Fri, 3 Mar 2006 16:34:08 +0000
Message-ID: <20060303163408.GA27482@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mipsfw.mips-uk.com ([194.74.144.146]:33049 "EHLO
	bacchus.dhis.org") by vger.kernel.org with ESMTP id S932265AbWCCQeJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 11:34:09 -0500
Received: from denk.linux-mips.net (denk.linux-mips.net [127.0.0.1])
	by bacchus.dhis.org (8.13.4/8.13.4) with ESMTP id k23GY8B2027510
	for <linux-scsi@vger.kernel.org>; Fri, 3 Mar 2006 16:34:08 GMT
Received: (from ralf@localhost)
	by denk.linux-mips.net (8.13.4/8.13.4/Submit) id k23GY8Y7027509
	for linux-scsi@vger.kernel.org; Fri, 3 Mar 2006 16:34:08 GMT
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index fb53eea..d8a7260 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -78,8 +78,8 @@
 #include <linux/string.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/blkdev.h>
-#include <asm/irq.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
