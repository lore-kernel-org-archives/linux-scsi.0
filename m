Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3284BC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjCIT2y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjCIT20 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:26 -0500
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446F062D9E
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:24 -0800 (PST)
Received: by mail-pg1-f176.google.com with SMTP id d8so1718559pgm.3
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4uxxN7Q5Bd2Nk0RDe6hDV+Z1h0pZWa/g2GzvVwJGpA4=;
        b=kbnsbZ/7KZmwFr1hdPXPKYy/gO31JkiqKcrFhpvQDZGT0i/kBnnkrAk6KQRbXOst3F
         jwK0RipK1hDa8Qy6+1g+klZtHoJAfSNkDxL8SDHN45dvjABnSZ1tgTZuwUWJYi1lUQ3L
         UxJgLo/lD6SwzG8BmffPUyWYHZnTq6Mm0rrzcpHkBbaNI1xPbtlkW1A/tLExLbUEAJxE
         KfuDFaZ/sVDh+VuTDpdtj+WcK27XJnVGHaPJfVHr9WjSslxB10lGrT38qDHSI5S4Fjei
         qnsUXsElEltdpwUTeTc900JqxLmH9llTZ9n8JNOhF2C/GwI6P6WdofoFhy2JGzgYH1xz
         Xp1g==
X-Gm-Message-State: AO0yUKUjlgS/lZwdR68qnF9VE6DQCYxldZVkfsnAQ4+zHKSlBaKREuxv
        LnC1H05xlO5cfXNn1+SrLkA3rV2Gmess4g==
X-Google-Smtp-Source: AK7set/+wpS+GcRlw6XYkqB9FtNTcKoHLK1bw94aGsIR2MyhSucXGF358CwEnXtGS7f7XjgY5VoRBw==
X-Received: by 2002:aa7:9a0b:0:b0:5dc:e57:e0e7 with SMTP id w11-20020aa79a0b000000b005dc0e57e0e7mr17109023pfj.22.1678390104261;
        Thu, 09 Mar 2023 11:28:24 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:23 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 33/82] scsi: esas2r: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:25 -0800
Message-Id: <20230309192614.2240602-34-bvanassche@acm.org>
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
 drivers/scsi/esas2r/esas2r_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index d7a2c49ff5ee..f700a16cd885 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -231,7 +231,7 @@ struct bin_attribute bin_attr_default_nvram = {
 	.write	= NULL
 };
 
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module				= THIS_MODULE,
 	.show_info			= esas2r_show_info,
 	.name				= ESAS2R_LONGNAME,
