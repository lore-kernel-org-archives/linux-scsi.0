Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58FDEC3F2D1
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 04:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CD1A208C3
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 04:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgCEEyl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 23:54:41 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33352 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgCEEyk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 23:54:40 -0500
Received: by mail-pl1-f193.google.com with SMTP id ay11so2090197plb.0
        for <linux-scsi@vger.kernel.org>; Wed, 04 Mar 2020 20:54:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lf1QL76ziI65U5gOivbA3x8nMKWkWYV8h3cJoAZMWyI=;
        b=VhoArE5rgtu5dT0IoCzoSbI1OpoiFjGKJeGbA8j+J2tuyZdezJF8PKM8MBnjZS3HSv
         tjaw0900BySnxIgt65KApj8lXF5cDL+b6ZwmKlmb7LmihD4Q004Thd+nYqkrdLUbX12R
         lMKOVyI4sgNjRjNi63ReCQCm0EFDo1jTYq5qHK+WpCOsqcuRNFWhhQiViO1pJmrIDKh7
         /ygo9sGwwHMuSc1OJdxPPoLvGxrXGhhTKlFwgMVylw6C9qzUUWLQ2LcL5pEj+DzzaY3q
         r2C4glX0lXf9dWYiZuqkyXSL06fZ4V14ZVszBbbpPLrrQ4gCMNnDtnijt7DEdFpHaW6f
         OBfw==
X-Gm-Message-State: ANhLgQ3nhTL67ZFS4XthX3+ZyG6wpsTk/vjx5kpSwnU0Q1/KYQIjAbis
        PdQdSTCRnbt9ReE5IYspJ9s=
X-Google-Smtp-Source: ADFU+vtQ9Ru9W8KRLFie6xPAxAW18lA6amhaVma0lg1S+WDHOZiCRRxHjEhxFllhwcJJc3ohe3OpUg==
X-Received: by 2002:a17:902:7d98:: with SMTP id a24mr6488405plm.307.1583384079632;
        Wed, 04 Mar 2020 20:54:39 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:ec16:4fc:3bb2:cb4a])
        by smtp.gmail.com with ESMTPSA id y14sm313721pfp.59.2020.03.04.20.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 20:54:38 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v3 1/6] qla2xxx: Sort BUILD_BUG_ON() statements alphabetically
Date:   Wed,  4 Mar 2020 20:54:26 -0800
Message-Id: <20200305045431.30061-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200305045431.30061-1-bvanassche@acm.org>
References: <20200305045431.30061-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Before adding more BUILD_BUG_ON() statements, sort the existing statements
alphabetically.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3e65b8e9ed47..17d85c4d1e3e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7858,11 +7858,11 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct init_cb_24xx) != 128);
 	BUILD_BUG_ON(sizeof(struct init_cb_81xx) != 128);
 	BUILD_BUG_ON(sizeof(struct pt_ls4_request) != 64);
+	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
+	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
 	BUILD_BUG_ON(sizeof(struct sns_cmd_pkt) != 2064);
 	BUILD_BUG_ON(sizeof(struct verify_chip_entry_84xx) != 64);
 	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
-	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
-	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
 
 	/* Allocate cache for SRBs. */
 	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
