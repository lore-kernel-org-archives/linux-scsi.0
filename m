From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI megaraid_mm.c: make some code static
Date: Mon, 15 Nov 2004 03:14:57 +0100
Message-ID: <20041115021457.GQ2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261439AbUKODvH@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The patch below makes some needlessly global code static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/megaraid/megaraid_mm.c.old	2004-11-13 22:43:49.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/megaraid/megaraid_mm.c	2004-11-13 22:43:58.000000000 +0100
@@ -65,7 +65,7 @@
 static int adapters_count_g;
 static struct list_head adapters_list_g;
 
-wait_queue_head_t wait_q;
+static wait_queue_head_t wait_q;
 
 static struct file_operations lsi_fops = {
 	.open	= mraid_mm_open,
