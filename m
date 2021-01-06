Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF38C433DB
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 20:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B3102313A
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 20:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbhAFU7S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 15:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbhAFU7S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 15:59:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8709C061575;
        Wed,  6 Jan 2021 12:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=MtAZtBv2AaN9L8zWymJidX1647wvqCghprSsKEu5gyA=; b=T0BzwB62Rc+7yunloOAFKrpQ0t
        NOYBcT3GKzqDthsWdKQhVbw/xPZHgyrbgQzyH3ON/5XePlJs7225GoudKcKiHDO6pPhE7bPCNq1am
        teYOU89keSbNTcpe28AFWVLA4eoKmyYR5POCJ1+zeTnofkd7OwWgdz9I9ZOpHButFhvd42s23T73X
        4CNR9LWWCkaPZ5Gcw2BW/nWOhIHDvnymwALZBncx0G35Bu8e2fLqJWpUU5jn6jPcXYyXP4BauWheO
        csrXmq+NAe2ZKNFCNIFQ63DqeGPFsMCBloORLtktN14QBIADo0c5OM+ApfA4aljhKiMhElL7oQA7W
        euJ82Dpw==;
Received: from [2601:1c0:6280:3f0::79df] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kxFqZ-002iAd-Am; Wed, 06 Jan 2021 20:56:45 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH -next] scsi: ufs: fix all Kconfig help text indentation
Date:   Wed,  6 Jan 2021 12:55:54 -0800
Message-Id: <20210106205554.18082-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use consistent and expected indentation for all Kconfig text.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
---
 drivers/scsi/ufs/Kconfig |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- linux-next-20210106.orig/drivers/scsi/ufs/Kconfig
+++ linux-next-20210106/drivers/scsi/ufs/Kconfig
@@ -39,7 +39,7 @@ config SCSI_UFSHCD
 	select DEVFREQ_GOV_SIMPLE_ONDEMAND
 	select NLS
 	help
-	This selects the support for UFS devices in Linux, say Y and make
+	  This selects the support for UFS devices in Linux, say Y and make
 	  sure that you know the name of your UFS host adapter (the card
 	  inside your computer that "speaks" the UFS protocol, also
 	  called UFS Host Controller), because you will be asked for it.
@@ -54,8 +54,8 @@ config SCSI_UFSHCD_PCI
 	tristate "PCI bus based UFS Controller support"
 	depends on SCSI_UFSHCD && PCI
 	help
-	This selects the PCI UFS Host Controller Interface. Select this if
-	you have UFS Host Controller with PCI Interface.
+	  This selects the PCI UFS Host Controller Interface. Select this if
+	  you have UFS Host Controller with PCI Interface.
 
 	  If you have a controller with this interface, say Y or M here.
 
@@ -73,10 +73,10 @@ config SCSI_UFSHCD_PLATFORM
 	tristate "Platform bus based UFS Controller support"
 	depends on SCSI_UFSHCD
 	help
-	This selects the UFS host controller support. Select this if
-	you have an UFS controller on Platform bus.
+	  This selects the UFS host controller support. Select this if
+	  you have an UFS controller on Platform bus.
 
-	If you have a controller with this interface, say Y or M here.
+	  If you have a controller with this interface, say Y or M here.
 
 	  If unsure, say N.
 
@@ -84,7 +84,7 @@ config SCSI_UFS_CDNS_PLATFORM
 	tristate "Cadence UFS Controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM
 	help
-	This selects the Cadence-specific additions to UFSHCD platform driver.
+	  This selects the Cadence-specific additions to UFSHCD platform driver.
 
 	  If unsure, say N.
 
