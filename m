From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] allow non-modular mptctl
Date: Mon, 6 Sep 2004 12:53:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040906105305.GA18092@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:19840 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267536AbUIFKxM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2004 06:53:12 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Emoore@lsil.com
Cc: linux-scsi@vger.kernel.org

There's no reason to keep people from building it into their
kernels statically.


--- 1.7/drivers/message/fusion/Kconfig	2004-07-13 23:55:06 +02:00
+++ edited/drivers/message/fusion/Kconfig	2004-09-06 12:27:28 +02:00
@@ -29,7 +29,7 @@
 
 config FUSION_CTL
 	tristate "Fusion MPT misc device (ioctl) driver"
-	depends on MODULES && FUSION && m
+	depends on FUSION
 	---help---
 	  The Fusion MPT misc device driver provides specialized control
 	  of MPT adapters via system ioctl calls.  Use of ioctl calls to
