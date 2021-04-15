Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0543BC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB0A2610FB
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236649AbhDOWJR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:17 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:34611 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236589AbhDOWJP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:15 -0400
Received: by mail-pj1-f42.google.com with SMTP id em21-20020a17090b0155b029014e204a81e6so5391672pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ao+1gjnM4zv5kQxaxG+NtayTZuJSXP+ga3mJvJUCkuU=;
        b=cKNwO/i22thQco+gc3aSmmqPFuET/R4bCuMRMTEoTzxTT0fJPL9GDh+EBLBCTQFRIZ
         lQ6IqbgihnFNeVosCwzue1GTVHTTZMM/1Hv2ZICiHSWXG2W7qb8PFXRctgq/jygMPtGP
         cIloBwreOm5OLZ9OWKUSyX0eeOepb5EJtjvwXPsH/k8o1jm2YmhjoeDqqX6IhR5ZKG52
         SmcHMmea57LZ0wsfV9iCWE8GbmjoJlh9CcDDiAqCIEqNoVY+o05X/uaRbyALDj3xFqgM
         4MYNZfTqgm18Ole58UfuaiSrvjQzRV1IOFSdCTZbAbwyMrjV+Cs5n77Q9jYoRGbun7Oi
         eOHQ==
X-Gm-Message-State: AOAM532F2EfHNtICkrq3X0jK/IoJ9O+69syHPUxZ78lsvrlQUXcKc8dS
        rz3CWQDbe3BQNUOCuLTuOP4=
X-Google-Smtp-Source: ABdhPJzd6VTG7eqg8bXCFP1SLrHCVfklRBQ64U++r7XNB0Hmk9ur12A+7XHeIHPPQvlKrXIZOruJWA==
X-Received: by 2002:a17:90a:5b11:: with SMTP id o17mr6436408pji.32.1618524531063;
        Thu, 15 Apr 2021 15:08:51 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>
Subject: [PATCH v2 13/20] smartpqi: Remove unused functions
Date:   Thu, 15 Apr 2021 15:08:19 -0700
Message-Id: <20210415220826.29438-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This was detected by building the kernel with clang and W=1.

Cc: Don Brace <don.brace@microchip.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 3b0f281daa2b..80d5c00379ee 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -443,11 +443,6 @@ static inline void pqi_cancel_rescan_worker(struct pqi_ctrl_info *ctrl_info)
 	cancel_delayed_work_sync(&ctrl_info->rescan_work);
 }
 
-static inline void pqi_cancel_event_worker(struct pqi_ctrl_info *ctrl_info)
-{
-	cancel_work_sync(&ctrl_info->event_work);
-}
-
 static inline u32 pqi_read_heartbeat_counter(struct pqi_ctrl_info *ctrl_info)
 {
 	if (!ctrl_info->heartbeat_counter)
@@ -4828,11 +4823,6 @@ static inline int pqi_enable_events(struct pqi_ctrl_info *ctrl_info)
 	return pqi_configure_events(ctrl_info, true);
 }
 
-static inline int pqi_disable_events(struct pqi_ctrl_info *ctrl_info)
-{
-	return pqi_configure_events(ctrl_info, false);
-}
-
 static void pqi_free_all_io_requests(struct pqi_ctrl_info *ctrl_info)
 {
 	unsigned int i;
