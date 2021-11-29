Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D8E8C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 19:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352616AbhK2Tvm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 14:51:42 -0500
Received: from mail-pf1-f175.google.com ([209.85.210.175]:39588 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378641AbhK2Ttl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 14:49:41 -0500
Received: by mail-pf1-f175.google.com with SMTP id i12so18028998pfd.6
        for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2021 11:46:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IXooOpVAgdHelMC36RQc8OYxf3STAnvIi8dYSh5phbg=;
        b=NQRVsIkwtD7dkiOQVbbWVG2OV1R7iTSLMZ3CyZSrrrLE9fum7OMbgA9vHjWBQK8GYV
         PUClqqOF0qT+/f1ywoUJM6N+FxldWp8+QD9y+AfnM9wvcAXa/h031VuMu62P05dej6UJ
         yz3dSaoS1uHtyN89TJ6OTd1LusOENOEaNDBN0WLhNXdR/9n1uAGnuLQRQ0DFfM7FuPd2
         JJwkYsFBcTnGxPyX2oksPRJDg94dR2ixjDSM0s/L5IvHZ2GodJNJd45sB0aEZhLf4sKR
         wZ5kZL8Mv2/YZHf17Uuo1WLyLjEtAGqaUAHuXhd3Iq/ZXswwvvIVC/nK01ZOagiKN1eE
         6lPg==
X-Gm-Message-State: AOAM532s10GiRpwcDSyoXdf/ru5KSPbnMmebfcxrb6BE2M3QCfIJeRGE
        nG9lZLdzdyibYuRa6CIvOVw=
X-Google-Smtp-Source: ABdhPJzn80bvEbHIdup8IZXKEBhknHlzcZf5RqDwGlWJrUVKD8sZlyp95swhhfyH0pSbJYb0eoeJSw==
X-Received: by 2002:a65:6702:: with SMTP id u2mr36393185pgf.24.1638215183327;
        Mon, 29 Nov 2021 11:46:23 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a4a0:8cb5:fff:67db])
        by smtp.gmail.com with ESMTPSA id ns21sm141715pjb.37.2021.11.29.11.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 11:46:22 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 05/12] scsi: atp870u: Fix a kernel-doc warning
Date:   Mon, 29 Nov 2021 11:46:02 -0800
Message-Id: <20211129194609.3466071-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211129194609.3466071-1-bvanassche@acm.org>
References: <20211129194609.3466071-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following kernel-doc warning:

drivers/scsi/atp870u.c:622: warning: Excess function parameter 'done' description in 'atp870u_queuecommand_lck'

Fixes: af049dfd0b10 ("scsi: core: Remove the 'done' argument from SCSI queuecommand_lck functions")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/atp870u.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index dcd6fae65a88..7143418d690f 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -614,7 +614,6 @@ static irqreturn_t atp870u_intr_handle(int irq, void *dev_id)
 /**
  *	atp870u_queuecommand_lck -	Queue SCSI command
  *	@req_p: request block
- *	@done: completion function
  *
  *	Queue a command to the ATP queue. Called with the host lock held.
  */
