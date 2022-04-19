Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA60EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:58:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347110AbiDSXBG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245617AbiDSXBE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:04 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D542A38BDA
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:20 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id n18so105048plg.5
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F/iOw+gHdiWQR3SIajPkkOTVTmstHvMuCOpTsWqlTrg=;
        b=XN1gu2cpAFtCjrAkPqctXtkaG5NtS9VwCdYzMuH5Q+mdppT+aini6Jn2rrB1bj/Rdd
         LwfEZ7+sysNabQldigba9Se3eSWAzQIjshhaHdQv/sCr8k68dozZ1VIScUZBkH2xeJxz
         yeoghY8TIK53nR9kEXj5zrL4u1KAB5xUnmVToGw3/sDhOmom3y8585/MF95uAcqiFoEr
         ev/WYbcGhQx+W8XZgFO/xPVBG8uAqr1wCeAN3XyGscQhZbAnfAa6fq9cB0emUXVTaYC1
         ZcV1p2bmoWn8huMTS3tCpYNxLAwg31lten1wtzLme958TjwL2ZqqFRQn5yqeM0kSbF+7
         fyBg==
X-Gm-Message-State: AOAM530yDSKM+4mNsbl0Cxy+xtL9LGmb+b1KZkrZf7uVFlmLzYQOui1A
        POvKFAmyu304zRVmTL+Pq6Y=
X-Google-Smtp-Source: ABdhPJydocEl6jMvO6j8Oec1wxTuQtmoFv80ow2Wbp+zQO3T39MeomqHXOJJ3bIQuC5VVUhHQHPTdw==
X-Received: by 2002:a17:902:bcca:b0:153:88c7:a02 with SMTP id o10-20020a170902bcca00b0015388c70a02mr18017979pls.112.1650409100319;
        Tue, 19 Apr 2022 15:58:20 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 01/28] scsi: ufs: Fix a spelling error in a source code comment
Date:   Tue, 19 Apr 2022 15:57:44 -0700
Message-Id: <20220419225811.4127248-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change one occurrence of "adpater" into "adapter".

Reviewed-by: Avri Altman <avri.altman@wdc.com>
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
