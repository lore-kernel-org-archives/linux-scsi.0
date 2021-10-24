Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB1B9C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Oct 2021 06:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9028C60D43
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Oct 2021 06:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhJXGqA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Oct 2021 02:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhJXGqA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Oct 2021 02:46:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3077EC061764;
        Sat, 23 Oct 2021 23:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=9D6IPm6QOys3FHSBukDZ2TCC5Jf/U+2diaiKdo3uyjs=; b=0SGqxYTJ6fT3oBL2/2RwLx3g3E
        DQKj/op6h7vVFsP5HyhQoNPoMI38j8PjtnL9Q+8g3Fk+5RoOIrUMnib+A2e3QFUc5MzaZUDSJKLBh
        wVntnPXLcvSmrtB6bL7BKGgw4KwP4n8Am8Z3XN+GKcMNxyJ6YO0TcFqmYYbYI0Yh5920lkiCDo8mM
        GCvMXzfSFyXxpE+Msyer/IckL8/f+tLsz3JAMQkQ5EucPN3mujc5enF6i4DpWB9cgpyJOVlidUcj0
        10lDLIgl5Voaej+kHBy1fmQZGNitK7fZvV6RYNAkU7bY+3WBd2ZpjaAUMDO3topvYBGWbWT5YXh1H
        2GbeS6Dg==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1meXED-00Djcr-IM; Sun, 24 Oct 2021 06:43:33 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: ufs: clean up the Kconfig file
Date:   Sat, 23 Oct 2021 23:43:32 -0700
Message-Id: <20211024064332.16360-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix multiple problems of punctuation, grammar, and spacing in the
UFS Kconfig file.
Also remove the line that says that this code is based on itself.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
---
 drivers/scsi/ufs/Kconfig |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

--- linux-next-20211022.orig/drivers/scsi/ufs/Kconfig
+++ linux-next-20211022/drivers/scsi/ufs/Kconfig
@@ -1,7 +1,6 @@
 #
 # Kernel configuration file for the UFS Host Controller
 #
-# This code is based on drivers/scsi/ufs/Kconfig
 # Copyright (C) 2011-2013 Samsung India Software Operations
 #
 # Authors:
@@ -39,7 +38,7 @@ config SCSI_UFSHCD
 	select DEVFREQ_GOV_SIMPLE_ONDEMAND
 	select NLS
 	help
-	  This selects the support for UFS devices in Linux, say Y and make
+	  This selects the support for UFS devices in Linux. Say Y and make
 	  sure that you know the name of your UFS host adapter (the card
 	  inside your computer that "speaks" the UFS protocol, also
 	  called UFS Host Controller), because you will be asked for it.
@@ -51,7 +50,7 @@ config SCSI_UFSHCD
 	  (the one containing the directory /) is located on a UFS device.
 
 config SCSI_UFSHCD_PCI
-	tristate "PCI bus based UFS Controller support"
+	tristate "PCI bus-based UFS Controller support"
 	depends on SCSI_UFSHCD && PCI
 	help
 	  This selects the PCI UFS Host Controller Interface. Select this if
@@ -70,12 +69,12 @@ config SCSI_UFS_DWC_TC_PCI
 	  If unsure, say N.
 
 config SCSI_UFSHCD_PLATFORM
-	tristate "Platform bus based UFS Controller support"
+	tristate "Platform bus-based UFS Controller support"
 	depends on SCSI_UFSHCD
 	depends on HAS_IOMEM
 	help
 	  This selects the UFS host controller support. Select this if
-	  you have an UFS controller on Platform bus.
+	  you have a UFS controller on Platform bus.
 
 	  If you have a controller with this interface, say Y or M here.
 
@@ -103,23 +102,23 @@ config SCSI_UFS_QCOM
 	select QCOM_SCM if SCSI_UFS_CRYPTO
 	select RESET_CONTROLLER
 	help
-	  This selects the QCOM specific additions to UFSHCD platform driver.
-	  UFS host on QCOM needs some vendor specific configuration before
-	  accessing the hardware which includes PHY configuration and vendor
+	  This selects the QCOM-specific additions to UFSHCD platform driver.
+	  UFS host on QCOM needs some vendor-specific configuration before
+	  accessing the hardware which includes PHY configuration and vendor-
 	  specific registers.
 
 	  Select this if you have UFS controller on QCOM chipset.
 	  If unsure, say N.
 
 config SCSI_UFS_MEDIATEK
-	tristate "Mediatek specific hooks to UFS controller platform driver"
+	tristate "Mediatek-specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && ARCH_MEDIATEK
 	select PHY_MTK_UFS
 	select RESET_TI_SYSCON
 	help
-	  This selects the Mediatek specific additions to UFSHCD platform driver.
-	  UFS host on Mediatek needs some vendor specific configuration before
-	  accessing the hardware which includes PHY configuration and vendor
+	  This selects the Mediatek-specific additions to UFSHCD platform driver.
+	  UFS host on Mediatek needs some vendor-specific configuration before
+	  accessing the hardware which includes PHY configuration and vendor-
 	  specific registers.
 
 	  Select this if you have UFS controller on Mediatek chipset.
@@ -127,10 +126,10 @@ config SCSI_UFS_MEDIATEK
 	  If unsure, say N.
 
 config SCSI_UFS_HISI
-	tristate "Hisilicon specific hooks to UFS controller platform driver"
+	tristate "Hisilicon-specific hooks to UFS controller platform driver"
 	depends on (ARCH_HISI || COMPILE_TEST) && SCSI_UFSHCD_PLATFORM
 	help
-	  This selects the Hisilicon specific additions to UFSHCD platform driver.
+	  This selects the Hisilicon-specific additions to UFSHCD platform driver.
 
 	  Select this if you have UFS controller on Hisilicon chipset.
 	  If unsure, say N.
@@ -165,10 +164,10 @@ config SCSI_UFS_BSG
 	  If unsure, say N.
 
 config SCSI_UFS_EXYNOS
-	tristate "Exynos specific hooks to UFS controller platform driver"
+	tristate "Exynos-specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && (ARCH_EXYNOS || COMPILE_TEST)
 	help
-	  This selects the Samsung Exynos SoC specific additions to UFSHCD
+	  This selects the Samsung Exynos SoC-specific additions to UFSHCD
 	  platform driver.  UFS host on Samsung Exynos SoC includes HCI and
 	  UNIPRO layer, and associates with UFS-PHY driver.
 
@@ -201,7 +200,7 @@ config SCSI_UFS_FAULT_INJECTION
 	  to test the UFS error handler and abort handler.
 
 config SCSI_UFS_HWMON
-	bool "UFS  Temperature Notification"
+	bool "UFS Temperature Notification"
 	depends on SCSI_UFSHCD=HWMON || HWMON=y
 	help
 	  This provides support for UFS hardware monitoring. If enabled,
