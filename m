Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CABC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 00:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhKXAzo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:55:44 -0500
Received: from mail-pl1-f181.google.com ([209.85.214.181]:38751 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbhKXAzm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 19:55:42 -0500
Received: by mail-pl1-f181.google.com with SMTP id o14so469518plg.5
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 16:52:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IXooOpVAgdHelMC36RQc8OYxf3STAnvIi8dYSh5phbg=;
        b=PqtZfUtTKTz7+9a4xMk6MYpALmArAet43tqyje6MWHs1BRdnrcycUTiml3JnGJxSkY
         yxSF1e+tRQFA8JoFW43Tr1Zlrg1HIEpQ6GFiK7JEyKeyhPgdxla/nwA3eh68a/6Mf59T
         SOTgtBsqYT629NbOR78AYXMsGRZzFWZVJj0C//IldtDEH8+dc03lPmgUabtuGBvRUSm/
         DJF5H+0x+GkhwmZ8K5qqY8BCs5tH+X8aBkl7CRPss5W/tsp9e2qTsu+BPRezTSdZeaLp
         erl6ifY4QYMR+D0ExA4IKzMseeBxc38AYXsHmVbIoBLO77ddiwkhg3t7rnIj/Yp3cZ2O
         Ym+w==
X-Gm-Message-State: AOAM531vgcIZmaMU2fIphaHQtHjLG/4k1HSDbmTU2xJ7UeH6VX/bDS6k
        n+bfAI0VbEyeNXqoOCFdOOk=
X-Google-Smtp-Source: ABdhPJwdR9uzacebJNpKBKa3Cd4lgRF4KveA59vUx6xZWebZHB6HCa09mvhSO/6lFJGGFY8O7Gx07A==
X-Received: by 2002:a17:90b:3ec6:: with SMTP id rm6mr9040943pjb.94.1637715153640;
        Tue, 23 Nov 2021 16:52:33 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:58e8:6593:938:2bea])
        by smtp.gmail.com with ESMTPSA id x33sm14210387pfh.133.2021.11.23.16.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 16:52:33 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 06/13] scsi: atp870u: Fix a kernel-doc warning
Date:   Tue, 23 Nov 2021 16:52:10 -0800
Message-Id: <20211124005217.2300458-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211124005217.2300458-1-bvanassche@acm.org>
References: <20211124005217.2300458-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following kernel-doc warning:

drivers/scsi/atp870u.c:622: warning: Excess function parameter 'done' description in 'atp870u_queuecommand_lck'

Fixes: af049dfd0b10 ("scsi: core: Remove the 'done' argument from SCSI queuecommand_lck functions")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/atp870u.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index dcd6fae65a88..7143418d690f 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -614,7 +614,6 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 /**
  *	atp870u_queuecommand_lck -	Queue SCSI command
  *	@req_p: request block
- *	@done: completion function
  *
  *	Queue a command to the ATP queue. Called with the host lock held.
  */
