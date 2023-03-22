Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E03BC6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjCVUBv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbjCVUAk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:00:40 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8756B5E5
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:42 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id q102so5013278pjq.3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e/SkWJ5bkmeoEZFVjcXc32u2QqElt2tTbm6F8itpK0I=;
        b=ZbwyHTnA7M0gbm6UJ/p9tJw1VRXWcAOstNNBwOG2CvE8/Q0gPHQ6OQ0SrOgHfB6lIG
         CD4v4cz/xT0nRe3jHlyf9UTtlYxCNxId7rrDEFEaW82K61+94SX8kULfkIJ+Q7jzjc2p
         xF0xD/Zcnp5W/pp8S0H5/FvSYi42rm+b8I4mqyP44L+DdhaWM1GkuzkSrsLCzZqd7ImN
         7CXWnhbVZws6nNf3ir+eNwZC8gjbU1e5+a0wsrsYtmR53YJVDSMP+5xHxYEn12XX+YZQ
         U12KT8f2SgqHZnlsIessyWI2udcMRsKp6YEvGtTS71Axz0+ymaaCPJ9ZxuBgNHFXw6sx
         /SXg==
X-Gm-Message-State: AO0yUKX8Tgf1R+JptOE+sep9nFJbWM4s2EllDlvdOm1V/0Qdqbn+n8wj
        LbV8ZpwokPH7wVFKIf06hSg=
X-Google-Smtp-Source: AK7set9kKHO8d87W20FX5Ir1I71BZHE5neykEho6xUR5nNIMmzUyOVn1XmNs0WRSyYydSBq6HRjtKA==
X-Received: by 2002:a17:90b:3807:b0:23a:6be8:9446 with SMTP id mq7-20020a17090b380700b0023a6be89446mr4635029pjb.48.1679515114592;
        Wed, 22 Mar 2023 12:58:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 62/80] scsi: pcmcia-pm8001: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:57 -0700
Message-Id: <20230322195515.1267197-63-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/pm8001/pm8001_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 7e589fe3e010..8b9490011e36 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -96,7 +96,7 @@ static void pm8001_map_queues(struct Scsi_Host *shost)
 /*
  * The main structure which LLDD must register for scsi core.
  */
-static struct scsi_host_template pm8001_sht = {
+static const struct scsi_host_template pm8001_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.proc_name		= DRV_NAME,
