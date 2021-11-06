Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31CC7C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Nov 2021 16:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ABA061165
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Nov 2021 16:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbhKFQu2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbhKFQu2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Nov 2021 12:50:28 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A385FC061570
        for <linux-scsi@vger.kernel.org>; Sat,  6 Nov 2021 09:47:46 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:91c6:551:e507:741f])
        by michel.telenet-ops.be with bizsmtp
        id F4nk2600E4BJ5g4064nku1; Sat, 06 Nov 2021 17:47:44 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mjOr1-00AbiU-W1; Sat, 06 Nov 2021 17:47:43 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mjOr1-006akn-Ex; Sat, 06 Nov 2021 17:47:43 +0100
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] scsi: ufs: Fix double space in SCSI_UFS_HWMON description
Date:   Sat,  6 Nov 2021 17:47:41 +0100
Message-Id: <20211106164741.1571206-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There's no reason to have a double space between "UFS" and
"Temperature", hence drop it.

Fixes: e88e2d32200a1734 ("scsi: ufs: core: Probe for temperature notification support")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/ufs/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index a43f4d947f1bf8a8..9fe27b01904e7477 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -200,7 +200,7 @@ config SCSI_UFS_FAULT_INJECTION
 	  to test the UFS error handler and abort handler.
 
 config SCSI_UFS_HWMON
-	bool "UFS  Temperature Notification"
+	bool "UFS Temperature Notification"
 	depends on SCSI_UFSHCD=HWMON || HWMON=y
 	help
 	  This provides support for UFS hardware monitoring. If enabled,
-- 
2.25.1

