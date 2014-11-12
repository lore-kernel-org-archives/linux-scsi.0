From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 37/37] atari_NCR5380: Fix "transfered" typo
Date: Wed, 12 Nov 2014 16:12:23 +1100
Message-ID: <20141112051155.215481480@telegraphics.com.au>
References: <20141112051146.525489687@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:41012 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbaKLFnh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 00:43:37 -0500
Content-Disposition: inline; filename=atari_NCR5380-fix-transfered-typo
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/atari_NCR5380.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2014-11-12 16:11:43.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2014-11-12 16:11:44.000000000 +1100
@@ -1105,7 +1105,7 @@ static void NCR5380_main(struct work_str
 static void NCR5380_dma_complete(struct Scsi_Host *instance)
 {
 	SETUP_HOSTDATA(instance);
-	int transfered;
+	int transferred;
 	unsigned char **data;
 	volatile int *count;
 	int saved_data = 0, overrun = 0;
@@ -1157,13 +1157,13 @@ static void NCR5380_dma_complete(struct
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 
-	transfered = hostdata->dma_len - NCR5380_dma_residual(instance);
+	transferred = hostdata->dma_len - NCR5380_dma_residual(instance);
 	hostdata->dma_len = 0;
 
 	data = (unsigned char **)&hostdata->connected->SCp.ptr;
 	count = &hostdata->connected->SCp.this_residual;
-	*data += transfered;
-	*count -= transfered;
+	*data += transferred;
+	*count -= transferred;
 
 	if (hostdata->read_overruns) {
 		int cnt, toPIO;


