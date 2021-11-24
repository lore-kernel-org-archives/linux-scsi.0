Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F9CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 00:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhKXAzk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:55:40 -0500
Received: from mail-pf1-f180.google.com ([209.85.210.180]:34505 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhKXAzj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 19:55:39 -0500
Received: by mail-pf1-f180.google.com with SMTP id r130so982465pfc.1
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 16:52:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/rt9aYXGuG2HyypM9O0RfnNXuMejollxflJLD+tOaqk=;
        b=LOp5nJFqXmNaRg0Y3qtYvEzzrbW4hi98K+2lHzfnh1wHSXId0proumecIKj2S27gmU
         fVltdXQyLYoR65qrI5mr49wXKxpKx5Sp0hVQEfGvSKUUXfh+6L6ZLDNb20Xfu1l8b7R1
         LmXVVci0HmO8SI914bpZ+hsDpJxmya1M6Mipd5/0gIxpDAal0k0BUZd24SVPZuS/NaWt
         0zUcofsEJUMjtPcfLk+FVcaBXWFBg34LZSMm9YHnngvXixaWLeuQO4Utk1Vw2UylZ8uM
         HVmQ2lMI9eat/k27M4qzEGp5zpBx2tg4SNZ4njnRuPAt/+HpSa7/mv++AJVXhC8ylX0U
         5vAA==
X-Gm-Message-State: AOAM531WBV2uSvq40mZcKKvEVGTYZaKQDmKU69/5MZzrkAK0s23V0J6z
        I97d5Htr3FCkd6iPEE1LqLc=
X-Google-Smtp-Source: ABdhPJyCjmeMUviS3RUkZ2Wxg+KGwP21EcaR/furLYazNWXutYeOxt+NWtCXzcGng/Z4w6UOxUF7yg==
X-Received: by 2002:a65:6a4a:: with SMTP id o10mr6904482pgu.357.1637715150234;
        Tue, 23 Nov 2021 16:52:30 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:58e8:6593:938:2bea])
        by smtp.gmail.com with ESMTPSA id x33sm14210387pfh.133.2021.11.23.16.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 16:52:29 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 04/13] scsi: a100u2w: Fix a kernel-doc warning
Date:   Tue, 23 Nov 2021 16:52:08 -0800
Message-Id: <20211124005217.2300458-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211124005217.2300458-1-bvanassche@acm.org>
References: <20211124005217.2300458-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following kernel-doc warning:

drivers/scsi/a100u2w.c:915: warning: Excess function parameter 'done' description in 'inia100_queue_lck'

Fixes: af049dfd0b10 ("scsi: core: Remove the 'done' argument from SCSI queuecommand_lck functions")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/a100u2w.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 564ade03b530..d02eb5b213d0 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -904,13 +904,11 @@ static int inia100_build_scb(struct orc_host * host, struct orc_scb * scb, struc
 /**
  *	inia100_queue_lck		-	queue command with host
  *	@cmd: Command block
- *	@done: Completion function
  *
  *	Called by the mid layer to queue a command. Process the command
  *	block, build the host specific scb structures and if there is room
  *	queue the command down to the controller
  */
-
 static int inia100_queue_lck(struct scsi_cmnd *cmd)
 {
 	struct orc_scb *scb;
