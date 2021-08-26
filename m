Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC84C4320E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 11:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EB066102A
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Aug 2021 11:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242307AbhHZL6J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Aug 2021 07:58:09 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:38038
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236119AbhHZL6C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Aug 2021 07:58:02 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 87F6B3F0A4;
        Thu, 26 Aug 2021 11:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629979034;
        bh=a3acIGJr3hQUfONLqqFcyO2uTusRuVEX83eJahhUr4w=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=Xr8aA242snZrTfuqtdWETW3Qx3QZrtlG4rNaE8HLy1qdAOWirh125tp+QwrqWBpny
         Uxkr4nAxX5RAMKZgYDkOXrFgm1Q6B32LoMGb4pa04YNfcQbsHGiu9wbg/Fvu/iOPis
         lFKSzqdFha4ToN1NyWDZTEyBLBrdXOPpAbL3hkMu0bJMnCweaLx6ztI2luCaNUaAIL
         zmAQ/qMGMe0L4DDS5np1uNVz/UKuovjG9e3jM52oxjr29sFs6vbRcKm76t69UB72Iq
         nYjkx7G3KbPtgDnqsIIs7kZHEBVcqlViWahtvXUepJRMC6JWMYi2sc9qlbYXd5V1VU
         xMLvFs7TxjWEA==
From:   Colin King <colin.king@canonical.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: core: Fix spelling mistake "does'nt" -> "doesn't"
Date:   Thu, 26 Aug 2021 12:57:14 +0100
Message-Id: <20210826115714.11844-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a spelling mistake in a literal string. Fix it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/sr_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 79d9aa2df528..ddd00efc4882 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -523,7 +523,7 @@ static int sr_read_sector(Scsi_CD *cd, int lba, int blksize, unsigned char *dest
 			return rc;
 		cd->readcd_known = 0;
 		sr_printk(KERN_INFO, cd,
-			  "CDROM does'nt support READ CD (0xbe) command\n");
+			  "CDROM doesn't support READ CD (0xbe) command\n");
 		/* fall & retry the other way */
 	}
 	/* ... if this fails, we switch the blocksize using MODE SELECT */
-- 
2.32.0

