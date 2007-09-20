From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] dtc: Fix typo
Date: Thu, 20 Sep 2007 15:12:11 +0100
Message-ID: <20070920151211.4aa040c6@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56178 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757157AbXITOE7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 10:04:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, akpm@osdl.org

Signed-off-by: Alan Cox <alan@redhat.com>

(and pointed out by several people)

diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.23rc6-mm1/drivers/scsi/dtc.c linux-2.6.23rc6-mm1/drivers/scsi/dtc.c
--- linux.vanilla-2.6.23rc6-mm1/drivers/scsi/dtc.c	2007-09-18 15:32:56.000000000 +0100
+++ linux-2.6.23rc6-mm1/drivers/scsi/dtc.c	2007-09-18 16:26:56.000000000 +0100
@@ -242,7 +242,7 @@
 					if (check_signature(base + signatures[sig].offset, signatures[sig].string, strlen(signatures[sig].string))) {
 						addr = bases[current_base].address;
 #if (DTCDEBUG & DTCDEBUG_INIT)
-						printk(KERB_DEBUG "scsi-dtc : detected board.\n");
+						printk(KERN_DEBUG "scsi-dtc : detected board.\n");
 #endif
 						goto found;
 					}
