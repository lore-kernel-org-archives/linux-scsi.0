Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C27C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 07:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB4C560F02
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 07:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhKBHMR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 03:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbhKBHLs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 03:11:48 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2418C061230;
        Tue,  2 Nov 2021 00:09:05 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y20so7903359pfi.4;
        Tue, 02 Nov 2021 00:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2h7taCbuxqRD4r9qvk+kIniAwnodtq+huHXyFqPigRU=;
        b=VO7o82tgv1j0JGPD74AkmwNBGMC/fsYR5DWSDPNIST/5MK9ozEXGf2xz0x0MiWdR/6
         O/whH3Y61YQAzbIl4I31g8Jz7jGLVd5bZmrWKe9sVjqCEimsQ8p37p6BpdgpI6HeBZAI
         K8MKlF9dmq1qZNhHtLacLHrER3NOKLr3SWX2m5q2IWhCi+Lbpmy8sPuttXszbRuPUwSk
         ZMPa/P1AHhO1klWBz8OwhJE3mo08UwwgBLnpXn1f/MlzbqW9bTL+sUdd3kjTaUvmhfsF
         L6somPEnOSPY17xTqECDxkmFQ1/qphmdGBpRuOR84x7AGiDxGUm+HIf307iSdblc/C59
         lwvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2h7taCbuxqRD4r9qvk+kIniAwnodtq+huHXyFqPigRU=;
        b=yHSYfYMzC9oyJIUe+bkeK5u7SfBH9oiHwc29foSCRbq6RY4+y9jnQjlQ/TTsq++qR9
         0O63IB0i+uphLVTEfQdhcPYizzPTIMQmHrDxcjkkBWALDCYVdJvHthrfpkii+NG/XiIv
         e9032SKZuVAqG0WsVkK2t2LUBlDI06r11lsGC86tV3iwWUIiqxwhQljR4h49A1Aagfgs
         K1OA621tHdFHGfQyOq9jhq1wFTmrq/rLFCJLLEhrG7qV3Z0xrEqVcEiGldwY3VlnKQSU
         WNNhcqbLzlxL2Po9YsdkdLEB2lUJhw7il3hkk4XhMYmeycUxyQ/kYfitKHfWvbOn9FpP
         L8xQ==
X-Gm-Message-State: AOAM532iT8L5pd0RhKrwX3I9ASlbqXab9cwQsUOlyHLdLF059DzJMNEL
        PNY3FBai5jUdVaM/oDLQYlc=
X-Google-Smtp-Source: ABdhPJx7Zr6lQGXpQ0DBWtTZdXdDC/yTaPvT1LTpMdJsgORIT7xNUa283TVyevtiSHnEUf13gDq2mg==
X-Received: by 2002:a62:e406:0:b0:480:fd90:1082 with SMTP id r6-20020a62e406000000b00480fd901082mr15600501pfh.45.1635836945272;
        Tue, 02 Nov 2021 00:09:05 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id z24sm15753874pgu.54.2021.11.02.00.09.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 00:09:05 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: zhang.mingyu@zte.com.cn
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhang Mingyu <zhang.mingyu@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi:pmcraid:Remove unneeded semicolon
Date:   Tue,  2 Nov 2021 07:08:57 +0000
Message-Id: <20211102070857.5468-1-zhang.mingyu@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Zhang Mingyu <zhang.mingyu@zte.com.cn>

Eliminate the following coccinelle check warning:
drivers/scsi/pmcraid.c:5085:2-3

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Zhang Mingyu <zhang.mingyu@zte.com.cn>
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

