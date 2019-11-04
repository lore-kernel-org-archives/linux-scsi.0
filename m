Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF62CA9ED4
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D6072190F
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbfKDJCa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:02:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:57300 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728276AbfKDJCR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 04:02:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 08908B4B1;
        Mon,  4 Nov 2019 09:02:11 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 41/52] scsi: Kill DRIVER_HARD
Date:   Mon,  4 Nov 2019 10:01:40 +0100
Message-Id: <20191104090151.129140-42-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191104090151.129140-1-hare@suse.de>
References: <20191104090151.129140-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Unused.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c    | 2 +-
 include/scsi/scsi.h         | 1 -
 include/trace/events/scsi.h | 3 +--
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 7809bf618606..b2ba83e6b98d 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -408,7 +408,7 @@ static const char * const hostbyte_table[]={
 
 static const char * const driverbyte_table[]={
 "DRIVER_OK", "DRIVER_BUSY", "DRIVER_SOFT",  "DRIVER_MEDIA", "DRIVER_ERROR",
-"DRIVER_INVALID", "DRIVER_TIMEOUT", "DRIVER_HARD"};
+"DRIVER_INVALID", "DRIVER_TIMEOUT"};
 
 const char *scsi_hostbyte_string(int result)
 {
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index f68c234dd3e8..407e188a0aae 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -172,7 +172,6 @@ static inline int scsi_is_wlun(u64 lun)
 
 #define DRIVER_INVALID      0x05
 #define DRIVER_TIMEOUT      0x06
-#define DRIVER_HARD         0x07
 
 /*
  * Internal return values.
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 404fbc54bc32..e15373917d1e 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -133,8 +133,7 @@
 		scsi_driverbyte_name(DRIVER_MEDIA),		\
 		scsi_driverbyte_name(DRIVER_ERROR),		\
 		scsi_driverbyte_name(DRIVER_INVALID),		\
-		scsi_driverbyte_name(DRIVER_TIMEOUT),		\
-		 scsi_driverbyte_name(DRIVER_HARD))
+		scsi_driverbyte_name(DRIVER_TIMEOUT))
 
 #define scsi_msgbyte_name(result)	{ result, #result }
 #define show_msgbyte_name(val)					\
-- 
2.16.4

