Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AED1BC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 19:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353754AbhK2Tvr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 14:51:47 -0500
Received: from mail-pg1-f180.google.com ([209.85.215.180]:35632 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378839AbhK2Ttp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 14:49:45 -0500
Received: by mail-pg1-f180.google.com with SMTP id j11so7292951pgs.2
        for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2021 11:46:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nmSr4aGAqiYob5EbKWRQg54NwSmiITSVXf9eYWzcg/A=;
        b=aYlIJaLRwOugIOWWJnRn01/k/t35+wPWKup9uyp28V0C6l73joqMFiZLSVrh/BX6wr
         Xzq11aTTrUUq/7dEfBvp95mLx2xEAi7SzeChdE0I8VxUlwcPZ2w/eWKh3Gc6/e/6XOP1
         X6Tn198VlIzfZdZVjBwCgq+5OUhPFc5ohF+SBYvKtUe/kt2wzfZXmlFbPkirmbEGh42r
         uutbb3cLAsJCHaDVEcKerVGbxak5x47d9rkKFA98/+fgz9VaK87OQC7p20hN2UAeq3Ui
         FVzf9brvjR++5n+6rxG1pyL+IsC175aVzgbmWk0S3O0qHuWupHUscI5vRqyMekS7OrUR
         pRaQ==
X-Gm-Message-State: AOAM533tSo/wPc+xGsrUCe8L3CmkabQC/yaSof0fT1wjguzdBWir6m9A
        gCKqOlXEdV+6QPCyoYOaCS4=
X-Google-Smtp-Source: ABdhPJwZ0nHKJPJUV3KCIDW2XGFJzfKON9K6oMSzFQNeME7uzB1mZDEsfa0FUvWHFvhm20mD4JOdlA==
X-Received: by 2002:a05:6a00:14ce:b0:49f:dc1c:a0fb with SMTP id w14-20020a056a0014ce00b0049fdc1ca0fbmr42109299pfu.56.1638215187265;
        Mon, 29 Nov 2021 11:46:27 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a4a0:8cb5:fff:67db])
        by smtp.gmail.com with ESMTPSA id ns21sm141715pjb.37.2021.11.29.11.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 11:46:26 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 08/12] scsi: initio: Fix a kernel-doc warning
Date:   Mon, 29 Nov 2021 11:46:05 -0800
Message-Id: <20211129194609.3466071-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211129194609.3466071-1-bvanassche@acm.org>
References: <20211129194609.3466071-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following kernel-doc warning:

drivers/scsi/initio.c:2613: warning: Excess function parameter 'done' description in 'i91u_queuecommand_lck'

Fixes: af049dfd0b10 ("scsi: core: Remove the 'done' argument from SCSI queuecommand_lck functions")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/initio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index fd6da96bc51a..9cdee38f5ba3 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2602,13 +2602,11 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
 /**
  *	i91u_queuecommand_lck	-	Queue a new command if possible
  *	@cmd: SCSI command block from the mid layer
- *	@done: Completion handler
  *
  *	Attempts to queue a new command with the host adapter. Will return
  *	zero if successful or indicate a host busy condition if not (which
  *	will cause the mid layer to call us again later with the command)
  */
-
 static int i91u_queuecommand_lck(struct scsi_cmnd *cmd)
 {
 	struct initio_host *host = (struct initio_host *) cmd->device->host->hostdata;
