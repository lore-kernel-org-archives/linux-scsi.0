From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI ultrastor.c: make a varialbe static
Date: Mon, 15 Nov 2004 03:40:03 +0100
Message-ID: <20041115024003.GF2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34060 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261507AbUKOCwj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Nov 2004 21:52:39 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The patch below makes aneedlessly global variable static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/ultrastor.c.old	2004-11-14 01:31:07.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/ultrastor.c	2004-11-14 01:31:20.000000000 +0100
@@ -259,7 +259,7 @@
 } config = {0};
 
 /* Set this to 1 to reset the SCSI bus on error.  */
-int ultrastor_bus_reset;
+static int ultrastor_bus_reset;
 
 
 /* Allowed BIOS base addresses (NULL indicates reserved) */

