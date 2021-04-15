Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B2FDC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 144EB610FC
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236628AbhDOWJQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:16 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:43999 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236535AbhDOWJN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:13 -0400
Received: by mail-pg1-f173.google.com with SMTP id p12so17851799pgj.10
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/40ULsOzuBJGbirgNhlsl95kB4g+ICHnH0SncregTg0=;
        b=ANWnxpZQAfso126LYe1i/A8y87ndXY987rCqOQ7UMWFKRfkhy7EPnYCZg+RmxEfVj6
         r0Mnwy+78wRmsDRwHP4fi+U3G7S/W+Mosialf9fxaXvAgFdiQ4r+s7HFd3uDVlKwGQy/
         fcWvZq4ALBAfLSkCGbZrqf3Rigbc8hZUqTYElyC56V3U6SxXAfJ1vEPV3jtJ+58q6qcE
         4Z+x60X9zlgbqPQYOCB1vC/S+esLtlcgnCrVZS6rpBaLX+zX03D/XJnK9gIuGGsllXuH
         fPWe+jA7LYZGOzdFy0fsWW+KAAzm+2+6mK4Uzky1YCZG5JfJwktdZ0UpO8rRCDfRy3mM
         Ldig==
X-Gm-Message-State: AOAM532/OqO4NS1Q+nYZWzEE/iPSRdTSO6v9gUdFvQjevbFJfBzruSfT
        +72NZTm2Qz7GvfjRKvivLso=
X-Google-Smtp-Source: ABdhPJzp1L4XpqBsEJvyA6Iq5R+eH+nIX3rclPx4Y5CMqJdxRGCxxn8xNwXjI0+BGSUOdAgjil6UWA==
X-Received: by 2002:aa7:88c6:0:b029:250:bf78:a4a3 with SMTP id k6-20020aa788c60000b0290250bf78a4a3mr4947740pff.70.1618524529931;
        Thu, 15 Apr 2021 15:08:49 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:49 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>
Subject: [PATCH v2 12/20] qla4xxx: Remove an unused function
Date:   Thu, 15 Apr 2021 15:08:18 -0700
Message-Id: <20210415220826.29438-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This was detected by building the kernel with clang and W=1.

Cc: Nilesh Javali <njavali@marvell.com>
Acked-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla4xxx/ql4_nx.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index e6e35e6958f6..66a487795c53 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -3634,12 +3634,6 @@ flash_conf_addr(struct ql82xx_hw_data *hw, uint32_t faddr)
 	return hw->flash_conf_off | faddr;
 }
 
-static inline uint32_t
-flash_data_addr(struct ql82xx_hw_data *hw, uint32_t faddr)
-{
-	return hw->flash_data_off | faddr;
-}
-
 static uint32_t *
 qla4_82xx_read_flash_data(struct scsi_qla_host *ha, uint32_t *dwptr,
     uint32_t faddr, uint32_t length)
