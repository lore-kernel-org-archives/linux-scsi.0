From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [15/21] SCSI-ISA-DMA: Don't disable direct_io for unchecked_isa_dma in st.c
Date: Thu,  2 Oct 2008 09:58:53 +0200 (CEST)
Message-ID: <20081002075853.64B703E6A09@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57081 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbYJBH6y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:54 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


Block layer bounces anyways.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/st.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/scsi/st.c
===================================================================
--- linux.orig/drivers/scsi/st.c
+++ linux/drivers/scsi/st.c
@@ -4027,7 +4027,7 @@ static int st_probe(struct device *dev)
 	tpnt->nbr_partitions = 0;
 	tpnt->device->timeout = ST_TIMEOUT;
 	tpnt->long_timeout = ST_LONG_TIMEOUT;
-	tpnt->try_dio = try_direct_io && !SDp->host->unchecked_isa_dma;
+	tpnt->try_dio = try_direct_io;
 
 	for (i = 0; i < ST_NBR_MODES; i++) {
 		STm = &(tpnt->modes[i]);
