From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI megaraid_mm.c: make some code static (fwd) (fwd)
Date: Sun, 16 Jan 2005 09:29:54 +0100
Message-ID: <20050116082954.GO4274@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46352 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S262462AbVAPI36 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Jan 2005 03:29:58 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The patch forwarded below still applies and compiles against
2.6.11-rc1-mm1.

Please apply.


----- Forwarded message from Adrian Bunk <bunk@stusta.de> -----

Date:	Tue, 21 Dec 2004 01:41:51 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@osdl.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [2.6 patch] SCSI megaraid_mm.c: make some code static (fwd)

The patch forwarded below still applies and compiles against 
2.6.10-rc3-mm1.

Please apply.



----- Forwarded message from Adrian Bunk <bunk@stusta.de> -----

Date:	Mon, 15 Nov 2004 03:14:57 +0100
From: Adrian Bunk <bunk@stusta.de>
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] SCSI megaraid_mm.c: make some code static

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

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

----- End forwarded message -----

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

----- End forwarded message -----

