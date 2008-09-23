From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] aic7xxx: user visible misuse wrong SI units (not disk
 size!)
Date: Tue, 23 Sep 2008 17:26:30 +0100
Message-ID: <20080923172630.1aaff0c5@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59847 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751716AbYIWQ0b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Sep 2008 12:26:31 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by lxorguk.ukuu.org.uk (8.14.2/8.14.2) with ESMTP id m8NGQVKP032030
	for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2008 17:26:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

aic7xxx: MHZ not Mhz for SI unit pedants

From: Alan Cox <alan@redhat.com>

Closes bug #6422

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/scsi/aic7xxx/aic79xx_core.c |    2 +-
 drivers/scsi/aic7xxx/aic79xx_pci.c  |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 55508b0..e241a93 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -4136,7 +4136,7 @@ ahd_update_neg_table(struct ahd_softc *ahd, struct ahd_devinfo *devinfo,
 
 			/*
 			 * Harpoon2A assumed that there would be a
-			 * fallback rate between 160MHz and 80Mhz,
+			 * fallback rate between 160MHz and 80MHz,
 			 * so 7 is used as the period factor rather
 			 * than 8 for 160MHz.
 			 */
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
index c25b6ad..2eb99c8 100644
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -223,10 +223,10 @@ static const char *pci_bus_modes[] =
 	"PCI bus mode unknown",
 	"PCI bus mode unknown",
 	"PCI bus mode unknown",
-	"PCI-X 101-133Mhz",
-	"PCI-X 67-100Mhz",
-	"PCI-X 50-66Mhz",
-	"PCI 33 or 66Mhz"
+	"PCI-X 101-133MHz",
+	"PCI-X 67-100MHz",
+	"PCI-X 50-66MHz",
+	"PCI 33 or 66MHz"
 };
 
 #define		TESTMODE	0x00000800ul
