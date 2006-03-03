From: Ralf Baechle <ralf@linux-mips.org>
Subject: [SCSI] Fix missing prototypes by including <linux/interrupt.h>.
Date: Fri, 3 Mar 2006 15:21:48 +0000
Message-ID: <20060303152148.GA10566@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mipsfw.mips-uk.com ([194.74.144.146]:11034 "EHLO
	bacchus.dhis.org") by vger.kernel.org with ESMTP id S932078AbWCCPVv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 10:21:51 -0500
Received: from denk.linux-mips.net (denk.linux-mips.net [127.0.0.1])
	by bacchus.dhis.org (8.13.4/8.13.4) with ESMTP id k23FLnlM010583
	for <linux-scsi@vger.kernel.org>; Fri, 3 Mar 2006 15:21:49 GMT
Received: (from ralf@localhost)
	by denk.linux-mips.net (8.13.4/8.13.4/Submit) id k23FLm6m010582
	for linux-scsi@vger.kernel.org; Fri, 3 Mar 2006 15:21:48 GMT
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index fb53eea..cd06e69 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -78,6 +78,7 @@
 #include <linux/string.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/blkdev.h>
 #include <asm/irq.h>
 
