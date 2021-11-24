Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82684C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 00:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhKXAzf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:55:35 -0500
Received: from mail-pj1-f46.google.com ([209.85.216.46]:34777 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhKXAzf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 19:55:35 -0500
Received: by mail-pj1-f46.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so3128600pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 16:52:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=spXTifj5M9HBJDRM6qGu3Iug+LkX07oPsHn9kJIHw6o=;
        b=iWimV/0G7EM6vJXS4J+6R1JoVjwoJH1hbOFtxsnFemjVclr5eYq7IO2XqgIbdgWxEA
         Sh4MNy/CNQI/HTqOOIKq6KtewHxD7R0T9JDhmw+EdaEf606/EUUm2uTlhaZyH0TJZ4Nu
         Nf52BfFquualDSrVYGfpKdGkRbcvAeh7HJKKsjYjtByD0Poczao53bP2+Gza2X6VvCOY
         1r4XJsbjhPJWCuZSbK3SfEtTbPW3/Gyyo/bl5EgzCt3w+iTrducw1OmKYuExRNUQDD+Z
         xgCVVyWe4JPP6FicuaUsAc7VqP6+wajHvdMiSf8GnGa5oNKJdV1WM8cEfsDVuJacZylE
         WpDQ==
X-Gm-Message-State: AOAM530nXCSmjCDEv7Pz3DdtfUOnOxu3tzmu5ksRjD+e1HXigk4pffOl
        6msw5NNp4HyIfTIyijq1sWc=
X-Google-Smtp-Source: ABdhPJwc4phSTHOlBM3z3jN/35c1p7osb8Y18RHNAi1FYjFTMN1s0YSAb3AUau16pRT61zkYdTdpJA==
X-Received: by 2002:a17:90a:ec05:: with SMTP id l5mr2615970pjy.68.1637715146290;
        Tue, 23 Nov 2021 16:52:26 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:58e8:6593:938:2bea])
        by smtp.gmail.com with ESMTPSA id x33sm14210387pfh.133.2021.11.23.16.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 16:52:25 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 01/13] scsi: core: Suppress a kernel-doc warning
Date:   Tue, 23 Nov 2021 16:52:05 -0800
Message-Id: <20211124005217.2300458-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211124005217.2300458-1-bvanassche@acm.org>
References: <20211124005217.2300458-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Suppress the following kernel-doc warning:

drivers/scsi/scsi_scan.c:129: warning: Function parameter or member 'dev' not described in 'scsi_enable_async_suspend'

Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 23e1c0acdeae..2f80509fa036 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -122,7 +122,7 @@ struct async_scan_data {
 	struct completion prev_finished;
 };
 
-/**
+/*
  * scsi_enable_async_suspend - Enable async suspend and resume
  */
 void scsi_enable_async_suspend(struct device *dev)
