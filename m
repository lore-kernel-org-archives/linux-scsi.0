Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD68C6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjCVT4i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjCVT4g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:56:36 -0400
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6A55C9C0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:25 -0700 (PDT)
Received: by mail-pl1-f171.google.com with SMTP id o2so12883991plg.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679514985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QxASyLi8nqGzT795DVp8Cos4Ht8OMveiQULpG2J4on4=;
        b=7sUAU+39w+y1Fes1wgbE4w8T4QRvJdKoyaSmvVexmDVgElS6WvXCOeXXxL7xGj1JR5
         p+m0oNtcbgJ9Yj33rAKoBuOnqAP8Wj+enauNPEFMs+FTrjWRW+bACkLLAF6uGsVzru2Z
         IgmP3cxM+tsO/FG0YBvBe9ZW0VjEPXSdTW5kABcOmn6xAo/fjQ56VGtJQzAvkZF8DOu7
         4GjW0ay1rKktqmM0uRjNJVYZHezl3fqUwNvmQ9npq69Wy0Xh2oIfYhKcDv8ZiDg3smmj
         S5fwF8E4XcTPAiVFMxzSgsXrVax5ELurJCqRyZRBEfk90esbNFhUnkm+CWn5nl5RhMCq
         M9hg==
X-Gm-Message-State: AO0yUKX7nkyYE74IxTinfvODGtjGMg8q4R1Cz7XOfi7Qdisliu4sFxFJ
        2IzW/2O7MCZSzE3JcVNgg6DSXaFUJMo=
X-Google-Smtp-Source: AK7set87ckmioDSz/Ris/Aa4e2gAgyWXqXptIF7rkejsZ+L9QW3u88ZChE8b3b3WsLkdmYg78Lyi9A==
X-Received: by 2002:a17:90b:3511:b0:23b:4388:7d8a with SMTP id ls17-20020a17090b351100b0023b43887d8amr4637936pjb.21.1679514984739;
        Wed, 22 Mar 2023 12:56:24 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:56:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH v3 05/80] firewire: sbp2: Declare the SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:00 -0700
Message-Id: <20230322195515.1267197-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the sbp2 host template it not modified.

Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/firewire/sbp2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 60051c0cabea..26db5b8dfc1e 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1117,7 +1117,7 @@ static void sbp2_init_workarounds(struct sbp2_target *tgt, u32 model,
 	tgt->workarounds = w;
 }
 
-static struct scsi_host_template scsi_driver_template;
+static const struct scsi_host_template scsi_driver_template;
 static void sbp2_remove(struct fw_unit *unit);
 
 static int sbp2_probe(struct fw_unit *unit, const struct ieee1394_device_id *id)
@@ -1586,7 +1586,7 @@ static struct attribute *sbp2_scsi_sysfs_attrs[] = {
 
 ATTRIBUTE_GROUPS(sbp2_scsi_sysfs);
 
-static struct scsi_host_template scsi_driver_template = {
+static const struct scsi_host_template scsi_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "SBP-2 IEEE-1394",
 	.proc_name		= "sbp2",
