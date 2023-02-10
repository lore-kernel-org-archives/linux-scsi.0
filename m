Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B333AC05027
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Feb 2023 20:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbjBJUwc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Feb 2023 15:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbjBJUw2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2023 15:52:28 -0500
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F306025BA7
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 12:52:27 -0800 (PST)
Received: by mail-pl1-f169.google.com with SMTP id b5so7772577plz.5
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 12:52:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvAIWAxilX42GnQTgU1rO5h0Pxr8qRH2gVWXjZtbVtg=;
        b=0MqrJHZJ2r6yvmvFiszk8o08lN9jQb5RhJvIIYluHt/wqtAMzpiGt8tAaE/tZ6d7D/
         mOnvnGzq6zc3nGcYVe1y/NvssDAf/kXU2z0IjjVYR/QJqpngoo2YWu3Mm7GKhotzzQ4l
         pYF76RIGC6n3CiORny8htBvpDBaWdpeS084eUXHVE/7BMpQntqrdEfSLq1CWQXhR1Ta9
         2C3crDDOjaiP1sT0n9SQSbKFFjyOg+itTYkDGQOi+ZOgRXxd8SeHJ5Z2DtfkStF0XTpU
         J3rpQpobeKQDN126i5VfiFBJbgXkMKZxd1sUxtNEBd5UOCqGMDgm38vcWk7AD9LdfuO/
         fefA==
X-Gm-Message-State: AO0yUKU4KuQSmI0mxXOeses7KxV9P26fjZLtJO8JmTUneoLCqx24H7Hm
        lBExZapBDUG7twnFAqYqF9M=
X-Google-Smtp-Source: AK7set+oKy/pFe336Wv4LBUNSU6XeeRX75FGDVqOqLCyFK8Hrwn20wej1A0XqnWvlzDQb40VMkZB0w==
X-Received: by 2002:a17:902:e0cb:b0:19a:7622:23e4 with SMTP id e11-20020a170902e0cb00b0019a762223e4mr2087695pla.66.1676062347404;
        Fri, 10 Feb 2023 12:52:27 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a834:2664:42:db8b])
        by smtp.gmail.com with ESMTPSA id jm13-20020a17090304cd00b001948ff5cc32sm3745752plb.215.2023.02.10.12.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 12:52:26 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Lee Duncan <lduncan@suse.com>,
        Sagi Grimberg <sagig@mellanox.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 1/2] scsi: core: Fix a source code comment
Date:   Fri, 10 Feb 2023 12:51:59 -0800
Message-Id: <20230210205200.36973-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
In-Reply-To: <20230210205200.36973-1-bvanassche@acm.org>
References: <20230210205200.36973-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix a reference in a source code comment to the scsi_remove_host()
function.

Fixes: b49493f99690 ("Fix a memory leak in scsi_host_dev_release()")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 12346e2297fd..b28375f9e019 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -356,7 +356,7 @@ static void scsi_host_dev_release(struct device *dev)
 		/*
 		 * Free the shost_dev device name here if scsi_host_alloc()
 		 * and scsi_host_put() have been called but neither
-		 * scsi_host_add() nor scsi_host_remove() has been called.
+		 * scsi_host_add() nor scsi_remove_host() has been called.
 		 * This avoids that the memory allocated for the shost_dev
 		 * name is leaked.
 		 */
