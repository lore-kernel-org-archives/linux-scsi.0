From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] don't include "scsi.h" in scsi_module.c
Date: Sun, 5 Sep 2004 19:21:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040905172104.GA6685@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:482 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266877AbUIERVG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2004 13:21:06 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

we onlyu need <scsi/scsi_host.h> here


--- 1.7/drivers/scsi/scsi_module.c	2004-05-12 17:46:23 +02:00
+++ edited/drivers/scsi/scsi_module.c	2004-09-04 15:41:03 +02:00
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-#include "scsi.h"
 #include <scsi/scsi_host.h>
 
 
