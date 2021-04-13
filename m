Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1001FC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDEF7613B6
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347116AbhDMRIJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:08:09 -0400
Received: from mail-pf1-f179.google.com ([209.85.210.179]:38694 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347108AbhDMRH5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:07:57 -0400
Received: by mail-pf1-f179.google.com with SMTP id y16so11844204pfc.5
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ao+1gjnM4zv5kQxaxG+NtayTZuJSXP+ga3mJvJUCkuU=;
        b=Xb9E3lXLyiir3IFU59SkBQPnPpQ2lR/4Fhxb86i+VgSxZqi3xvySpc9jNBqK/AK3x2
         8jSOMdmjkGso6lVR4EZtKkIHWa6mVCvKrTGC0KWwz+7plXFGADhZkv+rpb5wE+vtrOc5
         jiWeqjnS/+vIugOfzr82zg7TR7b252HKR1y0oCakY5Q1GgLLKBTPHHxUe6CxobjQsibf
         Rf8+qG1JD4q/8zR8RSf5owUAOvRVzneoG1YoWoX7pYnAPBy/pPkYDMNBI3M3nHmZ5uAt
         kQCmxzyqU/O1ihwjKptGbiLLMqJNPKqkHPtBR23LpRBVdGuocKsPeNNfgDkGgIa/fVch
         h/Vw==
X-Gm-Message-State: AOAM533wBkwFtLkDFNuE2X2WXMaCDgwiEp+dnzbz8AN49R5rAwZGPgxu
        /fcsuhESXK1iMy9QE4Mf2y4=
X-Google-Smtp-Source: ABdhPJy9OP850yN48GnFIKjHf9SjtwzA4AnEAr+Q2aRsYth2ZFOjkvS4YN8+8+21KMTrXKGG4bo1SQ==
X-Received: by 2002:a05:6a00:16d0:b029:249:adf8:6fb8 with SMTP id l16-20020a056a0016d0b0290249adf86fb8mr15798999pfc.58.1618333657748;
        Tue, 13 Apr 2021 10:07:37 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>
Subject: [PATCH 14/20] smartpqi: Remove unused functions
Date:   Tue, 13 Apr 2021 10:07:08 -0700
Message-Id: <20210413170714.2119-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This was detected by building the kernel with clang and W=1.

Cc: Don Brace <don.brace@microchip.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 3b0f281daa2b..80d5c00379ee 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -443,11 +443,6 @@ static inline void pqi_cancel_rescan_worker(struct pqi_ctrl_info *ctrl_info)
 	cancel_delayed_work_sync(&ctrl_info->rescan_work);
 }
 
-static inline void pqi_cancel_event_worker(struct pqi_ctrl_info *ctrl_info)
-{
-	cancel_work_sync(&ctrl_info->event_work);
-}
-
 static inline u32 pqi_read_heartbeat_counter(struct pqi_ctrl_info *ctrl_info)
 {
 	if (!ctrl_info->heartbeat_counter)
@@ -4828,11 +4823,6 @@ static inline int pqi_enable_events(struct pqi_ctrl_info *ctrl_info)
 	return pqi_configure_events(ctrl_info, true);
 }
 
-static inline int pqi_disable_events(struct pqi_ctrl_info *ctrl_info)
-{
-	return pqi_configure_events(ctrl_info, false);
-}
-
 static void pqi_free_all_io_requests(struct pqi_ctrl_info *ctrl_info)
 {
 	unsigned int i;
