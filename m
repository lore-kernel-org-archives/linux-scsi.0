From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] make seagate_st0x_detect() static
Date: Sat, 6 Jan 2007 02:06:33 +0100
Message-ID: <20070106010633.GE20714@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:2519 "HELO
	mailout.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751028AbXAFBGa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2007 20:06:30 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

seagate_st0x_detect() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.20-rc3-mm1/drivers/scsi/seagate.c.old	2007-01-05 22:53:13.000000000 +0100
+++ linux-2.6.20-rc3-mm1/drivers/scsi/seagate.c	2007-01-05 22:57:54.000000000 +0100
@@ -420,7 +420,7 @@
 #define ULOOP( i ) for (clock = i*8;;)
 #define TIMEOUT (!(clock--))
 
-int __init seagate_st0x_detect (struct scsi_host_template * tpnt)
+static int __init seagate_st0x_detect (struct scsi_host_template * tpnt)
 {
 	struct Scsi_Host *instance;
 	int i, j;

