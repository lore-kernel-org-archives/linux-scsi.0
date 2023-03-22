Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10C27C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjCVT6a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbjCVT5r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:57:47 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549386A1DB
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:26 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id mp3-20020a17090b190300b0023fcc8ce113so9684443pjb.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4uxxN7Q5Bd2Nk0RDe6hDV+Z1h0pZWa/g2GzvVwJGpA4=;
        b=DkCOg/Y6SOuUoT1nvOtoVOZrfU3rUR/VfwoGQ03bFKGIT1KG5IEXL6wGOpYFyox0R1
         RJHYgOLzymBnlZMBqLAaHbLltISrR3k3rHmVrodnM0AGjzxsokja9BOqvURwzI4b2oTQ
         JOlh91Z6I1P2BB8wrX7PR3WC4O+8Wj/mE35c6oimP+pdqRCgtNDfkbRRs8UUze/ICs7j
         +c6FcHPfl3IjJ2Q5lkue+y1KjnVlPVq02KSyqAZzPDV3LmVr6Zk3a+5QcgsfMCP0kPzd
         tUwywVTpkfqFQgAQW4GzZqWcClsWMHzqGMbCtVYef/diBDUfQPfApbXqOMU+pwnDzqQy
         b0bw==
X-Gm-Message-State: AO0yUKVdSxpe5IS8SeC59PiTYPh7KqeRHDpk93xmzTI2zrFHjEqyztpH
        EXZ6SusylPOA03tocT+gtV0=
X-Google-Smtp-Source: AK7set+L7P3MvF6GkghEvusunSnHN5nTXiyNJ1S2TBdUpRpu9mItP0l2Ez4FGIDyuMrflHWcmcnxaw==
X-Received: by 2002:a17:90b:3846:b0:236:6a28:f781 with SMTP id nl6-20020a17090b384600b002366a28f781mr4971397pjb.22.1679515045775;
        Wed, 22 Mar 2023 12:57:25 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 33/80] scsi: esas2r: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:28 -0700
Message-Id: <20230322195515.1267197-34-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
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
