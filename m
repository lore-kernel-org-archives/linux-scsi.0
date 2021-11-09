Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF7DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 01:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12AFE61156
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 01:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241543AbhKIB5t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 20:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbhKIB5s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 20:57:48 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE553C061570;
        Mon,  8 Nov 2021 17:55:03 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id n85so13365323pfd.10;
        Mon, 08 Nov 2021 17:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JbqtK658HjjBX7Ai59s1DbgYLdPVxHDCSv6hlqTNw0A=;
        b=NTvC/fJQxvvWnrCqEJi+APG41EbM8jUnUfUwcFiy767NEWUZj2+FqTWn4RRze2xhGy
         RZqWNx64sMWO0BbbMxJkB+GjBr30GpxKEzAKjaBCthNbGRzbdbFjXZVXQrgnRF9LZG0J
         HxS40ViDo2OgrqtFdwdz0jCI7G3tuwZTadC/rQ+q+SOOVcVzGP2QK5ODONPyyrPAR/Tr
         KDFlpmWwqbeG0YxWKumVYqRNjF6sBjutaohZDGErj/8UzYlTZ9TZTSRDhBwZDMSd+GIF
         WEoqbX4zFSy+fNkM1h+0J+3f8XMxlbSQnreQCRQFtllLdxiKSzQbpHy9MwCh0ZJGY76B
         Ja+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JbqtK658HjjBX7Ai59s1DbgYLdPVxHDCSv6hlqTNw0A=;
        b=hZVYCHrVavSu9q9ucVypNeP2M6smktkUzw5vzkBhVZ7DB4eCq0axnIHzp5MRXAkt83
         /HwnidG8RE5tYwssLUIO1mvP+euEaomOrDeIPBZQe3WDx7vp7Dyh+gLRYT58mnXCPnuC
         pBGk20Ub1Xdv6WNm+IpGcB4be7sP36B10mXpFWPIJrX5qGv/LhUUAKkhAdpaaSsZ5OV/
         lm4sMM4nUtyUZIV/ywZklhgSinzSS9+7L2KBSfDR2q0CacbzdNp8SJ5/ztpNTPwE6G+r
         kLjrgpwei5HcMzfZdAwh3za8uQ06oSb22np9QL4swHakOsUkwnunrFGEqeqgcH9Tpvni
         /MCQ==
X-Gm-Message-State: AOAM530x/sN57vjdEKxFoPO0zs2zVfHHl//qdS1G9Tr6UhkmvYSoG14l
        u+R2y7+NJdcl5LPMz4hqtFo=
X-Google-Smtp-Source: ABdhPJxMsF9My9Tzd11yFzd92CKfXUFv78F/aWgiKFX9VGgKk475gI+rxDCpyAlmFlUK3w9uUNNNbg==
X-Received: by 2002:a63:f34c:: with SMTP id t12mr3092503pgj.70.1636422903401;
        Mon, 08 Nov 2021 17:55:03 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id s25sm16455199pfm.138.2021.11.08.17.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 17:55:03 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: ran.jianping@zte.com.cn
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ran jianping <ran.jianping@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi:pmcraid: remove unneeded semicolon
Date:   Tue,  9 Nov 2021 01:54:57 +0000
Message-Id: <20211109015457.129545-1-ran.jianping@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: ran jianping <ran.jianping@zte.com.cn>

 Eliminate the following coccinelle check warning:
 drivers/scsi/pmcraid.c:5085:2-3

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ran jianping <ran.jianping@zte.com.cn>
---
 drivers/scsi/pmcraid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 88046a793767..85febecde7b8 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -5082,7 +5082,7 @@ static int pmcraid_init_instance(struct pci_dev *pdev, struct Scsi_Host *host,
 			mapped_pci_addr + chip_cfg->ioa_host_mask_clr;
 		pint_regs->global_interrupt_mask_reg =
 			mapped_pci_addr + chip_cfg->global_intr_mask;
-	};
+	}
 
 	pinstance->ioa_reset_attempts = 0;
 	init_waitqueue_head(&pinstance->reset_wait_q);
-- 
2.25.1

