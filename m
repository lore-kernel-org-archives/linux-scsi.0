Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E72CEC64EC4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjCDAft (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjCDAfG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:35:06 -0500
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1C16A9F6
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:28 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id i5so4560283pla.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KrCJy7oKZ0NcxdBtk/yFFeEQwBZTbtLM0nNDWv0I1ic=;
        b=DYCeUAbEXRUAIUx36Bh7VzbNmk2wA/W8/W5Qx5JpJuMfTByiuQKNkVH6u7k0EUGMF1
         51nHMWrhc+9Df173ZMsdlvsrE2Nd6zf//tRM2est1AEmzoVbbSg2YMcMTZuw+bHpQ92V
         Vhud9V05Q9hpRv7uwA7O2np4M5AHsqEMvwaQB6e0WBGcy4wEJ7AnkSx0u3u7ATBOAThC
         KnARsCYEfyCcqt7TC25RLaRR4pUZb06g4hXsIYYCfpV+Jr/O/rGlTwog4mL4QcjaW5zL
         drEbagISFsvSRhTqQKa9hlwSyWX3ykAmdR/xyvYMg4tbk2CLeF8Lh1+oY8qXvNP2w+Ll
         SBmg==
X-Gm-Message-State: AO0yUKXY7RVtaZqrwEnWfKdhxDhcopfiTFIh5kzHjqsaifzNh/DrhYIi
        xhVEUFDqhXzK9sCyi48bNdI=
X-Google-Smtp-Source: AK7set/7MCSSAtv44MlIg6ZWKFXZhhAw9tGDhaCV3XYtbdnsfRjcn9yhOcXcUndT4zHRYwwI0/Chbg==
X-Received: by 2002:a17:903:2349:b0:19b:fed:2258 with SMTP id c9-20020a170903234900b0019b0fed2258mr4478699plh.41.1677890067710;
        Fri, 03 Mar 2023 16:34:27 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:27 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 70/81] scsi: smartpqi: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:52 -0800
Message-Id: <20230304003103.2572793-71-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 49a8f91810b6..03de97cd72c2 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7403,7 +7403,7 @@ static struct attribute *pqi_sdev_attrs[] = {
 
 ATTRIBUTE_GROUPS(pqi_sdev);
 
-static struct scsi_host_template pqi_driver_template = {
+static const struct scsi_host_template pqi_driver_template = {
 	.module = THIS_MODULE,
 	.name = DRIVER_NAME_SHORT,
 	.proc_name = DRIVER_NAME_SHORT,
