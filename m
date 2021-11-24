Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC742C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 00:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbhKXAzv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:55:51 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:42713 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbhKXAzs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 19:55:48 -0500
Received: by mail-pf1-f172.google.com with SMTP id u80so920102pfc.9
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 16:52:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=54db5IroZ/C1hKDclRAMB0jVjoQpe+ZQfjyZH9rHows=;
        b=PEosImsyLvqZk4yidPjDnOq72g9pIh0RWSuHnBgrwKt0lmOvzUgYOVc6bmdMd6epac
         urUpcDEu6fpO37SYX3dbACoRpITe0xbPdPtbw09xTQM9ElOyNAhvH9lotJOmByqdqKqd
         oKNigQLUX5YDp+2LZfJFHnrn3lXWt1+9WJvL4OFfQK4+IhF9X6WzwvWs7NcEJXj5cYYx
         xq257/01/zRprxbPjUStDSa5SPeXi1NZD7UdZih8qo7ES9e3zQXTBSs2xDKJUvvzLg+4
         DrvP2WjidqEISPA9q2zUIKmreGM85+jt6f6qhLSoID4MPpZAkWDZ48vekVjcgs1rytKz
         JOdw==
X-Gm-Message-State: AOAM533TAvepWs5JGYOIFxiGUjEnSTTW4parenPzA7SJJVXstrjMcpaN
        +ncCwf41aGRNe8Ef8T/fB1gZrwsalH1sdQ==
X-Google-Smtp-Source: ABdhPJw6oRkBx3GtA27WECXIsNkJmJt1UsKVW7PTz81FzXJ6DQsRPb1m+zeBo8T8OQWAmSi1uQkrYg==
X-Received: by 2002:a05:6a00:21c4:b0:475:e532:3d18 with SMTP id t4-20020a056a0021c400b00475e5323d18mr1702176pfj.40.1637715159004;
        Tue, 23 Nov 2021 16:52:39 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:58e8:6593:938:2bea])
        by smtp.gmail.com with ESMTPSA id x33sm14210387pfh.133.2021.11.23.16.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 16:52:38 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 10/13] scsi: megaraid: Fix a kernel-doc warning
Date:   Tue, 23 Nov 2021 16:52:14 -0800
Message-Id: <20211124005217.2300458-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211124005217.2300458-1-bvanassche@acm.org>
References: <20211124005217.2300458-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following kernel-doc warning:

drivers/scsi/megaraid/megaraid_mbox.c:1439: warning: Excess function parameter 'done' description in 'megaraid_queue_command_lck'

Fixes: af049dfd0b10 ("scsi: core: Remove the 'done' argument from SCSI queuecommand_lck functions")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/megaraid/megaraid_mbox.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 14f930d27ca1..2a339d4a7e9d 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1431,7 +1431,6 @@ mbox_post_cmd(adapter_t *adapter, scb_t *scb)
 /**
  * megaraid_queue_command_lck - generic queue entry point for all LLDs
  * @scp		: pointer to the scsi command to be executed
- * @done	: callback routine to be called after the cmd has be completed
  *
  * Queue entry point for mailbox based controllers.
  */
