From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] scsi/mac_scsi: Fix MAC_SCSI=m option when SCSI=m
Date: Thu, 23 Feb 2017 09:08:02 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1702230904540.8766@nippy.intranet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The mac_scsi driver still gets disabled when SCSI=m. This should have
been fixed back when I enabled the tristate but I didn't see the bug.

Fixes: 6e9ae6d560e1 ("[PATCH] mac_scsi: Add module option to Kconfig")
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index a4f6b0d..f8b0ba0 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1477,7 +1477,7 @@ config ATARI_SCSI
 
 config MAC_SCSI
 	tristate "Macintosh NCR5380 SCSI"
-	depends on MAC && SCSI=y
+	depends on MAC && SCSI
 	select SCSI_SPI_ATTRS
 	help
 	  This is the NCR 5380 SCSI controller included on most of the 68030
