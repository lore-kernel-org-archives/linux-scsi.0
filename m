Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA16C43600
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85762613B7
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347119AbhDMRIM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:08:12 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:39815 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347124AbhDMRIF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:08:05 -0400
Received: by mail-pf1-f175.google.com with SMTP id c17so11839623pfn.6
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/VodvlU3eNTY3fPH2GywD3E7jf85irbiftvc47Tcplg=;
        b=GVxmyLe8tQq3AREld7O0tHW0MJfoZg0oCYzCaTJxIDzF+M70Qcvlb9Y9kKlufp0bmH
         AIqozYMc0jp+VNCBUyfJqxskAla99ULCO7UkTQoFglYGYSrwat67w1JHwAMmbxtvb3uS
         vYjirPbzL3N10qpq165n0aH9OPKX4acSwwUUvYsBPiN6kbR1APaRoPPOlNny/20Z3Ta3
         Y+xUDUOlxudvbslkuQAaMLGGv91OuSX1IRNkKgkcgEMhw/H2zwDZ56HkbvEaR1Igskdm
         yFS75z+6jfc4VaLyZ4XrffL6CanVqsuqX/CV6N1XWvplzLnKUPfUKUFc0rC7+Vfx7N2n
         CjkQ==
X-Gm-Message-State: AOAM530pOvuZhy4GtZx3V+vRETnPeeZysnjijvdpSzvSK+o1/Fw1PhFR
        8GsN4jRg+iiLhR41JVgLc+s=
X-Google-Smtp-Source: ABdhPJwZNbnsMdfYPM9FfUzFdt7T/2J3RoCJ9ja2vLMJyzRPKvN7RC3rOzwiqVj4a0fAwfUxtUYLNw==
X-Received: by 2002:a63:1f4d:: with SMTP id q13mr22632029pgm.453.1618333665054;
        Tue, 13 Apr 2021 10:07:45 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 20/20] target/tcm_fc: Fix a kernel-doc header
Date:   Tue, 13 Apr 2021 10:07:14 -0700
Message-Id: <20210413170714.2119-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the function name in the kernel-doc header above ft_prli().

Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/tcm_fc/tfc_sess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 23ce506d5402..593540da9346 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -410,7 +410,7 @@ static int ft_prli_locked(struct fc_rport_priv *rdata, u32 spp_len,
 }
 
 /**
- * tcm_fcp_prli() - Handle incoming or outgoing PRLI for the FCP target
+ * ft_prli() - Handle incoming or outgoing PRLI for the FCP target
  * @rdata: remote port private
  * @spp_len: service parameter page length
  * @rspp: received service parameter page (NULL for outgoing PRLI)
