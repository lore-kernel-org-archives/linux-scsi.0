Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BFFC61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjCDAg1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjCDAfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:35:47 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273A06A418
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:35:11 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id a2so4553400plm.4
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:35:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k2cEHBWKpaDNnl7kiLeRhj3eA3aejaS3idOl8i+KeYg=;
        b=jkXi6JT6ebp/n934eU+bVnz4DOeGG6UX4SDu874FVF3Z89nCrt5XA5LoZKhsT0hzhP
         Hvjcb+E2qshkylHprzHaR+LcvR0LHLgKB8JBOuXqiBToTXc9eSBjFJ3DlwpNBpwOcLVV
         gwF9fuuwV3hid6TkHNDsHVQxKCEelADpIdBKH2+ro4DKUwuUpOTAYHb1IlQwKdWZvYGK
         /q/Ebg/4VC8qNjCNmbUdj2muUt78HYZTpBvoJx6m78ly1BtvGxSH++iWY7spWnDXg+ro
         HVVZ6WWE7Tf6RLpYKSdM+I0A+9X5Z4EnajR0eXltnPug91xiw+/yfiV9LfOzoFqE5GwM
         54Fw==
X-Gm-Message-State: AO0yUKUj3qpcHWhX3zcYREGVfJZRseFPqBqeE/hJnpjQevGmL0bmpgk9
        GKy5ArSMIwZ8YxVEKyc6WcSvPzN5pc1G3g==
X-Google-Smtp-Source: AK7set/6aO3HTwQ7zuTZCELZA91LEUTAXPfIuPiev+Xyph9xTqq7b0LHNhlxJNfeP7B/BVPgng5yJg==
X-Received: by 2002:a17:903:22c5:b0:198:fded:3b69 with SMTP id y5-20020a17090322c500b00198fded3b69mr4543000plg.53.1677890110607;
        Fri, 03 Mar 2023 16:35:10 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:35:09 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 81/81] scsi: core: Update a source code comment
Date:   Fri,  3 Mar 2023 16:31:03 -0800
Message-Id: <20230304003103.2572793-82-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make sure that the 'proc_name' comment correctly reflects its new role.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0f29799efa02..f3e071fd61bd 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -365,7 +365,7 @@ struct scsi_host_template {
 
 
 	/*
-	 * Name of proc directory
+	 * Name reported via the proc_name SCSI host attribute.
 	 */
 	const char *proc_name;
 
