Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F942C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C5D1613B6
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347080AbhDMRHp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:07:45 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:36541 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347072AbhDMRHn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:07:43 -0400
Received: by mail-pj1-f42.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so11031438pjh.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cGnCPOgIA7Gkds8X6fZBW7kNO67PcbciQBssYoARmjw=;
        b=Ts9na5wb+6MmmRvkyfl+sDtUkoVr6mITPtRA1P1E0ytkwJ0TjDk8eRNaoBDaR+fzpR
         R08LDc/EGuwCs5Zzg3+Wkpn7WHDzS7bqlyX9qeH/15A88yfzDW2MD+TTzKZPKuS5kltR
         B25IDNMnBHBmJXq2X7wyj69QQfvsUSem1CGsRx2MLI3LTKrUZpgvqol3kPwdNWIDA+vj
         URPALxGtk0+xRX6ewYBn+iSFaDmfF78u7cShz5C4B2c19G+Lh01xMRS34+HlmnU1zyVq
         +hjVBqcLmzhmozRvIJV5aT3muafk0d2mJjGCdQZA5aKGY0kzoGA/jhdhk8JjDJqpyjQt
         MyQg==
X-Gm-Message-State: AOAM531U11/PAqgTmPxkRil1gFI0wspG2eXdNqAGlxPAUYT7bxHKfjVJ
        CbCRrt1B77vDkqvY2rBwFFw=
X-Google-Smtp-Source: ABdhPJyPAr2JNVZpgLjkPo9m+ojHKh0g4zPS2nDSoDZlHjvLTqMCoOgPgSDlfIupLSt9O7FRZU7GcA==
X-Received: by 2002:a17:90b:3b4a:: with SMTP id ot10mr1054696pjb.48.1618333643248;
        Tue, 13 Apr 2021 10:07:23 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 02/20] Remove an incorrect comment
Date:   Tue, 13 Apr 2021 10:06:56 -0700
Message-Id: <20210413170714.2119-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
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
