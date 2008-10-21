From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/22] sata_inic162x: inic162x is not dependent on CONFIG_ATA_SFF
Date: Tue, 21 Oct 2008 18:17:40 +0900
Message-ID: <1224580680-13698-3-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:45958 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbYJUJUR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 05:20:17 -0400
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>

sata_inic162x no longer uses SFF interface.  Move it out of
CONFIG_ATA_SFF.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/Kconfig |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 78fbec8..7cf243e 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -63,6 +63,12 @@ config SATA_SIL24
 
 	  If unsure, say N.
 
+config SATA_INIC162X
+	tristate "Initio 162x SATA support"
+	depends on PCI
+	help
+	  This option enables support for Initio 162x Serial ATA.
+
 config SATA_FSL
 	tristate "Freescale 3.0Gbps SATA support"
 	depends on FSL_SOC
@@ -203,12 +209,6 @@ config SATA_VITESSE
 
 	  If unsure, say N.
 
-config SATA_INIC162X
-	tristate "Initio 162x SATA support"
-	depends on PCI
-	help
-	  This option enables support for Initio 162x Serial ATA.
-
 config PATA_ACPI
 	tristate "ACPI firmware driver for PATA"
 	depends on ATA_ACPI
-- 
1.5.4.5

