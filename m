Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F506C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjCVT47 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjCVT4n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:56:43 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D608D5BD8A
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:34 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id j3-20020a17090adc8300b0023d09aea4a6so24641567pjv.5
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679514994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wvru8kVY2I3MSun55wPTjy7EC406KfhAV63CSzUeJMc=;
        b=e32GONq6vuNiMJsfSFXmkbPkLk/m9B8KD76Nd6ViGVODLR779uqu8JiF4sCZmuHv2e
         /jyPkJWTtVyn6udko6YOIleM/63vIIqfvLLBe84lKR7PChtE5mKEedZRiyFgG2qkw2Sp
         t/7QtO3TQW8ECzn3EHDcZZASDsxghRqNjl63Gg/hvA0wKbqtoFvZX8ktD1rsUR0sWaVG
         Mb6472WdZ413OdGDGKEFiBa28wBdj0gkhDAm1AabXRNFL8iiJjHNQ3NzYXOCNJLtvwc7
         kC2W8NDkulh64e2ZU1TMF11+dF5zT0QdD37QzVdGuLW//FCARFiXDWpBt9iA7dVywlFT
         o9Qw==
X-Gm-Message-State: AO0yUKUc3HJGJh/HdgrpoTTTVjT172qmrykb8tL2ACI31EK6RPKndbmR
        3wM+J4KtE+Da2fHR/RiCGO0=
X-Google-Smtp-Source: AK7set8HIpdM4JgLBZOjoV3ptUVa++sxeD7qvtY5ZIsAk7xwgz69W0KSsXMfdcjWU2JWAe/vSiloNQ==
X-Received: by 2002:a17:90b:3eca:b0:23d:e0c1:8b8e with SMTP id rm10-20020a17090b3eca00b0023de0c18b8emr4855475pjb.17.1679514994338;
        Wed, 22 Mar 2023 12:56:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:56:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 12/80] scsi: BusLogic: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:07 -0700
Message-Id: <20230322195515.1267197-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Acked-by: Khalid Aziz <khalid@gonehiking.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/BusLogic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index f7b7ffda1161..72ceaf650b0d 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -54,7 +54,7 @@
 #define FAILURE (-1)
 #endif
 
-static struct scsi_host_template blogic_template;
+static const struct scsi_host_template blogic_template;
 
 /*
   blogic_drvr_options_count is a count of the number of BusLogic Driver
@@ -3663,7 +3663,7 @@ static int __init blogic_parseopts(char *options)
   Get it all started
 */
 
-static struct scsi_host_template blogic_template = {
+static const struct scsi_host_template blogic_template = {
 	.module = THIS_MODULE,
 	.proc_name = "BusLogic",
 	.write_info = blogic_write_info,
