From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 02/12] scsi/cumana_1: Remove unused cumanascsi_setup()
 function
Date: Mon, 10 Oct 2016 00:46:52 -0400 (EDT)
Message-ID: <0e4fe7993945cd855f230f95bc0d7410dd5a9baa.1476051962.git.fthain@telegraphics.com.au>
References: <cover.1476051961.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1476051961.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/arm/cumana_1.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index 8e9cfe8..f616756 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -33,10 +33,6 @@
 
 #include "../NCR5380.h"
 
-void cumanascsi_setup(char *str, int *ints)
-{
-}
-
 #define CTRL	0x16fc
 #define STAT	0x2004
 #define L(v)	(((v)<<16)|((v) & 0x0000ffff))
-- 
2.7.3
