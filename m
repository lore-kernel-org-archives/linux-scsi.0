Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F684C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347502AbiDLSV2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238105AbiDLSVZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:21:25 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913AB3AF
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:19:06 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id bx5so19233425pjb.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:19:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qe0C3WunpAjWztLU0SeIdFoCyB5+szNaPjdtGrw9eHU=;
        b=pDJw8RxdEXIbiV3ZOeWvjrglW4qHXAPDdss+wEPjJtz7NKpjlZ3gBSctbfG7+RUerB
         raI3Hyfy3WScAQ5Raf6G+yKLBnEjGjNgJEinvzyP800MEUuNuRfg3SATCd1YvIHU6Fbq
         e/+Hac59pD8QueYJQw/hS32ftKK9lbD0YkdgnI6prsgIrBTwcav8ybN2PfTjvlEGibg1
         C2d+/stmp/2y+hCMTOJ4EZ+hbpzODFmHRlDmRDmfvvUGXVp758Fd3q49UTPJxvZjOOcM
         vW0f6abKLdAKlZPWBOPt274/4Yb3CRIb224YtADOKL0TdzL2qD6ur+J1IH4DidwbZK89
         o+yw==
X-Gm-Message-State: AOAM531bKCCdz3oRMB01uNvFiMty1lCMlel/X/yKoGq7/r9rWzCjEsvo
        mYaKXiYcVeOLRYPaIPcUz1E=
X-Google-Smtp-Source: ABdhPJxxmumsSbulQdBxGWi2fPz4U+4TJb60vQBhDGp3OtJCoIcX5IBGajzwaBh68KIcBwix2BWZNw==
X-Received: by 2002:a17:903:248:b0:155:ecb7:dfaf with SMTP id j8-20020a170903024800b00155ecb7dfafmr39022109plh.84.1649787545991;
        Tue, 12 Apr 2022 11:19:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:19:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 01/29] scsi: ufs: Fix a spelling error in a source code comment
Date:   Tue, 12 Apr 2022 11:18:25 -0700
Message-Id: <20220412181853.3715080-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change one occurrence of "adpater" into "adapter".

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/unipro.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 8e9e486a4f7b..705a6465ba5c 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -103,7 +103,7 @@
 #define UNIPRO_CB_OFFSET(x)			(0x8000 | x)
 
 /*
- * PHY Adpater attributes
+ * PHY Adapter attributes
  */
 #define PA_ACTIVETXDATALANES	0x1560
 #define PA_ACTIVERXDATALANES	0x1580
