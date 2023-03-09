Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F0EC6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjCIT1y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjCIT1i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:27:38 -0500
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B70F146B
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:27:35 -0800 (PST)
Received: by mail-pl1-f172.google.com with SMTP id h8so3089722plf.10
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:27:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/+RYutzjDsUywQB4KXngUgj4Hi0F5p617CUW9BmtH8E=;
        b=bBafIFVn+arIt5EYT5y6LFko+7nNEUandkQg9L/BRyCf1Xevlb8vEPMX9Pbz/5GN38
         AX1TqC0YlIJ06+5BQSy5ZKrUzzUhj3KC863+CeYq/FepoPQNDoQHacc/n3mjcHSiNdW6
         uuxYmAwF5qg42EqYRs4AX6WcXUaYx05Guv1ZhAu+8Sa1K9COiDqwjklGzwUlajnaAVLV
         TA/oTA0m5V9bVBk+rVA9pMiD8BRO0WQgC4fpWSkpzuMFme1jvA9AQ0dgvw676+UBjy4o
         vsYUFEoOX278fCvifCSa979xm3FeD2ymSPa/v7Pv6EMe0MRcDIckTjSpLYs28UYS4+2H
         qNYw==
X-Gm-Message-State: AO0yUKXo9Bvn7YqFq//7amd6li3uPZ3VZ5o2khxkKPLipVHmvl/vNYO4
        dnp/n2zFfe9rRCMQjqUkP9+4+8T52ww1BQ==
X-Google-Smtp-Source: AK7set8ziL09evhu0bsq1P3J/6tv4YXolVn4UDj0x+PiFv1rl6ZyEoWIh6ZvMTn0w2ndw/5totO2Ew==
X-Received: by 2002:a05:6a20:4401:b0:ce:3311:a7b7 with SMTP id ce1-20020a056a20440100b000ce3311a7b7mr33371657pzb.9.1678390055057;
        Thu, 09 Mar 2023 11:27:35 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:27:34 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 18/82] scsi: aha152x: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:10 -0800
Message-Id: <20230309192614.2240602-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aha152x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index caeebfb67149..055adb349b0e 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -400,7 +400,7 @@ MODULE_DEVICE_TABLE(isapnp, id_table);
 
 #endif /* !AHA152X_PCMCIA */
 
-static struct scsi_host_template aha152x_driver_template;
+static const struct scsi_host_template aha152x_driver_template;
 
 /*
  * internal states of the host
@@ -2946,7 +2946,7 @@ static int aha152x_adjust_queue(struct scsi_device *device)
 	return 0;
 }
 
-static struct scsi_host_template aha152x_driver_template = {
+static const struct scsi_host_template aha152x_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= AHA152X_REVID,
 	.proc_name			= "aha152x",
