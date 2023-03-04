Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CB0EC61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjCDAe0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjCDAd5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:33:57 -0500
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48112CDD6
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:33:37 -0800 (PST)
Received: by mail-pj1-f41.google.com with SMTP id ce8-20020a17090aff0800b0023a61cff2c6so3353577pjb.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:33:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+lC38EPsxUPXcaJi0REX2ZgvsOSb63hqUe/I9A1Tq4M=;
        b=WNNnzad2MS4Fa7CxkHHxk9l5wUy+aQWDIa6h5wVlCcbVUj3q0G1H4ZxLaLEbYZeNHJ
         MpPXiApssUuo3K5ZpeeH1dNg+Zudwq0NI+gpxSrCSJ5iKgSYhvMW8lgQAWH2xyTTRo/X
         r6aJ6Co69pv9ad3v4j8LDAgAoCPisyyTKJJzevYbtoZ7lhzkHNBpiXMpXnnhmlqV44Fq
         VZTP7SxbuR4dMpfv4SnYfMTIKaz2pEv9eZil6v6Z/e+k6KXlbMq80iLvvDh8l+l2Rpoe
         Z+cNkImACwkMorr4TV5pS+00nr6ROeZqwQMhzbcV93i+Wl3Vi6493BuwRZfj7PVs4gB6
         Hijg==
X-Gm-Message-State: AO0yUKUx+saB+aN16+qghzm1ohY2WqBt8bMYRjUfZHp1GeFAGJhLLdJH
        jiftKZ6pRNWTlZS9mcIDw4w=
X-Google-Smtp-Source: AK7set+CaMbMxO7yrXzlnDe07DLGcDVUbU5Mdb/jUhtJU+meDJ8yFecEG9TQlEcHTeeIr+K+D2559g==
X-Received: by 2002:a17:903:120b:b0:19c:bcb7:a3f4 with SMTP id l11-20020a170903120b00b0019cbcb7a3f4mr4418942plh.54.1677890000867;
        Fri, 03 Mar 2023 16:33:20 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:20 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 47/81] scsi: ipr: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:29 -0800
Message-Id: <20230304003103.2572793-48-bvanassche@acm.org>
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
