Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A55FC76196
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjCVT7K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjCVT6B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:58:01 -0400
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F5A65C57
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:44 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so24656679pjt.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:57:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=px+VcymeEwEDAGjtrWl3/YMfcdfrocZHJayOmxP7gJo=;
        b=X0kPIGqnMkJqItTJgAhkWPjONBcf5JfejhyQToC3LT7fU8/hzSon4u/16+Y3JE0qmk
         OGdfGjXgZ9Qfz+3h5e79eQadRZoJKaLAAp6Bkts3B+T2e5MPObfY8wVpMFuKAvnzh/lB
         I8zn2DbQkCATTlMGSWyDYuWENaR11p+Xa0Um2ULhbvyDBMP2aeJPcYwxzETqckyi9XVZ
         FE2J22sNVKh9Y7LP+LOZ7B5u2XUy/PBHWn9Fh9y0rny4oFC8kC/lvK0WywvqrxRKNgQ/
         qzEFePbE/10KNfcNEl1x9pMm1SdOdfHl96Y4wPfeQ8E8JoPH8TnBFX3EdVPmE+SMo5ZL
         DWHA==
X-Gm-Message-State: AO0yUKU2QLC2r+J90XtNnWTMdUvcyHxw5jQKu7kFNqADBYLdycQFJlF0
        gzpiT/3iYmXin6CAZmFMbRM=
X-Google-Smtp-Source: AK7set+Sj/NvGIQFC7aRCVatgWs/F9lisZVxikP7YdyYAT1eu+R19bWgDNNr+2xB33GK2FXoF3H6Vg==
X-Received: by 2002:a17:90b:3b45:b0:237:97a3:1479 with SMTP id ot5-20020a17090b3b4500b0023797a31479mr5322176pjb.28.1679515063892;
        Wed, 22 Mar 2023 12:57:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:57:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Brian King <brking@linux.vnet.ibm.com>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 47/80] scsi: ipr: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:42 -0700
Message-Id: <20230322195515.1267197-48-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Acked-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ipr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index c74053f0b72f..4d3c280a7360 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6736,7 +6736,7 @@ static const char *ipr_ioa_info(struct Scsi_Host *host)
 	return buffer;
 }
 
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module = THIS_MODULE,
 	.name = "IPR",
 	.info = ipr_ioa_info,
