From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] some more entries for the largelun list
Date: Thu, 27 Mar 2003 16:07:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030327160744.C10288@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.65/drivers/scsi/scsi_scan.c	Mon Mar 10 09:23:23 2003
+++ edited/drivers/scsi/scsi_scan.c	Fri Mar 21 21:14:13 2003
@@ -191,6 +191,13 @@
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"SUN", "T300", "*", BLIST_SPARSELUN},
 	{"SUN", "T4", "*", BLIST_SPARSELUN},
+	{"SGI", "RAID3", "*", BLIST_SPARSELUN},
+	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
+	{"SGI", "TP9100", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"SGI", "TP9300", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"SGI", "TP9400", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"SGI", "TP9500", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"MYLEX", "DACARMRB", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{ NULL, NULL, NULL, 0 },
 };
 
