From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 02/12] scsi/cumana_1: Remove unused cumanascsi_setup()
 function
Date: Thu,  6 Oct 2016 19:41:07 -0400 (EDT)
Message-ID: <6a68e0ede228200d2a59ed6f90f31e51dc13a35a.1475791899.git.fthain@telegraphics.com.au>
References: <cover.1475791899.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1475791899.git.fthain@telegraphics.com.au>
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
