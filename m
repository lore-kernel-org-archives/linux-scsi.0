Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF99FC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C36C2610F7
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 22:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbhDOWJD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 18:09:03 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:45858 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbhDOWJB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 18:09:01 -0400
Received: by mail-pg1-f169.google.com with SMTP id d10so17850582pgf.12
        for <linux-scsi@vger.kernel.org>; Thu, 15 Apr 2021 15:08:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cGnCPOgIA7Gkds8X6fZBW7kNO67PcbciQBssYoARmjw=;
        b=O4S8+jfqkqRuK/3QNDw/lMlAFazasdHLyaHikgmIvM0xhj6fVFOZmhvUK3hLoEoJUP
         7FKW4en6/NMu35wmdbpgU9m/55JRyeGn4tTSw0cY20xZ9c1dYj7YBEaYOF3qSU3JEmFy
         vVE/CDhv9ICD26yIQ/oZIDXYAD0s81j+GtZuS5/3U2aWSpA+9yiS/YTsCJYkNiueNAFj
         dyMBpq7stnJqyRo3Ze+xDh1vKh3BK6sPTmxsYfS72GwPOX+VF2z7HG2n7M2pp1kRtt6V
         RZw+utb1WKSvX+fbdB02EKuKZ5iuNdTWtfqD/eJUMQfCBPshp7rYOfXQtcwj0zvTceEZ
         ikxg==
X-Gm-Message-State: AOAM531HDt2bthiBLTXJ0YJZBl0LVGJxqzCCESlXc0TuYzCCQGzVeBu+
        8RKJVmDk3xiiJgfbOVXOrZg=
X-Google-Smtp-Source: ABdhPJyk7AGNpSF45CXEmzs/VshVKOvg05kEOPjmByZq9Mx2Y61a5FCLaQJYvM/f6xJEMTLBS7qyZg==
X-Received: by 2002:a63:745e:: with SMTP id e30mr5467956pgn.153.1618524518197;
        Thu, 15 Apr 2021 15:08:38 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:f031:1d3a:7e95:2876])
        by smtp.gmail.com with ESMTPSA id w4sm3311155pjk.55.2021.04.15.15.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 15:08:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v2 02/20] Remove an incorrect comment
Date:   Thu, 15 Apr 2021 15:08:08 -0700
Message-Id: <20210415220826.29438-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_device.sdev_target is used in more code than the single_lun code,
hence remove the comment next to the definition of the sdev_target member.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_device.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 05c7c320ef32..ac6ab16abee7 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -146,7 +146,7 @@ struct scsi_device {
 	struct scsi_vpd __rcu *vpd_pg80;
 	struct scsi_vpd __rcu *vpd_pg89;
 	unsigned char current_tag;	/* current tag */
-	struct scsi_target      *sdev_target;   /* used only for single_lun */
+	struct scsi_target      *sdev_target;
 
 	blist_flags_t		sdev_bflags; /* black/white flags as also found in
 				 * scsi_devinfo.[hc]. For now used only to
