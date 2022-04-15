Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A699C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Apr 2022 20:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351806AbiDOUUz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Apr 2022 16:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351672AbiDOUUl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2022 16:20:41 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B92DE0BE
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 13:18:11 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id y6so7903761plg.2
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 13:18:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5psa2uMjdf2eMxZTQwELxzFMEHOuHo0QY7msKqOHIZU=;
        b=JPMx0tqN3vVlaRsvZFgqa9Xum1zkzpnqIQPUY8xL6FsVzFwqjW1FnrrqO1iFaXS7d/
         +IRWCD3tEoVID3uWVz9RsRUB+pctJfvKt3N6zQciTj+W8ONT1UZ4LIn1TptMLcGNrfRi
         7UbPEu2NuOxpDE9BK/2MICY0ovhAop29orNiBL5Sdo+gI+7ShAhYHYaC8K0FSTI2iScV
         rru7fZSfG7yP37jYBY6h3vlsI8gA4gyFH1RNWyc8JFepaiYwv8xb61zMMQCyzKtgFF0k
         RTCR4FVvC6LwAM85h5WY4iMAquwDihP+DYMrCO7sfPqN2r6jYflDmv6uzj+4KkoHT34+
         2h9g==
X-Gm-Message-State: AOAM5336hxCm+jgu3455O7017EMoJI5cS9HvoCkjLxOlVkpQJhOiX+9k
        wE5QXKDtVj5X0Pzqvq5Rb34=
X-Google-Smtp-Source: ABdhPJyALRAXRpCUAmqJtGCAAaazAoJMl9dPUpLGRy9L0kEaZxXhdOkvHVASRIKahSPInofNNOkk7w==
X-Received: by 2002:a17:90b:4a4a:b0:1c7:82e9:1014 with SMTP id lb10-20020a17090b4a4a00b001c782e91014mr6029478pjb.0.1650053891416;
        Fri, 15 Apr 2022 13:18:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a014:c21c:c3f8:d62])
        by smtp.gmail.com with ESMTPSA id q9-20020a056a00088900b004fe1a045e97sm3641141pfj.118.2022.04.15.13.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 13:18:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 6/8] scsi_debug: Fix a typo
Date:   Fri, 15 Apr 2022 13:17:50 -0700
Message-Id: <20220415201752.2793700-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220415201752.2793700-1-bvanassche@acm.org>
References: <20220415201752.2793700-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change a single occurrence of "nad" into "and".

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
