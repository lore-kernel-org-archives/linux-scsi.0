From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI ibmmca.c: make a struct static
Date: Mon, 15 Nov 2004 03:06:58 +0100
Message-ID: <20041115020658.GL2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34320 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261442AbUKOCTD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Nov 2004 21:19:03 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: langa2@kph.uni-mainz.de
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The patch below makes a needlessly global struct static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/ibmmca.c.old	2004-11-13 21:50:36.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/ibmmca.c	2004-11-13 21:50:49.000000000 +0100
@@ -292,7 +292,7 @@
 #define INTEGRATED_SCSI          101
 
 /* List of possible IBM-SCSI-adapters */
-struct subsys_list_struct subsys_list[] = {
+static struct subsys_list_struct subsys_list[] = {
 	{0x8efc, "IBM SCSI-2 F/W Adapter"},	/* special = 0 */
 	{0x8efd, "IBM 7568 Industrial Computer SCSI Adapter w/Cache"},	/* special = 1 */
 	{0x8ef8, "IBM Expansion Unit SCSI Controller"},	/* special = 2 */

