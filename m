From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI mca_53c9x.c: make 2 functions static (fwd)
Date: Tue, 21 Dec 2004 01:41:48 +0100
Message-ID: <20041221004148.GG21288@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:4621 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261488AbULUAlx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Dec 2004 19:41:53 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The patch forwarded below still applies and compiles against 
2.6.10-rc3-mm1.

Please apply.



----- Forwarded message from Adrian Bunk <bunk@stusta.de> -----

Date:	Mon, 15 Nov 2004 03:13:34 +0100
From: Adrian Bunk <bunk@stusta.de>
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] SCSI mca_53c9x.c: make 2 functions static

The patch below makes two functions without external users static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/mca_53c9x.c.old	2004-11-13 22:42:09.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/mca_53c9x.c	2004-11-13 22:42:22.000000000 +0100
@@ -103,7 +103,7 @@
 static struct ESP_regs eregs;
 
 /***************************************************************** Detection */
-int mca_esp_detect(Scsi_Host_Template *tpnt)
+static int mca_esp_detect(Scsi_Host_Template *tpnt)
 {
 	struct NCR_ESP *esp;
 	static int io_port_by_pos[] = MCA_53C9X_IO_PORTS;
@@ -283,7 +283,7 @@
 
 /******************************************************************* Release */
 
-int mca_esp_release(struct Scsi_Host *host)
+static int mca_esp_release(struct Scsi_Host *host)
 {
 	struct NCR_ESP *esp = (struct NCR_ESP *)host->hostdata;
 	unsigned char tmp_byte;

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

----- End forwarded message -----

