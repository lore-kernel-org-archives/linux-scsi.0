Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F385CC47082
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABB06613E6
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhEVImI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 04:42:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3626 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhEVImF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 04:42:05 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FnH011pVyzQntw;
        Sat, 22 May 2021 16:37:05 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 16:40:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 22 May 2021 16:40:37 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tanghui20@huawei.com>, Hannes Reinecke <hare@suse.com>
Subject: [PATCH 02/24] scsi: aic7xxx: remove leading spaces before tabs
Date:   Sat, 22 May 2021 16:37:06 +0800
Message-ID: <1621672648-39955-3-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621672648-39955-1-git-send-email-tanghui20@huawei.com>
References: <1621672648-39955-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are a few leading spaces before tabs and remove it by running
the following commard:

    $ find . -name '*.[ch]' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/scsi/aic7xxx/aic7770_osm.c     |  2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c | 14 +++++++-------
 drivers/scsi/aic7xxx/aic7xxx_pci.c     |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7770_osm.c b/drivers/scsi/aic7xxx/aic7770_osm.c
index bdd177e..ac04d5b 100644
--- a/drivers/scsi/aic7xxx/aic7770_osm.c
+++ b/drivers/scsi/aic7xxx/aic7770_osm.c
@@ -100,7 +100,7 @@ aic7770_probe(struct device *dev)
 		return (error);
 	}
 
- 	dev_set_drvdata(dev, ahc);
+	dev_set_drvdata(dev, ahc);
 
 	error = ahc_linux_register_host(ahc, &aic7xxx_driver_template);
 	return (error);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
index a07e94f..5e5d456 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -109,8 +109,8 @@ static const struct pci_device_id ahc_linux_pci_id_table[] = {
 	ID(ID_AIC7860 & ID_DEV_VENDOR_MASK),
 	ID(ID_AIC7870 & ID_DEV_VENDOR_MASK),
 	ID(ID_AIC7880 & ID_DEV_VENDOR_MASK),
- 	ID16(ID_AIC7890 & ID_9005_GENERIC_MASK),
- 	ID16(ID_AIC7892 & ID_9005_GENERIC_MASK),
+	ID16(ID_AIC7890 & ID_9005_GENERIC_MASK),
+	ID16(ID_AIC7892 & ID_9005_GENERIC_MASK),
 	ID(ID_AIC7895 & ID_DEV_VENDOR_MASK),
 	ID16(ID_AIC7896 & ID_9005_GENERIC_MASK),
 	ID16(ID_AIC7899 & ID_9005_GENERIC_MASK),
@@ -164,15 +164,15 @@ ahc_linux_pci_inherit_flags(struct ahc_softc *ahc)
 	if (master_pdev) {
 		struct ahc_softc *master = pci_get_drvdata(master_pdev);
 		if (master) {
-			ahc->flags &= ~AHC_BIOS_ENABLED; 
+			ahc->flags &= ~AHC_BIOS_ENABLED;
 			ahc->flags |= master->flags & AHC_BIOS_ENABLED;
 
-			ahc->flags &= ~AHC_PRIMARY_CHANNEL; 
+			ahc->flags &= ~AHC_PRIMARY_CHANNEL;
 			ahc->flags |= master->flags & AHC_PRIMARY_CHANNEL;
 		} else
 			printk(KERN_ERR "aic7xxx: no multichannel peer found!\n");
 		pci_dev_put(master_pdev);
-	} 
+	}
 }
 
 static int
@@ -222,7 +222,7 @@ ahc_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (dma_set_mask(dev, DMA_BIT_MASK(32))) {
 			ahc_free(ahc);
 			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
-                	return (-ENODEV);
+			return (-ENODEV);
 		}
 	}
 	ahc->dev_softc = pci;
@@ -441,7 +441,7 @@ ahc_pci_map_int(struct ahc_softc *ahc)
 			    IRQF_SHARED, "aic7xxx", ahc);
 	if (error == 0)
 		ahc->platform_data->irq = ahc->dev_softc->irq;
-	
+
 	return (-error);
 }
 
diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/aic7xxx_pci.c
index dab3a6d..4a63e37 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -898,7 +898,7 @@ ahc_pci_config(struct ahc_softc *ahc, const struct ahc_pci_identity *entry)
 			 * Assume only one connector and always turn
 			 * on termination.
 			 */
- 			our_id = 0x07;
+			our_id = 0x07;
 			sxfrctl1 = STPWEN;
 		}
 		ahc_outb(ahc, SCSICONF, our_id|ENSPCHK|RESET_SCSI);
-- 
2.8.1

