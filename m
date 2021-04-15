Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B519C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24C7C610FB
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbhDOWJI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:08 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:44623 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbhDOWJG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:06 -0400
Received: by mail-pl1-f172.google.com with SMTP id d8so12871448plh.11
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GxDiSMyuFn/sCV49iRipvf8PeN03A9NMFW2OA6zCgsM=;
        b=XmoS5Ui1d9qO0SEwa1aRDGrbs6gF1lqU9ZCc7g5U87qJOS0H8xamTOnv/tg+9HsHGV
         LP6qHQk5Tdmu/MjjxHgbR5ykKzqWFzGzCaSUpnmg3zqVPYaIfGCH+1q6YLAMH0KX3tYg
         yiiqvwMohFLVVJDHTQi89zURiY4Wq67UueJLlnk9IvyfoSHu0pAmSJdKkmLBKo2wWIJ2
         yf27xRH79rRCg/lirj1+vS46ABouS2rPFI6CnuGIRls4uba7HXkcegayR2+OoaJ3annT
         oboSLdXGo6++2vrH/5Kk4w4MegFpt0jLsTxpkB2vCUICdqDToqUwvLqzVjzwcZMOLZSN
         Eo3Q==
X-Gm-Message-State: AOAM532RXyjdXxWwRMdvHI0sDSUN+I3Kq8YFWeEkyYyGKg6Talk9PxgX
        iNhxr2omuK8A9EvE6bKStxI=
X-Google-Smtp-Source: ABdhPJx3ADTZ5sPYLfD9ztPGcOflo/ikld/czcTPYGm/SB78mn0oBrT9sZy0o0PUdq5pwoVf0ljIJQ==
X-Received: by 2002:a17:90b:4c0c:: with SMTP id na12mr5924556pjb.117.1618524522879;
        Thu, 15 Apr 2021 15:08:42 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>, aacraid@microsemi.com
Subject: [PATCH v2 06/20] aacraid: Remove an unused function
Date:   Thu, 15 Apr 2021 15:08:12 -0700
Message-Id: <20210415220826.29438-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
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
