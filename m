Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB4AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 18:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391390AbiDUSdq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 14:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391373AbiDUSdi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 14:33:38 -0400
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67604BB88
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:47 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id bg9so5333095pgb.9
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hS+x0W+keuoHTFQsjWjH8UYkZViOvD+uCeBfkMeHRfI=;
        b=d49Pa58BBxr8wt+F670KLDQ3NWzobVhsDAaTZA8Wue2wyz1Nk6dl4Pwa2jegD9UJvM
         MHrsdEJTp5jKanpoTMDgb/m+3KeWcFJXWLgxamIGwM98YkeJM1yvl4A++dKBJRh9Sux8
         nTi4hJgSO1DH9rhjRHx62ZvcqJe5h0qh2pZplNgqgySFokZjuFqjgrZLiXpUD9sgWjpK
         nw4KQ9j0iSc1u4hsDg6cCjDFtrk9GhLVRXkgfuhQZk9E/oGyJl4KBAqH385PA6OHcN3U
         HnODhK+fnnyATfJcXvO70pOU2UsOFbpg63L6YfmwilXrilVko9jCHzrisRalisUmoZpN
         08zQ==
X-Gm-Message-State: AOAM533+hvudK+E/xiXpktNL+pEP9eOK88ucJ07FrDmkTvdbEIzSyl4Z
        D+8xeVD7CduRFqKoRwI63R0=
X-Google-Smtp-Source: ABdhPJwVg+at6eKDGwueJ/ycGHslHfItCzPdXLap5PsKfeHekd7CLnd2CeYnN/LKKkdrDeIvJDFJUw==
X-Received: by 2002:a65:6956:0:b0:399:1f0e:6172 with SMTP id w22-20020a656956000000b003991f0e6172mr645044pgq.286.1650565847239;
        Thu, 21 Apr 2022 11:30:47 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a034:31d8:ca4e:1f35])
        by smtp.gmail.com with ESMTPSA id a22-20020a62d416000000b0050bd98eaccbsm2181079pfh.213.2022.04.21.11.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 11:30:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 7/9] scsi_debug: Fix a typo
Date:   Thu, 21 Apr 2022 11:30:21 -0700
Message-Id: <20220421183023.3462291-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
In-Reply-To: <20220421183023.3462291-1-bvanassche@acm.org>
References: <20220421183023.3462291-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change a single occurrence of "nad" into "and".

Cc: Douglas Gilbert <dgilbert@interlog.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c607755cce00..7cfae8206a4b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4408,7 +4408,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 #define RZONES_DESC_HD 64
 
-/* Report zones depending on start LBA nad reporting options */
+/* Report zones depending on start LBA and reporting options */
 static int resp_report_zones(struct scsi_cmnd *scp,
 			     struct sdebug_dev_info *devip)
 {
