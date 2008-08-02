From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] SCSI: select CRC_T10DIF only when necessary
Date: Sat, 2 Aug 2008 19:49:40 +0200 (CEST)
Message-ID: <tkrat.f48aff12c83f913b@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:49750 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935AbYHBRun (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Aug 2008 13:50:43 -0400
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

--- linux-2.6.27-rc1.orig/drivers/scsi/Kconfig
+++ linux-2.6.27-rc1/drivers/scsi/Kconfig
@@ -63,7 +63,7 @@ comment "SCSI support type (disk, tape, 
 config BLK_DEV_SD
 	tristate "SCSI disk support"
 	depends on SCSI
-	select CRC_T10DIF
+	select CRC_T10DIF if BLK_DEV_INTEGRITY
 	---help---
 	  If you want to use SCSI hard disks, Fibre Channel disks,
 	  Serial ATA (SATA) or Parallel ATA (PATA) hard disks,

-- 
Stefan Richter
-=====-==--- =--- ---=-
http://arcgraph.de/sr/

