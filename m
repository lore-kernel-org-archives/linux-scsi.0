From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/2] megaraid: drop the 'new driver' statements
Date: Fri, 30 Jun 2017 13:05:54 +0200
Message-ID: <1498820754-51032-3-git-send-email-hare@suse.de>
References: <1498820754-51032-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48337 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751690AbdF3LGC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 07:06:02 -0400
In-Reply-To: <1498820754-51032-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

This driver is hardly new; it has been supersede by at least four
other generations of megaraid RAID HBAs.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/megaraid/Kconfig.megaraid | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/Kconfig.megaraid b/drivers/scsi/megaraid/Kconfig.megaraid
index ad1dc16..cb4952c 100644
--- a/drivers/scsi/megaraid/Kconfig.megaraid
+++ b/drivers/scsi/megaraid/Kconfig.megaraid
@@ -1,11 +1,11 @@
 config MEGARAID_NEWGEN
-	bool "LSI Logic New Generation RAID Device Drivers"
+	bool "LSI Logic RAID Device Drivers"
 	depends on PCI && SCSI
 	help
 	LSI Logic RAID Device Drivers
 
 config MEGARAID_MM
-	tristate "LSI Logic Management Module (New Driver)"
+	tristate "LSI Logic Management Module"
 	depends on PCI && SCSI && MEGARAID_NEWGEN
 	help
 	Management Module provides ioctl, sysfs support for LSI Logic
@@ -15,7 +15,7 @@ config MEGARAID_MM
 
 
 config MEGARAID_MAILBOX
-	tristate "LSI Logic MegaRAID Driver (New Driver)"
+	tristate "LSI Logic MegaRAID Driver"
 	depends on PCI && SCSI && MEGARAID_MM
 	help
 	List of supported controllers
-- 
1.8.5.6
