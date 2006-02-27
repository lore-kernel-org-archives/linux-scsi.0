From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Export spi_populate_* functions
Date: Mon, 27 Feb 2006 07:18:26 -0700
Message-ID: <20060227141826.GB27759@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:14045 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751244AbWB0OS1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2006 09:18:27 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


These functions should be usable by modules.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff -u ./drivers/scsi/scsi_transport_spi.c ./drivers/scsi/scsi_transport_spi.c
--- ./drivers/scsi/scsi_transport_spi.c	7 Feb 2006 13:11:26 -0000
+++ ./drivers/scsi/scsi_transport_spi.c	27 Feb 2006 14:13:18 -0000
@@ -1062,6 +1061,7 @@
 	msg[3] = width;
 	return 4;
 }
+EXPORT_SYMBOL(spi_populate_width_msg);
 
 int spi_populate_sync_msg(unsigned char *msg, int period, int offset)
 {
@@ -1072,6 +1072,7 @@
 	msg[4] = offset;
 	return 5;
 }
+EXPORT_SYMBOL(spi_populate_sync_msg);
 
 int spi_populate_ppr_msg(unsigned char *msg, int period, int offset,
 		int width, int options)
@@ -1086,6 +1087,7 @@
 	msg[7] = options;
 	return 8;
 }
+EXPORT_SYMBOL(spi_populate_ppr_msg);
 
 #ifdef CONFIG_SCSI_CONSTANTS
 static const char * const one_byte_msgs[] = {
