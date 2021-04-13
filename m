Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA7EC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E3B1613B6
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347101AbhDMRIH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:08:07 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:38725 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347107AbhDMRH5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:07:57 -0400
Received: by mail-pg1-f179.google.com with SMTP id w10so12400637pgh.5
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KyzGQZGlaIODTSdYd0HFN+mM1e1JJYuhpfCa7VaCvm8=;
        b=OquyHRlvSiWmbzwwPFACnFcCQ/m29IYYs3JJPADPsKF0OLwD9phoRam2l5HOJkr3FT
         /opwRM1j7RhXr9BzvXPrnCkpfldL81RHK82gey7IuiajJjK9I2JhoWGoUcqKdPxIQBC2
         HAGDF9WpazgZ7uxdUquIAs9V/ZHrsJCJ1g/NseGgAW7JvM7Tqm5NWGadkSSF73Xf+WgT
         t+DBNp3JUvdD2JZQ44QyiZ4nhLhaIYEN4jWRYO4iOoBzvd2k4eZCPhviyy9miB/kbX29
         5z6m83L/+6Pjva8bijPxZhESsCNvbDH9ICHNVrTYEblbzFOEPvg+SeMtSK7ERsEMNSHA
         9wwA==
X-Gm-Message-State: AOAM5317rOxgyUopQy8hDJWALEWke2xb/o/YZuL1Lwqu5SA6i1vkZqos
        0Jdlnmz9/TB4LzUqs96y4vk=
X-Google-Smtp-Source: ABdhPJzLvlDX04JFDZTE//UXVv8YujspKtaLmDUOnu1N5uA30bepnxUNiRvjmw84fXn52wCrDXol7w==
X-Received: by 2002:a62:160c:0:b029:20a:7b41:f10f with SMTP id 12-20020a62160c0000b029020a7b41f10fmr29949276pfw.67.1618333656505;
        Tue, 13 Apr 2021 10:07:36 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>
Subject: [PATCH 13/20] qla4xxx: Remove an unused function
Date:   Tue, 13 Apr 2021 10:07:07 -0700
Message-Id: <20210413170714.2119-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This was detected by building the kernel with clang and W=1.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Manish Rangankar <mrangankar@marvell.com>
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
