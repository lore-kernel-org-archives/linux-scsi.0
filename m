From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI ultrastor.c: make a variable static
Date: Mon, 7 Feb 2005 00:33:04 +0100
Message-ID: <20050206233304.GG3129@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mailout.stusta.mhn.de ([141.84.69.5]:28178 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261328AbVBFXdH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Feb 2005 18:33:07 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch makes a needlessly global variable static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was already sent on:
- 15 Nov 2004

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/ultrastor.c.old	2004-11-14 01:31:07.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/ultrastor.c	2004-11-14 01:31:20.000000000 +0100
@@ -259,7 +259,7 @@
 } config = {0};
 
 /* Set this to 1 to reset the SCSI bus on error.  */
-int ultrastor_bus_reset;
+static int ultrastor_bus_reset;
 
 
 /* Allowed BIOS base addresses (NULL indicates reserved) */

