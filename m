From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI dc395x.c: make a function static
Date: Mon, 15 Nov 2004 02:56:09 +0100
Message-ID: <20041115015609.GG2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58892 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261417AbUKOCJd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Nov 2004 21:09:33 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: oliver@neukum.name, aliakc@web.de, lenehan@twibble.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The patch below makes the needlessly global function adapter_init_chip 
static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/dc395x.c.old	2004-11-13 20:58:56.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/dc395x.c	2004-11-13 20:59:09.000000000 +0100
@@ -4447,7 +4447,7 @@
  *
  * @acb: The adapter which we are to init.
  **/
-void __init adapter_init_chip(struct AdapterCtlBlk *acb)
+static void __init adapter_init_chip(struct AdapterCtlBlk *acb)
 {
         struct NvRamType *eeprom = &acb->eeprom;
         

