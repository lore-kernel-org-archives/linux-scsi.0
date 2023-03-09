Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04857C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjCIT2m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjCIT2P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:28:15 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B4B2B9DA
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:28:13 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id v11so3093752plz.8
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:28:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JFvxo/sJNe3B0K/5I7wr+cSfqXHj+OqtPwyJqG3lYLo=;
        b=mA4bsxW6VloVePCSArcQz6teSTdBLCZGPEzfw6PFiIpSalp5NqyYI8+KR2Prge/WrK
         hfFdaeq7UO1VFp1Afb6Oxi2Q/a58//3h4a0X5FjcNC1rY5wP/gOyl8jXtw3yVoCmAjg9
         IjnYSyjZ8fxuuwLzh+JmYNJuDNrxxMo3PxjptCWUw1bmSFfpLmk8FVdY2Ko4sSCM3KN/
         Sej4vtpKqntjRdUne3CorZRh54kYjlfjekNqzd4gmG6TLdPnQ3OuK0QFofSwD7dNRVKO
         j/4NP9oGRC4CTugHfLyT8udVUDZwFt3Gg6W6UNeSS0qlzdFbXunpka4HSDHONQ8wd4Qb
         aD2w==
X-Gm-Message-State: AO0yUKUqLoLZYLKPZViWxAgbeJQANIiMc6tLn13u7RG3f4prCFG5XdYM
        Yuz504mzzsr1B0pvKG8WXwA=
X-Google-Smtp-Source: AK7set9fVSJoDYha8UliHYU0/5iRbLxwxU+UeA2sVCi33TTPUyv/GRksKErjwOMnxaisuHOb7QNpJw==
X-Received: by 2002:a05:6a20:12ce:b0:cc:b73a:1079 with SMTP id v14-20020a056a2012ce00b000ccb73a1079mr25836328pzg.62.1678390093052;
        Thu, 09 Mar 2023 11:28:13 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:28:12 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 31/82] scsi: dmx3191d: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:25:23 -0800
Message-Id: <20230309192614.2240602-32-bvanassche@acm.org>
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
 drivers/scsi/dmx3191d.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index a171ce6b70b2..dfb091d34363 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -39,7 +39,7 @@
 #define DMX3191D_REGION_LEN	8
 
 
-static struct scsi_host_template dmx3191d_driver_template = {
+static const struct scsi_host_template dmx3191d_driver_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= DMX3191D_DRIVER_NAME,
 	.name			= "Domex DMX3191D",
