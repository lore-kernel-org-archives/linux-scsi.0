From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] scsi_transport_spi.c: make print_nego() static
Date: Sat, 14 Jan 2006 03:09:45 +0100
Message-ID: <20060114020945.GB29663@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:20242 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1423269AbWANCJp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 21:09:45 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch makes a needlessly global function static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Matthew Wilcox <matthew@wil.cx>

---

This patch was already sent on:
- 5 Jan 2006

--- linux-2.6.15-mm1-full/drivers/scsi/scsi_transport_spi.c.old	2006-01-05 22:52:19.000000000 +0100
+++ linux-2.6.15-mm1-full/drivers/scsi/scsi_transport_spi.c	2006-01-05 22:52:28.000000000 +0100
@@ -1075,7 +1075,7 @@
 /* 0x04 */ "Parallel Protocol Request"
 };
 
-void print_nego(const unsigned char *msg, int per, int off, int width)
+static void print_nego(const unsigned char *msg, int per, int off, int width)
 {
 	if (per) {
 		char buf[20];

