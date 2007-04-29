From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] deprecate the old NCR53C9x driver
Date: Mon, 30 Apr 2007 00:05:48 +0200
Message-ID: <20070429220548.GA22666@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:41060 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161486AbXD2WGS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Apr 2007 18:06:18 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, davem@davemloft.net
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-mips@linux-mips.org

Now that we have the much better esp_scsi driver and low level drivers
are easy to port over deprecate the old NCR53C9x driver.

I've Cc'ed the m68k and mips lists because all but one bus glues are
for these platforms.  Chances stand bad for the remaining driver,
mca_53c9x which hasn't gotten any non-trivial update since it was
merge in late 2.1.x and whos maintainers mail address bounces.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/Documentation/feature-removal-schedule.txt
===================================================================
--- linux-2.6.orig/Documentation/feature-removal-schedule.txt	2007-04-29 23:44:46.000000000 +0200
+++ linux-2.6/Documentation/feature-removal-schedule.txt	2007-04-29 23:45:55.000000000 +0200
@@ -6,6 +6,13 @@ be removed from this file.
 
 ---------------------------
 
+What:	old NCR53C9x driver
+When:	October 2007
+Why:	Replaced by the much better esp_scsi driver.  Actual low-level
+	driver can ported over almost trivially.
+Who:	David Miller <davem@davemloft.net>
+	Christoph Hellwig <hch@lst.de>
+
 What:	V4L2 VIDIOC_G_MPEGCOMP and VIDIOC_S_MPEGCOMP
 When:	October 2007
 Why:	Broken attempt to set MPEG compression parameters. These ioctls are
