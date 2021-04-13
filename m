Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41B48C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2550F613B6
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244458AbhDMRHw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:07:52 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:44743 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347068AbhDMRHs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:07:48 -0400
Received: by mail-pf1-f169.google.com with SMTP id m11so11836718pfc.11
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GxDiSMyuFn/sCV49iRipvf8PeN03A9NMFW2OA6zCgsM=;
        b=rMNn829W0jasUgWoMPxZP5VrHsfPXNzYOr/jzPHHObRhrN4c1fOnW0zKpdZvFAECjw
         v3sU3naCHcQHPuhoqTDYSxHSpTlyqkdRAPLjSMvihYxDdWIEx24i1THkVRxOYBczAfoq
         eiy0Ld8XfhWcwQyYZxzhg8H8LLIbNkihKC4H/qYblkUdM5AIRV9pcbEWJthUfNP4+9ss
         n45rMXqmQKCYtNqsk/nwq/ffl+gbAyjkuenDODBXIKbNoRTSXfbPcGcqMgE/UL6gueii
         hrv0s/Eza7fxQey2Q7b+LJUqOL7mF1lc/XrgpRoy/n2yV/YnUInRBwoZmCh57BKwfksv
         YjbQ==
X-Gm-Message-State: AOAM530QLT8/nq7z08cUmVGTadW3epb0sTGhFd1ex2XPyw1VFxgJ7xy4
        gSJXJQa7IRDPJOOcAcqGQ40=
X-Google-Smtp-Source: ABdhPJwLjMjTN8R44v2mBmGwy9MLKCpKC62rHSmtmGcvi9JROJUdhx9rF1jtgONVriSrXn/2alJINg==
X-Received: by 2002:a63:af51:: with SMTP id s17mr32147749pgo.405.1618333648180;
        Tue, 13 Apr 2021 10:07:28 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>, aacraid@microsemi.com
Subject: [PATCH 06/20] aacraid: Remove an unused function
Date:   Tue, 13 Apr 2021 10:07:00 -0700
Message-Id: <20210413170714.2119-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This was detected by building the kernel with clang and W=1.

Cc: aacraid@microsemi.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aacraid/aachba.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 8e06604370c4..f1f62b5da8b7 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1881,11 +1881,6 @@ static inline u32 aac_get_safw_phys_nexus(struct aac_dev *dev, int lun)
 	return *((u32 *)&dev->safw_phys_luns->lun[lun].node_ident[12]);
 }
 
-static inline u32 aac_get_safw_phys_device_type(struct aac_dev *dev, int lun)
-{
-	return dev->safw_phys_luns->lun[lun].node_ident[8];
-}
-
 static inline void aac_free_safw_identify_resp(struct aac_dev *dev,
 						int bus, int target)
 {
