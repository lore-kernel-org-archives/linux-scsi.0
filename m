Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF90C43470
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56C77610FC
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbhDOWKv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:10:51 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:39770 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236614AbhDOWJM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:12 -0400
Received: by mail-pl1-f180.google.com with SMTP id u7so11069058plr.6
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zH1LRW1VV4uLIOqSdoK6cThqjnNjGNHpFlDzcl/ziE8=;
        b=PBQcI+FSjvNoZU0hrHo7dzoV0k5h5eatqHAPEgnpLUb33hjUCWZGHLe0dBTwuS0h0X
         xnSYGSV014nIcfSQoqH6Fpg/JO8UFpAAn+LbY4UTDVtSOYCBm9Cnf8WlVRHoU7azqXin
         urNIpgI76xs/kAOz3FjRvAruLG1lTMoo3B9x1Gn1Wrs6pil/+BYcbp/sBaVbPXoMdZn5
         iTDADK14AKdy7708Iw8LRT9jEN1XldCc+CXXm87bbt8pj8mzQ/Kw+DAeuxANfyi6s20+
         BIdSugM+tXs4j8+EAahqDoY4TKWznJMammRML/wmPkrrLQd1IcNIdwpHn1QZGkgEI780
         ivZQ==
X-Gm-Message-State: AOAM530o4e8VXXlUm/NFDTtDz7RhO5Opmm+IKPrK3WMFgdCjIUla8Kyh
        /Eo/D8C/XiGAnKAdK/v8X26/aZARqJc=
X-Google-Smtp-Source: ABdhPJyPNC2X8iYfYzLvB/NVJkxEaZSlvcckgfT+NKMk//kIuJBylHcprmhapeuMpCWGlY1S+o38EQ==
X-Received: by 2002:a17:903:1c3:b029:e6:a15:751f with SMTP id e3-20020a17090301c3b02900e60a15751fmr6310059plh.44.1618524528752;
        Thu, 15 Apr 2021 15:08:48 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v2 11/20] myrs: Remove unused functions
Date:   Thu, 15 Apr 2021 15:08:17 -0700
Message-Id: <20210415220826.29438-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This was detected by building the kernel with clang and W=1.

Cc: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/myrs.c | 99 ---------------------------------------------
 1 file changed, 99 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index d5ec1cdea0e1..3b68c68d1716 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -2410,13 +2410,6 @@ static inline void DAC960_GEM_ack_hw_mbox_status(void __iomem *base)
 	writel(val, base + DAC960_GEM_IDB_CLEAR_OFFSET);
 }
 
-static inline void DAC960_GEM_gen_intr(void __iomem *base)
-{
-	__le32 val = cpu_to_le32(DAC960_GEM_IDB_GEN_IRQ << 24);
-
-	writel(val, base + DAC960_GEM_IDB_READ_OFFSET);
-}
-
 static inline void DAC960_GEM_reset_ctrl(void __iomem *base)
 {
 	__le32 val = cpu_to_le32(DAC960_GEM_IDB_CTRL_RESET << 24);
@@ -2454,13 +2447,6 @@ static inline void DAC960_GEM_ack_hw_mbox_intr(void __iomem *base)
 	writel(val, base + DAC960_GEM_ODB_CLEAR_OFFSET);
 }
 
