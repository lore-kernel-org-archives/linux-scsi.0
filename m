From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] update notcq blacklist
Date: Sun, 5 Sep 2004 19:13:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040905171334.GA6594@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:60641 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264980AbUIERNj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2004 13:13:39 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

This patch adds the two devices from the private blacklist in tmscsim to
the generic one.


--- 1.24/drivers/scsi/scsi_devinfo.c	2004-06-30 18:34:37 +02:00
+++ edited/drivers/scsi/scsi_devinfo.c	2004-09-05 19:13:10 +02:00
@@ -153,6 +153,7 @@
 	{"HP", "NetRAID-4M", NULL, BLIST_FORCELUN},
 	{"HP", "HSV100", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 	{"HP", "C1557A", NULL, BLIST_FORCELUN},
+	{"HP", "C3323-300", "4269", BLIST_NOTQ},
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN},
@@ -179,6 +180,7 @@
 	{"PIONEER", "CD-ROM DRM-604X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"REGAL", "CDC-4X", NULL, BLIST_MAX5LUN | BLIST_SINGLELUN},
 	{"SanDisk", "ImageMate CF-SD1", NULL, BLIST_FORCELUN},
+	{"SEAGATE", "ST3390N", "9546", BLIST_NOTQ},
 	{"SGI", "RAID3", "*", BLIST_SPARSELUN},
 	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
 	{"SGI", "TP9100", "*", BLIST_REPORTLUN2},
