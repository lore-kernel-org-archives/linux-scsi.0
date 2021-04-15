Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A312C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A82F7610F7
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236574AbhDOWJP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:15 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:46732 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236566AbhDOWJL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:11 -0400
Received: by mail-pf1-f180.google.com with SMTP id d124so16972041pfa.13
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/GbOGUYJwLlMuH2QMVoGsRNi6a0V4INR/immqPAYXWw=;
        b=RkMoCzCXaKZXl0jcCf09OPGFwfzRl90gGkrs4nll/qZgY/020cD0DilrdPnV6wGeFA
         tSCaUtK+IkPKHIvR1XPVDHw9j/wPwNmqrPcVQ5UG6j+eT3ORsJz39j56+KqHSSQSi8t9
         QO1q77QYsdsn0ffFzA/rjgmvGDnuC4eh3v5HSxYnvjJpMTKUd0hdRUU95i63aztbjhhB
         bBU0LB5VKwYFRCC+z+bwqQFxEyD39rzXRA2QwSHWS47W7NjfdyJiKxrey5sCTMkmjchL
         eY2hnyEfm+ZOyjQKOdjA1XD9ReZBDvc9Su1YT4TLRELl/1xBOEa9JGRj8xdRia4xZAbl
         4B4w==
X-Gm-Message-State: AOAM531hE3YJfbcIMQQSh9b/dXbkblnr/sNsxYtIfO6iM96UIJmBxBch
        jv9O9AZZgEYOGL4qJLYcXXEfHEQ5PJ0=
X-Google-Smtp-Source: ABdhPJxbXRx0UT76B3RRbD93aSAsg+Zrt59b4Ub3pJUGNu1YEdJi9wz+ED+rGSAAGK5F+xg66f4O+g==
X-Received: by 2002:a05:6a00:acb:b029:23d:60f9:5471 with SMTP id c11-20020a056a000acbb029023d60f95471mr5040394pfl.77.1618524527582;
        Thu, 15 Apr 2021 15:08:47 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v2 10/20] myrb: Remove unused functions
Date:   Thu, 15 Apr 2021 15:08:16 -0700
Message-Id: <20210415220826.29438-11-bvanassche@acm.org>
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
