Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D49C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 06:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346557AbhLWGLX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Dec 2021 01:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346538AbhLWGLX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Dec 2021 01:11:23 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942B1C061401
        for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2021 22:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=N17ssC11wD/HHc4p4+p26hQSDYOU0PCLETkulQhmRu0=; b=3YVObeoTkHVabPu+f8eP4evdpo
        RJBOlq6HxVYqDDrZzxYJ8VixNdvDxZkbE7aO/PcDrPb5usosHIZaLawYDZTDe46eqar6XpT3fF2RN
        Aef6T+OG4EUA4Dr229P2+xD/8MovwgdzFKt3MSjYVNQqu9uxOPRoPAgtNqo2O3AFn5G2FC6mSsUv6
        9VPe6Dh1LaU3Cwv4RE6G0JKkQeQZZDe17bW3wCJsL4rv1MrgHUqWoSvqCeNGkIhoFj+/yL/mt/b7R
        ZI6DR0n7wETguD25ilS4jMDIacnFizR5DWvosjLhxXAqQ2agKwhBllHJ5c56BRk9enWEW8Cl65wBt
        mo3Jv2Ew==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0HJx-00Bur6-Rl; Thu, 23 Dec 2021 06:11:21 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-scsi@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: aacraid: fix spelling of "its"
Date:   Wed, 22 Dec 2021 22:11:19 -0800
Message-Id: <20211223061119.18304-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the possessive "its" instead of the contraction "it's" in
user messages.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
---
 drivers/scsi/aacraid/aachba.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20211222.orig/drivers/scsi/aacraid/aachba.c
+++ linux-next-20211222/drivers/scsi/aacraid/aachba.c
@@ -271,7 +271,7 @@ MODULE_PARM_DESC(msi, "IRQ handling."
 	" 0=PIC(default), 1=MSI, 2=MSI-X)");
 module_param(startup_timeout, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(startup_timeout, "The duration of time in seconds to wait for"
-	" adapter to have it's kernel up and\n"
+	" adapter to have its kernel up and\n"
 	"running. This is typically adjusted for large systems that do not"
 	" have a BIOS.");
 module_param(aif_timeout, int, S_IRUGO|S_IWUSR);
