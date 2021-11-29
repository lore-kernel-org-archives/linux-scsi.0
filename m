Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EC6C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 19:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354589AbhK2Tvs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 14:51:48 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:42684 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378862AbhK2Ttq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 14:49:46 -0500
Received: by mail-pf1-f170.google.com with SMTP id u80so18025054pfc.9
        for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2021 11:46:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=54db5IroZ/C1hKDclRAMB0jVjoQpe+ZQfjyZH9rHows=;
        b=um2Ijd4y3WYvrTVznGxKWIEeRZAEd5f/8RRmifyhnRtArKzYUEm62mBw9zx5mXSKym
         ErTMRWCdPUizIjTCuAIvG1d7l6GUmnsurcoiQpE+g2w/yZBOUR3YLyyb2YbY4lEWcFi9
         P73dAuGHO3RDkGoI4SikMX0rBohB6wuiyDvOb/d8jhu6uhU7nJu2y0dTwQvr914LFaEk
         isPd3zOHIutThHYfwfIO8uYsKVOh1VTo1fmctNh7szuvn2frfmzNCgq7Hd/naugZOUsy
         MzMxlC/0Ad/7HTtK1lRVbtfz3p+WLsf1ErBp6jejUCv6giCoMwevH48aqppxsc2QbTKl
         IWtg==
X-Gm-Message-State: AOAM530jPd251DLMAT8UzZPWKmwHhn+9baWMYeYv8cr7Q+2fFj9P/WXW
        WLF85JS1uVE2zWZU2jh3170=
X-Google-Smtp-Source: ABdhPJzZ9maHy1WSIGLEC85vOPaFA89MNp21jv5Ix5iDsupf8PtF4Lo0OKuI2bScTFviCBRvBz2IpQ==
X-Received: by 2002:a62:e908:0:b0:49f:c633:51ec with SMTP id j8-20020a62e908000000b0049fc63351ecmr41028210pfh.1.1638215188577;
        Mon, 29 Nov 2021 11:46:28 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a4a0:8cb5:fff:67db])
        by smtp.gmail.com with ESMTPSA id ns21sm141715pjb.37.2021.11.29.11.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 11:46:28 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 09/12] scsi: megaraid: Fix a kernel-doc warning
Date:   Mon, 29 Nov 2021 11:46:06 -0800
Message-Id: <20211129194609.3466071-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211129194609.3466071-1-bvanassche@acm.org>
References: <20211129194609.3466071-1-bvanassche@acm.org>
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
