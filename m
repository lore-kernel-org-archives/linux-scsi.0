Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 508A4C77B7C
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 23:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236475AbjDYXgM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 19:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236473AbjDYXgH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 19:36:07 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF124C17A
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:36:05 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-63b733fd00bso5172560b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:36:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682465765; x=1685057765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0BLcDBB76INQrERMmuujqXhkyY7InYZFQK9oYODTYwQ=;
        b=eKa/gdeff5DwN7cuYTVBpykwbAWoMtP8VdTcOMQWGD2now7ZoJJQN2HBVizO0MR4fd
         klt410UHFhMIJE/P8IEu8dddQhhcKTfZXiSgIKv6qcxLWc/5Ousz/m0VtizkGTeVPN+y
         xXzUnJ44LpF7m/T0ENd6Igr43t2cG7dg1f2co4vkKTip1tIttzKp4iZE/F+h6QjjFTOX
         KC0fG8dHxhkMzSi+kQuwVI6T2l1Ys5VxLCLEdaeeA/YUyy0pYPDeIxN6lCSFARrdAcWl
         qusPReMFzPZi+W6z1Czz4D/ZRpLcV5SIEO5MP9T8y9jNBr6ksY3oRpihWvqxegXzaiev
         nKVA==
X-Gm-Message-State: AAQBX9f24NO/iqw09jiwAF3JogqPux6PxUINFeGcmnnRTD5lr8KQxw6L
        ElseP78l1xhWN96EtCp+Sas=
X-Google-Smtp-Source: AKy350Z5bQCyNuwup3ygakYGY9XsgzbuGs7P+Eyh6KwVpWSK2pyHb0UOx1r4stQzEQSptjNYCalcuA==
X-Received: by 2002:a05:6a20:160e:b0:ef:a696:9940 with SMTP id l14-20020a056a20160e00b000efa6969940mr24451044pzj.15.1682465765426;
        Tue, 25 Apr 2023 16:36:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5099:ad7c:6c1:9570])
        by smtp.gmail.com with ESMTPSA id j12-20020a056a00174c00b00634b91326a9sm10146984pfc.143.2023.04.25.16.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 16:36:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 2/4] scsi: core: Update a source code comment
Date:   Tue, 25 Apr 2023 16:34:44 -0700
Message-ID: <20230425233446.1231000-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
In-Reply-To: <20230425233446.1231000-1-bvanassche@acm.org>
References: <20230425233446.1231000-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make sure that the 'proc_name' comment correctly reflects its new role.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
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
 
