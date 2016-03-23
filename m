From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 17/23] ncr5380: Remove remaining register storage qualifiers
Date: Wed, 23 Mar 2016 21:10:26 +1100
Message-ID: <20160323101013.671799865@telegraphics.com.au>
References: <20160323101009.341929635@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-register-storage-qualifier
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>

---
 drivers/scsi/NCR5380.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-03-23 21:09:57.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-03-23 21:09:59.000000000 +1100
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
 
