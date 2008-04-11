From: "Jason Chu" <jasonchu@marvell.com>
Subject: [PATCH 1/1] AIC94XX: Ports and Phys memory space fixed.
Date: Thu, 10 Apr 2008 20:44:26 -0700
Message-ID: <FE3F06125A99254E8D92161AA4569C6F02BE7E62@sc-exch02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:22449 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757077AbYDKDo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Apr 2008 23:44:28 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Michael Wang <qswang@marvell.com>

No need more spaces for sas_phys and sas_port.

Signed-off-by:: Ying Chu <jasonchu@marvell.com>
---
driver/scsi/aic94xx/aic94xx_init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c
b/drivers/scsi/aic94xx/aic94xx_init.c
index 88d1e73..0400bd2 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -689,9 +689,9 @@ static int asd_register_sas_ha(struct as
 {
 	int i;
 	struct asd_sas_phy   **sas_phys =
-		kmalloc(ASD_MAX_PHYS * sizeof(struct asd_sas_phy),
GFP_KERNEL);
+		kmalloc(ASD_MAX_PHYS * sizeof(struct asd_sas_phy *),
GFP_KERNEL);
 	struct asd_sas_port  **sas_ports =
-		kmalloc(ASD_MAX_PHYS * sizeof(struct asd_sas_port),
GFP_KERNEL);
+		kmalloc(ASD_MAX_PHYS * sizeof(struct asd_sas_port *),
GFP_KERNEL);
 
 	if (!sas_phys || !sas_ports) {
 		kfree(sas_phys);
