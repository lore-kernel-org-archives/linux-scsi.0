Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64FA1C61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjCDAcj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjCDAce (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:34 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D326A403
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:32:31 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id ce8-20020a17090aff0800b0023a61cff2c6so3352596pjb.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:32:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wYcUKal3ePL60VfjZpcDaHb80w6LZ6piZfKEAvYH9Uc=;
        b=V+9fUmF/RKUP2py03EfH55zg1M5gOQ6sT929QZ3obCgmqvlNS1QXrRfNHsoVUPhrA/
         gX0yb0jbOK3sVzhC2j3xCB5tpSataoBhmYrf+gHnu85s4UfJDmFKdokYLMNrz3iakyIr
         P1GyBZoYe+Ksxe7+FdfPOZAIR6msayIKDzdi+3NyN6iK4p3eHP4XBCPjTTEeRyxn95eB
         kWlSb8qX+9oispScR/gQeVWCWP5ybWkG2dNODNmlnRh9Jv+9MWqBn4fh8dVnZsvsI+Gb
         cEjrXD0bYKE3k4qjpjMINuMQsbGQ1gxnZO3BguupYHCXd3RyUtcWbH9cew+KkD7Ud/qb
         dgJw==
X-Gm-Message-State: AO0yUKXMWZt1msVKXBQc6K6IUsyDMU2jUh6qzl1ENyz1EOuBfzxsf0Jt
        6vwy0VYG2q7H6RsbtXgC0X0=
X-Google-Smtp-Source: AK7set//gHdlRcoi7QOeL5iQCnUF8hvNUJYTHYW0QXt3mfAyTSgge8xuCr3z4SwFpSf938S+CdKSsA==
X-Received: by 2002:a17:902:ce92:b0:19e:27a1:dd94 with SMTP id f18-20020a170902ce9200b0019e27a1dd94mr4515179plg.35.1677889950166;
        Fri, 03 Mar 2023 16:32:30 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:32:29 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 22/81] scsi: acornscsi: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:04 -0800
Message-Id: <20230304003103.2572793-23-bvanassche@acm.org>
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
 drivers/scsi/arm/acornscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 7602639da9b3..0b046e4b395c 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2780,7 +2780,7 @@ static int acornscsi_show_info(struct seq_file *m, struct Scsi_Host *instance)
     return 0;
 }
 
-static struct scsi_host_template acornscsi_template = {
+static const struct scsi_host_template acornscsi_template = {
 	.module			= THIS_MODULE,
 	.show_info		= acornscsi_show_info,
 	.name			= "AcornSCSI",
