From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [15/21] Don't disable direct_io for unchecked_isa_dma in st.c
Date: Sun, 16 Nov 2008 00:11:15 +0100 (CET)
Message-ID: <20081115231115.967523E661A@basil.firstfloor.org>
References: <200811161211.212948789@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:44209 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbYKOXLN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Nov 2008 18:11:13 -0500
In-Reply-To: <200811161211.212948789@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org


Block layer bounces anyways.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/st.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/scsi/st.c
===================================================================
--- linux.orig/drivers/scsi/st.c	2008-11-15 22:37:12.000000000 +0100
+++ linux/drivers/scsi/st.c	2008-11-15 22:37:12.000000000 +0100
@@ -4028,7 +4028,7 @@
 	tpnt->nbr_partitions = 0;
 	tpnt->device->timeout = ST_TIMEOUT;
 	tpnt->long_timeout = ST_LONG_TIMEOUT;
-	tpnt->try_dio = try_direct_io && !SDp->host->unchecked_isa_dma;
+	tpnt->try_dio = try_direct_io;
 
 	for (i = 0; i < ST_NBR_MODES; i++) {
 		STm = &(tpnt->modes[i]);
