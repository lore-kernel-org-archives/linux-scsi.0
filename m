Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7E6CA9EC4
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 23:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C9882086A
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 23:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfJ2XHT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 19:07:19 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35975 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfJ2XHT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Oct 2019 19:07:19 -0400
Received: by mail-pg1-f194.google.com with SMTP id j22so142624pgh.3
        for <linux-scsi@vger.kernel.org>; Tue, 29 Oct 2019 16:07:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NvdJ0J3EFSq0dGCh9Kl/4cuq+hGjdyFm+8JtozGH+b4=;
        b=eMefxGBUNykU/3jF024/Xm2ZG+0SOi8X75ipgtNMLdKhluwK7ZeDAmP/hG23loJX5L
         bpYvDO8rOtahpcRdN+EpxdPzxKzjTfIkgFehZLF8+dzqC2CLcUjWpgvx0ZUg4F80xI6r
         ppoua0Saeq7HTt9vN3kryMly2MDJfBkZGobaP9Y0ejYmJkDueco9Xpw3L9G2t5DSSfO1
         lf6u7XV+uUsPkObXm2N7cj23Iuf4xGatI1rRamC01KXikMDVV1jfrX1d5ecHkNaWz2I8
         2HJSkxc3sGMWPMJoiPz0ImfRx8NlexvjdtkRDLhYW1124Oon9IG8T+DChgKepH94dOVL
         H44A==
X-Gm-Message-State: APjAAAXHyX7HIIBhCxp7p3OXcfqgF1VBlr1ssGo20629vSef/SsWXvo/
        t0Lvg55RZgp2Ndu9kf8tP9o=
X-Google-Smtp-Source: APXvYqxOzF1tlvde/gRkdG/gGvpvndWmZL0BhXCAgdIQPWC3HVI4vj/3U/RfJBBiKLoqdO822EM6TQ==
X-Received: by 2002:a17:90a:9293:: with SMTP id n19mr9778596pjo.67.1572390438259;
        Tue, 29 Oct 2019 16:07:18 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id z21sm170500pfa.119.2019.10.29.16.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 16:07:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/3] ufs: Fix kernel-doc warnings
Date:   Tue, 29 Oct 2019 16:07:08 -0700
Message-Id: <20191029230710.211926-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
In-Reply-To: <20191029230710.211926-1-bvanassche@acm.org>
References: <20191029230710.211926-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following three kernel-doc warnings:

drivers/scsi/ufs/ufs_bsg.c:165: warning: Function parameter or member 'hba' not described in 'ufs_bsg_remove'
drivers/scsi/ufs/ufshcd.c:5789: warning: Function parameter or member 'cmd_type' not described in 'ufshcd_issue_devman_upiu_cmd'
drivers/scsi/ufs/ufshcd.c:5789: warning: Excess function parameter 'msgcode' description in 'ufshcd_issue_devman_upiu_cmd'

Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs_bsg.c | 1 +
 drivers/scsi/ufs/ufshcd.c  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index a9344eb4e047..3a2e68f1ad42 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -158,6 +158,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 
 /**
  * ufs_bsg_remove - detach and remove the added ufs-bsg node
+ * @hba: per adapter object
  *
  * Should be called when unloading the driver.
  */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c28c144d9b4a..7ced77c8cc4d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5768,9 +5768,9 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
  * @hba:	per-adapter instance
  * @req_upiu:	upiu request
  * @rsp_upiu:	upiu reply
- * @msgcode:	message code, one of UPIU Transaction Codes Initiator to Target
  * @desc_buff:	pointer to descriptor buffer, NULL if NA
  * @buff_len:	descriptor size, 0 if NA
+ * @cmd_type:	specifies the type (NOP, Query...)
  * @desc_op:	descriptor operation
  *
  * Those type of requests uses UTP Transfer Request Descriptor - utrd.
-- 
2.24.0.rc0.303.g954a862665-goog

