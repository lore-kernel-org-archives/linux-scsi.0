From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/6] update changelog and version
Date: Sun, 6 Jun 2004 14:58:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040606125849.GG31063@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:31946 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263596AbUFFM6v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2004 08:58:51 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jes@trained-monkey.org
Cc: linux-scsi@vger.kernel.org


diff -Nru a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c	2004-06-06 14:47:45 +02:00
+++ b/drivers/scsi/qla1280.c	2004-06-06 14:47:45 +02:00
@@ -4,7 +4,7 @@
 * QLogic  QLA1280 (Ultra2)  and  QLA12160 (Ultra3) SCSI driver
 * Copyright (C) 2000 Qlogic Corporation (www.qlogic.com)
 * Copyright (C) 2001-2004 Jes Sorensen, Wild Open Source Inc.
-* Copyright (C) 2003 Christoph Hellwig
+* Copyright (C) 2003-2004 Christoph Hellwig
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
@@ -17,9 +17,12 @@
 * General Public License for more details.
 *
 ******************************************************************************/
-#define QLA1280_VERSION      "3.24.3"
+#define QLA1280_VERSION      "3.24.4"
 /*****************************************************************************
     Revision History:
+    Rev  3.24.4 June 7, 2004 Christoph Hellwig
+	- restructure firmware loading, cleanup initialization code
+	- prepare support for ISP1020/1040 chips
     Rev  3.24.3 January 19, 2004, Jes Sorensen
 	- Handle PCI DMA mask settings correctly
 	- Correct order of error handling in probe_one, free_irq should not
