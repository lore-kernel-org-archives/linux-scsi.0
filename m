Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E93C6379F
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 22:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbjBBWCk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 17:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbjBBWC3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 17:02:29 -0500
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7C88A7E1
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 14:02:08 -0800 (PST)
Received: by mail-pg1-f178.google.com with SMTP id 7so2349089pgh.7
        for <linux-scsi@vger.kernel.org>; Thu, 02 Feb 2023 14:02:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ikrUpVBGXYzn/1EetHKC0isY/rB99fOgVxyFG3kBxOM=;
        b=7IDingRNNI5RZUTrbh941zZvxiinsPlEew2cJFPHqHorSnEPwM2KqN4T3zPNd6ANAk
         tyH4ZEezfny9+zNyR4IG9HuDcj3smsFJzyNWsf0qtXltj8t37TNAUzS5dp7Mh7VO9G8a
         nrPu3ijX2UY+KfQgqvBQqOXVtiSlD0i2JkRuezX8kdmfDUo4RTXAX1ybm3dZ4efyahTF
         pT0HVfZiWM1TItcIwzXj1dZfiE66pRe4/GfXYNKsyraFUssXwSZbeEyOvUQB1XiZHOm2
         eh3d+5wt3eAnCQQuUYGFOYxr1XKTAu/leaWGBaBA/dj0Y4ekLFnc4UATzUGdWx/j4Z7s
         0CQQ==
X-Gm-Message-State: AO0yUKXakCwzP3u4GpxScaWaVebvMGYxHTs9ZCFbQUPH86zPFZqucRng
        2NbaMDSPFaSCWkD+Y6QlIi0=
X-Google-Smtp-Source: AK7set/5R2oUPIxpmg6YB7vpLoEYvjh70pMsHW2geqP0cFtPL439A0KeXDId8SWVfu+Vg2O681X6YQ==
X-Received: by 2002:a05:6a00:170c:b0:593:b736:165c with SMTP id h12-20020a056a00170c00b00593b736165cmr8229677pfc.3.1675375323637;
        Thu, 02 Feb 2023 14:02:03 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf7f:37aa:6a01:bf09])
        by smtp.gmail.com with ESMTPSA id x6-20020a623106000000b0058bb79beefcsm162972pfx.123.2023.02.02.14.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 14:02:02 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH] scsi: ufs: Fix kernel-doc syntax
Date:   Thu,  2 Feb 2023 14:01:42 -0800
Message-Id: <20230202220155.561115-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following kernel-doc warnings:

drivers/ufs/core/ufs-mcq.c:87: warning: Function parameter or member 'hba' not described in 'ufshcd_mcq_config_mac'
drivers/ufs/core/ufs-mcq.c:87: warning: Function parameter or member 'max_active_cmds' not described in 'ufshcd_mcq_config_mac'
drivers/ufs/core/ufs-mcq.c:107: warning: Function parameter or member 'hba' not described in 'ufshcd_mcq_req_to_hwq'
drivers/ufs/core/ufs-mcq.c:107: warning: Function parameter or member 'req' not described in 'ufshcd_mcq_req_to_hwq'
drivers/ufs/core/ufs-mcq.c:128: warning: Function parameter or member 'hba' not described in 'ufshcd_mcq_decide_queue_depth'

Cc: Asutosh Das <quic_asutoshd@quicinc.com>
Fixes: 854f84e7feeb ("scsi: ufs: core: mcq: Find hardware queue to queue request")
Fixes: 2468da61ea09 ("scsi: ufs: core: mcq: Configure operation and runtime interface")
Fixes: 7224c806876e ("scsi: ufs: core: mcq: Calculate queue depth")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index dd476f9e797c..31df052fbc41 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -77,8 +77,8 @@ MODULE_PARM_DESC(poll_queues,
 
 /**
  * ufshcd_mcq_config_mac - Set the #Max Activ Cmds.
- * @hba - per adapter instance
- * @max_active_cmds - maximum # of active commands to the device at any time.
+ * @hba: per adapter instance
+ * @max_active_cmds: maximum # of active commands to the device at any time.
  *
  * The controller won't send more than the max_active_cmds to the device at
  * any time.
@@ -96,8 +96,8 @@ void ufshcd_mcq_config_mac(struct ufs_hba *hba, u32 max_active_cmds)
 /**
  * ufshcd_mcq_req_to_hwq - find the hardware queue on which the
  * request would be issued.
- * @hba - per adapter instance
- * @req - pointer to the request to be issued
+ * @hba: per adapter instance
+ * @req: pointer to the request to be issued
  *
  * Returns the hardware queue instance on which the request would
  * be queued.
@@ -114,7 +114,7 @@ struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
 
 /**
  * ufshcd_mcq_decide_queue_depth - decide the queue depth
- * @hba - per adapter instance
+ * @hba: per adapter instance
  *
  * Returns queue-depth on success, non-zero on error
  *
