From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI osst.c: make some code static
Date: Mon, 15 Nov 2004 03:22:31 +0100
Message-ID: <20041115022231.GV2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:18951 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261480AbUKOChE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Nov 2004 21:37:04 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: osst@riede.org
Cc: osst-users@lists.sourceforge.net, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The patch below makes some needlessly global code static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/osst.c.old	2004-11-13 22:44:39.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/osst.c	2004-11-13 22:44:59.000000000 +0100
@@ -24,7 +24,7 @@
 */
 
 static const char * cvsid = "$Id: osst.c,v 1.70 2003/12/23 14:22:12 wriede Exp $";
-const char * osst_version = "0.99.1";
+static const char * osst_version = "0.99.1";
 
 /* The "failure to reconnect" firmware bug */
 #define OSST_FW_NEED_POLL_MIN 10601 /*(107A)*/
@@ -164,7 +164,7 @@
 static int osst_probe(struct device *);
 static int osst_remove(struct device *);
 
-struct scsi_driver osst_template = {
+static struct scsi_driver osst_template = {
 	.owner			= THIS_MODULE,
 	.gendrv = {
 		.name		=  "osst",