-static inline void DAC960_GEM_ack_mem_mbox_intr(void __iomem *base)
-{
-	__le32 val = cpu_to_le32(DAC960_GEM_ODB_MMBOX_ACK_IRQ << 24);
-
-	writel(val, base + DAC960_GEM_ODB_CLEAR_OFFSET);
-}
-
 static inline void DAC960_GEM_ack_intr(void __iomem *base)
 {
 	__le32 val = cpu_to_le32((DAC960_GEM_ODB_HWMBOX_ACK_IRQ |
@@ -2477,14 +2463,6 @@ static inline bool DAC960_GEM_hw_mbox_status_available(void __iomem *base)
 	return (le32_to_cpu(val) >> 24) & DAC960_GEM_ODB_HWMBOX_STS_AVAIL;
 }
 
-static inline bool DAC960_GEM_mem_mbox_status_available(void __iomem *base)
-{
-	__le32 val;
-
-	val = readl(base + DAC960_GEM_ODB_READ_OFFSET);
-	return (le32_to_cpu(val) >> 24) & DAC960_GEM_ODB_MMBOX_STS_AVAIL;
-}
-
 static inline void DAC960_GEM_enable_intr(void __iomem *base)
 {
 	__le32 val = cpu_to_le32((DAC960_GEM_IRQMASK_HWMBOX_IRQ |
@@ -2499,16 +2477,6 @@ static inline void DAC960_GEM_disable_intr(void __iomem *base)
 	writel(val, base + DAC960_GEM_IRQMASK_READ_OFFSET);
 }
 
-static inline bool DAC960_GEM_intr_enabled(void __iomem *base)
-{
-	__le32 val;
-
-	val = readl(base + DAC960_GEM_IRQMASK_READ_OFFSET);
-	return !((le32_to_cpu(val) >> 24) &
-		 (DAC960_GEM_IRQMASK_HWMBOX_IRQ |
-		  DAC960_GEM_IRQMASK_MMBOX_IRQ));
-}
-
 static inline void DAC960_GEM_write_cmd_mbox(union myrs_cmd_mbox *mem_mbox,
 		union myrs_cmd_mbox *mbox)
 {
@@ -2527,11 +2495,6 @@ static inline void DAC960_GEM_write_hw_mbox(void __iomem *base,
 	dma_addr_writeql(cmd_mbox_addr, base + DAC960_GEM_CMDMBX_OFFSET);
 }
 
-static inline unsigned short DAC960_GEM_read_cmd_ident(void __iomem *base)
-{
-	return readw(base + DAC960_GEM_CMDSTS_OFFSET);
-}
-
 static inline unsigned char DAC960_GEM_read_cmd_status(void __iomem *base)
 {
 	return readw(base + DAC960_GEM_CMDSTS_OFFSET + 2);
@@ -2676,11 +2639,6 @@ static inline void DAC960_BA_ack_hw_mbox_status(void __iomem *base)
 	writeb(DAC960_BA_IDB_HWMBOX_ACK_STS, base + DAC960_BA_IDB_OFFSET);
 }
 
-static inline void DAC960_BA_gen_intr(void __iomem *base)
-{
-	writeb(DAC960_BA_IDB_GEN_IRQ, base + DAC960_BA_IDB_OFFSET);
-}
-
 static inline void DAC960_BA_reset_ctrl(void __iomem *base)
 {
 	writeb(DAC960_BA_IDB_CTRL_RESET, base + DAC960_BA_IDB_OFFSET);
@@ -2712,11 +2670,6 @@ static inline void DAC960_BA_ack_hw_mbox_intr(void __iomem *base)
 	writeb(DAC960_BA_ODB_HWMBOX_ACK_IRQ, base + DAC960_BA_ODB_OFFSET);
 }
 
-static inline void DAC960_BA_ack_mem_mbox_intr(void __iomem *base)
-{
-	writeb(DAC960_BA_ODB_MMBOX_ACK_IRQ, base + DAC960_BA_ODB_OFFSET);
-}
-
 static inline void DAC960_BA_ack_intr(void __iomem *base)
 {
 	writeb(DAC960_BA_ODB_HWMBOX_ACK_IRQ | DAC960_BA_ODB_MMBOX_ACK_IRQ,
@@ -2731,14 +2684,6 @@ static inline bool DAC960_BA_hw_mbox_status_available(void __iomem *base)
 	return val & DAC960_BA_ODB_HWMBOX_STS_AVAIL;
 }
 
-static inline bool DAC960_BA_mem_mbox_status_available(void __iomem *base)
-{
-	u8 val;
-
-	val = readb(base + DAC960_BA_ODB_OFFSET);
-	return val & DAC960_BA_ODB_MMBOX_STS_AVAIL;
-}
-
 static inline void DAC960_BA_enable_intr(void __iomem *base)
 {
 	writeb(~DAC960_BA_IRQMASK_DISABLE_IRQ, base + DAC960_BA_IRQMASK_OFFSET);
@@ -2749,14 +2694,6 @@ static inline void DAC960_BA_disable_intr(void __iomem *base)
 	writeb(0xFF, base + DAC960_BA_IRQMASK_OFFSET);
 }
 
-static inline bool DAC960_BA_intr_enabled(void __iomem *base)
-{
-	u8 val;
-
-	val = readb(base + DAC960_BA_IRQMASK_OFFSET);
-	return !(val & DAC960_BA_IRQMASK_DISABLE_IRQ);
-}
-
 static inline void DAC960_BA_write_cmd_mbox(union myrs_cmd_mbox *mem_mbox,
 		union myrs_cmd_mbox *mbox)
 {
@@ -2776,11 +2713,6 @@ static inline void DAC960_BA_write_hw_mbox(void __iomem *base,
 	dma_addr_writeql(cmd_mbox_addr, base + DAC960_BA_CMDMBX_OFFSET);
 }
 
-static inline unsigned short DAC960_BA_read_cmd_ident(void __iomem *base)
-{
-	return readw(base + DAC960_BA_CMDSTS_OFFSET);
-}
-
 static inline unsigned char DAC960_BA_read_cmd_status(void __iomem *base)
 {
 	return readw(base + DAC960_BA_CMDSTS_OFFSET + 2);
@@ -2926,11 +2858,6 @@ static inline void DAC960_LP_ack_hw_mbox_status(void __iomem *base)
 	writeb(DAC960_LP_IDB_HWMBOX_ACK_STS, base + DAC960_LP_IDB_OFFSET);
 }
 
-static inline void DAC960_LP_gen_intr(void __iomem *base)
-{
-	writeb(DAC960_LP_IDB_GEN_IRQ, base + DAC960_LP_IDB_OFFSET);
-}
-
 static inline void DAC960_LP_reset_ctrl(void __iomem *base)
 {
 	writeb(DAC960_LP_IDB_CTRL_RESET, base + DAC960_LP_IDB_OFFSET);
@@ -2962,11 +2889,6 @@ static inline void DAC960_LP_ack_hw_mbox_intr(void __iomem *base)
 	writeb(DAC960_LP_ODB_HWMBOX_ACK_IRQ, base + DAC960_LP_ODB_OFFSET);
 }
 
-static inline void DAC960_LP_ack_mem_mbox_intr(void __iomem *base)
-{
-	writeb(DAC960_LP_ODB_MMBOX_ACK_IRQ, base + DAC960_LP_ODB_OFFSET);
-}
-
 static inline void DAC960_LP_ack_intr(void __iomem *base)
 {
 	writeb(DAC960_LP_ODB_HWMBOX_ACK_IRQ | DAC960_LP_ODB_MMBOX_ACK_IRQ,
@@ -2981,14 +2903,6 @@ static inline bool DAC960_LP_hw_mbox_status_available(void __iomem *base)
 	return val & DAC960_LP_ODB_HWMBOX_STS_AVAIL;
 }
 
-static inline bool DAC960_LP_mem_mbox_status_available(void __iomem *base)
-{
-	u8 val;
-
-	val = readb(base + DAC960_LP_ODB_OFFSET);
-	return val & DAC960_LP_ODB_MMBOX_STS_AVAIL;
-}
-
 static inline void DAC960_LP_enable_intr(void __iomem *base)
 {
 	writeb(~DAC960_LP_IRQMASK_DISABLE_IRQ, base + DAC960_LP_IRQMASK_OFFSET);
@@ -2999,14 +2913,6 @@ static inline void DAC960_LP_disable_intr(void __iomem *base)
 	writeb(0xFF, base + DAC960_LP_IRQMASK_OFFSET);
 }
 
-static inline bool DAC960_LP_intr_enabled(void __iomem *base)
-{
-	u8 val;
-
-	val = readb(base + DAC960_LP_IRQMASK_OFFSET);
-	return !(val & DAC960_LP_IRQMASK_DISABLE_IRQ);
-}
-
 static inline void DAC960_LP_write_cmd_mbox(union myrs_cmd_mbox *mem_mbox,
 		union myrs_cmd_mbox *mbox)
 {
@@ -3025,11 +2931,6 @@ static inline void DAC960_LP_write_hw_mbox(void __iomem *base,
 	dma_addr_writeql(cmd_mbox_addr, base + DAC960_LP_CMDMBX_OFFSET);
 }
 
-static inline unsigned short DAC960_LP_read_cmd_ident(void __iomem *base)
-{
-	return readw(base + DAC960_LP_CMDSTS_OFFSET);
-}
-
 static inline unsigned char DAC960_LP_read_cmd_status(void __iomem *base)
 {
 	return readw(base + DAC960_LP_CMDSTS_OFFSET + 2);
