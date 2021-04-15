Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8296C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A0FA610F7
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbhDOWJN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:13 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:40819 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236535AbhDOWJK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:10 -0400
Received: by mail-pg1-f176.google.com with SMTP id b17so17859902pgh.7
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XIUJE859cpBexslJPbo7ax8YhKkhM8C9hNE+KPJButo=;
        b=PecJCWQH9pjZQhM7d4hihsrYXgVT3yldlmIYVj1Tc2Zc0yLH6gNGLOV7LLknIUEVN+
         iQROuC74VzAUJyn75L+l6yCCJe9lZdxIjb5AImFd1zrH9znJBugbwvKTASHq3zg3LXVy
         Td+RpP9GMCzBBhwV8UDmJ2OaQoCALgGD+0dt509G/P4+gNl3Ny29aztOPiP67unviua8
         DHiqcL39z9+Y9IrEXKFERfwZucALsnHRXgPgs6LZ3ms8fId1ML9qLF9uV089aF/uYk2q
         PaDZ2JKRuMlEJHXfyO8fjHTe45XTC6nHmk/KuB3f17DFRiIYt2b1ks46JcnWAuUmOkC+
         F6Nw==
X-Gm-Message-State: AOAM530otk+6MLbjj/Y6TuiqW4OjoOUCZf/uYV52TesYnVBdOXp7OQ49
        K+uZ0iSbJVg5qLDnUIFnXQ0=
X-Google-Smtp-Source: ABdhPJyjMtPY9sgzuFuxJNnuu0RTaFtE9zy/0nwKdQCtPpkkEQQ4mooIip6b97d3zS282aW+Mea6xw==
X-Received: by 2002:aa7:9316:0:b029:244:7616:edc7 with SMTP id 22-20020aa793160000b02902447616edc7mr5202466pfj.19.1618524526377;
        Thu, 15 Apr 2021 15:08:46 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v2 09/20] mpt3sas: Fix two kernel-doc headers
Date:   Thu, 15 Apr 2021 15:08:15 -0700
Message-Id: <20210415220826.29438-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following warnings:

drivers/scsi/mpt3sas/mpt3sas_base.c:5430: warning: Excess function parameter 'ct' description in '_base_allocate_pcie_sgl_pool'
drivers/scsi/mpt3sas/mpt3sas_base.c:5493: warning: Excess function parameter 'ctr' description in '_base_allocate_chain_dma_pool'

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Fixes: d6adc251dd2f ("scsi: mpt3sas: Force PCIe scatterlist allocations to be within same 4 GB region")
Fixes: 7dd847dae1c4 ("scsi: mpt3sas: Force chain buffer allocations to be within same 4 GB region")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 84c507587166..5779f313f6f8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5421,7 +5421,7 @@ _base_reduce_hba_queue_depth(struct MPT3SAS_ADAPTER *ioc)
  *			for pcie sgl pools.
  * @ioc: Adapter object
  * @sz: DMA Pool size
- * @ct: Chain tracker
+ *
  * Return: 0 for success, non-zero for failure.
  */
 
@@ -5485,7 +5485,7 @@ _base_allocate_pcie_sgl_pool(struct MPT3SAS_ADAPTER *ioc, u32 sz)
  *			for chain dma pool.
  * @ioc: Adapter object
  * @sz: DMA Pool size
- * @ctr: Chain tracker
+ *
  * Return: 0 for success, non-zero for failure.
  */
 static int
