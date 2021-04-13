Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6697EC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C2D7613B7
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347121AbhDMRIE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:08:04 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:54021 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347102AbhDMRHy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:07:54 -0400
Received: by mail-pj1-f45.google.com with SMTP id t23so8798056pjy.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/GbOGUYJwLlMuH2QMVoGsRNi6a0V4INR/immqPAYXWw=;
        b=Z3Cl9SUOIeMdaBK3R+kQYSJRdkh/jn5xtU9a3o/llCEABCJgqfndbRClmpYUHorAUC
         wGsIyc+AAegjCYXPEtW7DhJ4wfvpfNyrgUjJFJzqyIMzptgOCkdXwmV//DDdtnZB8H9H
         UII608+LyNfihW0tMVexz/MVz/78LNkHapC2C6Wn/ToSP3RL2ItU8B2FPYQtW1XE88RN
         ZV4GUshPUbkgtwDYYafVa7nYDcNG29owZaUC1cc8fFgaK9+jdbcBFAxbHEElksPnJzxt
         Q4aSTzoeJrFOzrNdutaWi/Arh+dNcC18Q4PYHfXTZjVj3/xKtUAC2+G7BLNxTdMh8zSI
         3zZg==
X-Gm-Message-State: AOAM530cWLWj3uAbkpZNMgZEqFmbkvxHyj8Yz21epVCEZoGs2a0S6PUN
        VNAnL2wweNkIuHX/sYiVCUlKvjHbmzLpLw==
X-Google-Smtp-Source: ABdhPJyRXWoDXMiCqXNcPqQJRrRf8cJt9deffflCHJWNcQd1y7qbnqZKrxORRuQYstgo7aPWSBnpmQ==
X-Received: by 2002:a17:90a:6582:: with SMTP id k2mr1036073pjj.11.1618333653950;
        Tue, 13 Apr 2021 10:07:33 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 11/20] myrb: Remove unused functions
Date:   Tue, 13 Apr 2021 10:07:05 -0700
Message-Id: <20210413170714.2119-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This was detected by building the kernel with clang and W=1.

Cc: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/myrb.c | 71 ---------------------------------------------
 1 file changed, 71 deletions(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 56767f8610d4..d9c82e211ae7 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -2552,11 +2552,6 @@ static inline void DAC960_LA_ack_hw_mbox_status(void __iomem *base)
 	writeb(DAC960_LA_IDB_HWMBOX_ACK_STS, base + DAC960_LA_IDB_OFFSET);
 }
 
-static inline void DAC960_LA_gen_intr(void __iomem *base)
-{
-	writeb(DAC960_LA_IDB_GEN_IRQ, base + DAC960_LA_IDB_OFFSET);
-}
-
 static inline void DAC960_LA_reset_ctrl(void __iomem *base)
 {
 	writeb(DAC960_LA_IDB_CTRL_RESET, base + DAC960_LA_IDB_OFFSET);
@@ -2586,11 +2581,6 @@ static inline void DAC960_LA_ack_hw_mbox_intr(void __iomem *base)
 	writeb(DAC960_LA_ODB_HWMBOX_ACK_IRQ, base + DAC960_LA_ODB_OFFSET);
 }
 
