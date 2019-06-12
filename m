From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: [PATCH v1] scsi: Don't select SCSI_PROC_FS by default
Date: Wed, 12 Jun 2019 15:59:05 +0200
Message-ID: <2de15293-b9be-4d41-bc67-a69417f27f7a@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>
Cc: SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

According to the option's help message, SCSI_PROC_FS has been
superseded for ~15 years. Don't select it by default anymore.

Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
---
 drivers/scsi/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 73bce9b6d037..8c95e9ad6470 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -54,14 +54,11 @@ config SCSI_NETLINK
 config SCSI_PROC_FS
 	bool "legacy /proc/scsi/ support"
 	depends on SCSI && PROC_FS
-	default y
 	---help---
 	  This option enables support for the various files in
 	  /proc/scsi.  In Linux 2.6 this has been superseded by
 	  files in sysfs but many legacy applications rely on this.
 
-	  If unsure say Y.
-
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
-- 
2.17.1
