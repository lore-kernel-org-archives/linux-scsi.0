Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6469BC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46E28613B6
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347114AbhDMRIB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:08:01 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:40670 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347097AbhDMRHw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:07:52 -0400
Received: by mail-pj1-f42.google.com with SMTP id b8-20020a17090a5508b029014d0fbe9b64so11011035pji.5
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XIUJE859cpBexslJPbo7ax8YhKkhM8C9hNE+KPJButo=;
        b=JXqcO0mo1jvQhCkUZbSKFvuMevaaxD+UwFr0GsG4WejN33q/u+kz6gw6ZUiHs8Byt6
         lRaEFhTAgSWppVvdEuvGRC1hh8q5VuqSY/TcGx77pWs19mu3RJLWOoqUNRGCBPlcRWZl
         4B0Dc0bOEEZNgjJ6/NWWQalCaWX/XVqCKHXTc8F6SaN3K6sYB8LquJvZChZqhiyChkRq
         fdOJK0F5Y8dD2I5E0WDuzsB0pHmUL+JW8pC3oA6IkyTrnH9cZzykHeBxUVFm71daf7jx
         DmF/cN8N7oypvvoPEs15/TzBkpLCKH8uah/1iSy8/Zu+DoEI0RF1Zxe8wywwMcgDNEvM
         8a0Q==
X-Gm-Message-State: AOAM532rNt47ZynZeLR99IrGeCV8/7IeTstByUienlUCtOY1eXaAbYLp
        AnHfmEDgt0gRH3EvmuHkIbeVJrNXwXbpmA==
X-Google-Smtp-Source: ABdhPJwKJC8vnPML3Y1TMvyphTThWW2fVXodOHLabLzDA8nKX89PnGxgEh95MH3Z9QwfZSuf0+24Xg==
X-Received: by 2002:a17:90b:1d88:: with SMTP id pf8mr1058713pjb.114.1618333652840;
        Tue, 13 Apr 2021 10:07:32 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 10/20] mpt3sas: Fix two kernel-doc headers
Date:   Tue, 13 Apr 2021 10:07:04 -0700
Message-Id: <20210413170714.2119-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
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
