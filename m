From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix dpt_i2o compilation for alpha and sparc
Date: Sun, 30 May 2004 10:08:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040530080849.GA30611@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:31378 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261425AbUE3IIy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 May 2004 04:08:54 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

This patch has been floating around for ages, got reminded of it again
when looking at the debian kernel package.


diff -urN kernel-source-2.6.6/drivers/scsi/dpt_i2o.c kernel-source-2.6.6-1/drivers/scsi/dpt_i2o.c
--- kernel-source-2.6.6/drivers/scsi/dpt_i2o.c	2004-05-10 19:47:58.000000000 +1000
+++ kernel-source-2.6.6-1/drivers/scsi/dpt_i2o.c	2004-05-10 22:21:38.000000000 +1000
@@ -82,9 +82,9 @@
 #elif defined(__ia64__)
 	PROC_INTEL, PROC_IA64,
 #elif defined(__sparc__)
-	PROC_ULTRASPARC,
+	PROC_ULTRASPARC, PROC_ULTRASPARC,
 #elif defined(__alpha__)
-	PROC_ALPHA ,
+	PROC_ALPHA, PROC_ALPHA,
 #else
 	(-1),(-1)
 #endif
