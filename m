From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI NCR_Q720.c: make some code static
Date: Mon, 15 Nov 2004 03:21:05 +0100
Message-ID: <20041115022105.GU2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:41734 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261468AbUKOCfF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Nov 2004 21:35:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The patch below makes two needlessly global structs static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/NCR_Q720.c.old	2004-11-13 16:34:15.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/NCR_Q720.c	2004-11-13 16:34:32.000000000 +0100
@@ -48,7 +48,7 @@
 	struct Scsi_Host	*hosts[4];
 };
 
-struct scsi_host_template NCR_Q720_tpnt = {
+static struct scsi_host_template NCR_Q720_tpnt = {
 	.module			= THIS_MODULE,
 	.proc_name		= "NCR_Q720",
 };
@@ -345,7 +345,7 @@
 
 static short NCR_Q720_id_table[] = { NCR_Q720_MCA_ID, 0 };
 
-struct mca_driver NCR_Q720_driver = {
+static struct mca_driver NCR_Q720_driver = {
 	.id_table = NCR_Q720_id_table,
 	.driver = {
 		.name		= "NCR_Q720",

