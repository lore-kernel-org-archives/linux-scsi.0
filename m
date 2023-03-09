Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D15C742A7
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjCITbx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjCITbS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:31:18 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEB9FCF80
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:30:12 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id x11so3088383pln.12
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:30:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390212;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xeu7xruEVKfGMyukiTiO0Ah5kOsdbVW08mhQJ5MQnkM=;
        b=nEiahIaR/EBdxbnvUELRl+m5pCzGXzRYgNIU6quNCjxw4/uGYglVU32c9RbU+fnnZe
         kL74ghhuSgWPv7LO3QhprjLfBxCme3nfG1CFmZ+RDSLP58nxPXT4rCuhbIUGrXB0HaRZ
         l/ZbdOEvpfMAo8urbc/vlPUYNE+NDJjMabq/Lvyop7Q1vH9EEgrdAgGgaCJ4CzBu8ObY
         jCpM5lcyFBKMKkhRN5MivcRLHiRPZMxIY7A2+a86FDBP11XzDaqIHAr2GKMY2L6oK9LG
         TFXt+FUi7GHap/eonhLqius5g1g3EcyPYrwReUc2BeWvmt/vq2Po8V+fEuBW1PmNyJx7
         k0hw==
X-Gm-Message-State: AO0yUKUrSy+cnOke1pG3BsAb6ah/ZB429C9JrFGYvtVoHiFDnnjiBOiu
        YbYTlDxQcbmmHcR7i5pzueM=
X-Google-Smtp-Source: AK7set8jql69+aMZetT8NxUAv6lbUKOThrX2T3jH6iNJn/mhQ0HmPYexm+5fQN5L1mF32I90L25CAA==
X-Received: by 2002:a05:6a21:3385:b0:cd:238f:4f4b with SMTP id yy5-20020a056a21338500b000cd238f4f4bmr24174351pzb.23.1678390212221;
        Thu, 09 Mar 2023 11:30:12 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:30:11 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 77/82] scsi: xen-scsifront: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:26:09 -0800
Message-Id: <20230309192614.2240602-78-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/xen-scsifront.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 71a3bb83984c..caae61aa2afe 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -770,7 +770,7 @@ static void scsifront_sdev_destroy(struct scsi_device *sdev)
 	}
 }
 
-static struct scsi_host_template scsifront_sht = {
+static const struct scsi_host_template scsifront_sht = {
 	.module			= THIS_MODULE,
 	.name			= "Xen SCSI frontend driver",
 	.queuecommand		= scsifront_queuecommand,
