From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI mca_53c9x.c: make 2 functions static
Date: Mon, 15 Nov 2004 03:13:34 +0100
Message-ID: <20041115021334.GP2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261435AbUKOC3c@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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