-static inline void DAC960_LA_ack_mem_mbox_intr(void __iomem *base)
-{
-	writeb(DAC960_LA_ODB_MMBOX_ACK_IRQ, base + DAC960_LA_ODB_OFFSET);
-}
-
 static inline void DAC960_LA_ack_intr(void __iomem *base)
 {
 	writeb(DAC960_LA_ODB_HWMBOX_ACK_IRQ | DAC960_LA_ODB_MMBOX_ACK_IRQ,
@@ -2604,13 +2594,6 @@ static inline bool DAC960_LA_hw_mbox_status_available(void __iomem *base)
 	return odb & DAC960_LA_ODB_HWMBOX_STS_AVAIL;
 }
 
-static inline bool DAC960_LA_mem_mbox_status_available(void __iomem *base)
-{
-	unsigned char odb = readb(base + DAC960_LA_ODB_OFFSET);
-
-	return odb & DAC960_LA_ODB_MMBOX_STS_AVAIL;
-}
-
 static inline void DAC960_LA_enable_intr(void __iomem *base)
 {
 	unsigned char odb = 0xFF;
@@ -2627,13 +2610,6 @@ static inline void DAC960_LA_disable_intr(void __iomem *base)
 	writeb(odb, base + DAC960_LA_IRQMASK_OFFSET);
 }
 
-static inline bool DAC960_LA_intr_enabled(void __iomem *base)
-{
-	unsigned char imask = readb(base + DAC960_LA_IRQMASK_OFFSET);
-
-	return !(imask & DAC960_LA_IRQMASK_DISABLE_IRQ);
-}
-
 static inline void DAC960_LA_write_cmd_mbox(union myrb_cmd_mbox *mem_mbox,
 		union myrb_cmd_mbox *mbox)
 {
@@ -2656,11 +2632,6 @@ static inline void DAC960_LA_write_hw_mbox(void __iomem *base,
 	writeb(mbox->bytes[12], base + DAC960_LA_MBOX12_OFFSET);
 }
 
-static inline unsigned char DAC960_LA_read_status_cmd_ident(void __iomem *base)
-{
-	return readb(base + DAC960_LA_STSID_OFFSET);
-}
-
 static inline unsigned short DAC960_LA_read_status(void __iomem *base)
 {
 	return readw(base + DAC960_LA_STS_OFFSET);
@@ -2828,11 +2799,6 @@ static inline void DAC960_PG_ack_hw_mbox_status(void __iomem *base)
 	writel(DAC960_PG_IDB_HWMBOX_ACK_STS, base + DAC960_PG_IDB_OFFSET);
 }
 
-static inline void DAC960_PG_gen_intr(void __iomem *base)
-{
-	writel(DAC960_PG_IDB_GEN_IRQ, base + DAC960_PG_IDB_OFFSET);
-}
-
 static inline void DAC960_PG_reset_ctrl(void __iomem *base)
 {
 	writel(DAC960_PG_IDB_CTRL_RESET, base + DAC960_PG_IDB_OFFSET);
@@ -2862,11 +2828,6 @@ static inline void DAC960_PG_ack_hw_mbox_intr(void __iomem *base)
 	writel(DAC960_PG_ODB_HWMBOX_ACK_IRQ, base + DAC960_PG_ODB_OFFSET);
 }
 
-static inline void DAC960_PG_ack_mem_mbox_intr(void __iomem *base)
-{
-	writel(DAC960_PG_ODB_MMBOX_ACK_IRQ, base + DAC960_PG_ODB_OFFSET);
-}
-
 static inline void DAC960_PG_ack_intr(void __iomem *base)
 {
 	writel(DAC960_PG_ODB_HWMBOX_ACK_IRQ | DAC960_PG_ODB_MMBOX_ACK_IRQ,
@@ -2880,13 +2841,6 @@ static inline bool DAC960_PG_hw_mbox_status_available(void __iomem *base)
 	return odb & DAC960_PG_ODB_HWMBOX_STS_AVAIL;
 }
 
-static inline bool DAC960_PG_mem_mbox_status_available(void __iomem *base)
-{
-	unsigned char odb = readl(base + DAC960_PG_ODB_OFFSET);
-
-	return odb & DAC960_PG_ODB_MMBOX_STS_AVAIL;
-}
-
 static inline void DAC960_PG_enable_intr(void __iomem *base)
 {
 	unsigned int imask = (unsigned int)-1;
@@ -2902,13 +2856,6 @@ static inline void DAC960_PG_disable_intr(void __iomem *base)
 	writel(imask, base + DAC960_PG_IRQMASK_OFFSET);
 }
 
-static inline bool DAC960_PG_intr_enabled(void __iomem *base)
-{
-	unsigned int imask = readl(base + DAC960_PG_IRQMASK_OFFSET);
-
-	return !(imask & DAC960_PG_IRQMASK_DISABLE_IRQ);
-}
-
 static inline void DAC960_PG_write_cmd_mbox(union myrb_cmd_mbox *mem_mbox,
 		union myrb_cmd_mbox *mbox)
 {
@@ -2931,12 +2878,6 @@ static inline void DAC960_PG_write_hw_mbox(void __iomem *base,
 	writeb(mbox->bytes[12], base + DAC960_PG_MBOX12_OFFSET);
 }
 
-static inline unsigned char
-DAC960_PG_read_status_cmd_ident(void __iomem *base)
-{
-	return readb(base + DAC960_PG_STSID_OFFSET);
-}
-
 static inline unsigned short
 DAC960_PG_read_status(void __iomem *base)
 {
@@ -3106,11 +3047,6 @@ static inline void DAC960_PD_ack_hw_mbox_status(void __iomem *base)
 	writeb(DAC960_PD_IDB_HWMBOX_ACK_STS, base + DAC960_PD_IDB_OFFSET);
 }
 
-static inline void DAC960_PD_gen_intr(void __iomem *base)
-{
-	writeb(DAC960_PD_IDB_GEN_IRQ, base + DAC960_PD_IDB_OFFSET);
-}
-
 static inline void DAC960_PD_reset_ctrl(void __iomem *base)
 {
 	writeb(DAC960_PD_IDB_CTRL_RESET, base + DAC960_PD_IDB_OFFSET);
@@ -3152,13 +3088,6 @@ static inline void DAC960_PD_disable_intr(void __iomem *base)
 	writeb(0, base + DAC960_PD_IRQEN_OFFSET);
 }
 
-static inline bool DAC960_PD_intr_enabled(void __iomem *base)
-{
-	unsigned char imask = readb(base + DAC960_PD_IRQEN_OFFSET);
-
-	return imask & DAC960_PD_IRQMASK_ENABLE_IRQ;
-}
-
 static inline void DAC960_PD_write_cmd_mbox(void __iomem *base,
 		union myrb_cmd_mbox *mbox)
 {
