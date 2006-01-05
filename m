From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] scsi_transport_spi.c: make print_nego() static
Date: Thu, 5 Jan 2006 23:39:18 +0100
Message-ID: <20060105223918.GM12313@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751411AbWAEWkB@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch makes a needlessly global function static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

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
