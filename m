Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6024C43460
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBC8A61103
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbhDOWJ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:26 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:42861 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236653AbhDOWJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:22 -0400
Received: by mail-pj1-f50.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so13501295pjv.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/VodvlU3eNTY3fPH2GywD3E7jf85irbiftvc47Tcplg=;
        b=KHIabLcwm7xc4cEySft9GC4r/ONKzM+0MWm5nbAUhKbdPdagSw2AUwsagoVLaizfFF
         jqtikv+5D6WRpB4Kvr1r2HX7YY19b8c8UOw2odUoE05f0ziRumShb5qbegdpZQRIlO9T
         wnF4de+O8p+Q6t+oH5eiPchE9mOVW3LrEWluvtp6t1XO73HhuE4EOaMN5AurEm0cNgUh
         jXSzOf0HLf2JAi4IYboXctem+8Rs1MSWj1jKieuSctEwNMedX3np6gb6SVbBAAMIAQ4h
         vRWIFDdsP06nWc+i1NhQFWd+iJhfHjYgeFNU+VhE1dyw9kQ4peJpsAbQB0c5M9XPqciI
         jOMw==
X-Gm-Message-State: AOAM530WdH0tgJzyoH8MDm4Qwri4yPyf2/ztEMeoR/WMAR7KRdPCDzZ+
        X720vbNp3iMYnIE+sIYlfgM=
X-Google-Smtp-Source: ABdhPJw9QqBaFbKeH3zwJXncSMd4gEkCKBhs3FK8SJuG5CuGxwre8jpsokQUVYbxYnHoGTSyV+Minw==
X-Received: by 2002:a17:90a:bd8c:: with SMTP id z12mr6283609pjr.83.1618524538860;
        Thu, 15 Apr 2021 15:08:58 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH v2 20/20] target/tcm_fc: Fix a kernel-doc header
Date:   Thu, 15 Apr 2021 15:08:26 -0700
Message-Id: <20210415220826.29438-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
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
