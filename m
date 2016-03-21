From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 17/23] ncr5380: Remove remaining register storage qualifiers
Date: Mon, 21 Mar 2016 13:32:06 +1100
Message-ID: <20160321023154.083972284@telegraphics.com.au>
References: <20160321023149.604138431@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52838 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbcCUEFc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2016 00:05:32 -0400
Content-Disposition: inline; filename=ncr5380-remove-register-storage-qualifier
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-03-21 13:31:38.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-03-21 13:31:39.000000000 +1100
@@ -1555,9 +1555,9 @@ static int NCR5380_transfer_dma(struct S
 				unsigned char **data)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	register int c = *count;
-	register unsigned char p = *phase;
-	register unsigned char *d = *data;
+	int c = *count;
+	unsigned char p = *phase;
+	unsigned char *d = *data;
 	unsigned char tmp;
 	int result = 0;
 


