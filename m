Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 362FCC4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1F2B23403
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgLGMty (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 07:49:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:43222 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbgLGMty (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 07:49:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A6DD5AD2D;
        Mon,  7 Dec 2020 12:48:31 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/35] dc395: drop private SAM status code definitions
Date:   Mon,  7 Dec 2020 13:47:56 +0100
Message-Id: <20201207124819.95822-13-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201207124819.95822-1-hare@suse.de>
References: <20201207124819.95822-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We don't need to duplicate definitions from the common include
files.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/dc395x.h | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/scsi/dc395x.h b/drivers/scsi/dc395x.h
index 5379a936141a..a7786a6d462e 100644
--- a/drivers/scsi/dc395x.h
+++ b/drivers/scsi/dc395x.h
@@ -156,15 +156,6 @@
 #define H_ABORT				0x0FF
 
 /* SCSI BUS Status byte codes */
-#define SCSI_STAT_GOOD			0x0	/* Good status				*/
-#define SCSI_STAT_CHECKCOND		0x02	/* SCSI Check Condition			*/
-#define SCSI_STAT_CONDMET		0x04	/* Condition Met			*/
-#define SCSI_STAT_BUSY			0x08	/* Target busy status			*/
-#define SCSI_STAT_INTER			0x10	/* Intermediate status			*/
-#define SCSI_STAT_INTERCONDMET		0x14	/* Intermediate condition met		*/
-#define SCSI_STAT_RESCONFLICT		0x18	/* Reservation conflict			*/
-#define SCSI_STAT_CMDTERM		0x22	/* Command Terminated			*/
-#define SCSI_STAT_QUEUEFULL		0x28	/* Queue Full				*/
 #define SCSI_STAT_UNEXP_BUS_F		0xFD	/* Unexpect Bus Free			*/
 #define SCSI_STAT_BUS_RST_DETECT	0xFE	/* Scsi Bus Reset detected		*/
 #define SCSI_STAT_SEL_TIMEOUT		0xFF	/* Selection Time out			*/
@@ -203,13 +194,6 @@
 #define MSG_IDENTIFY			0x80
 #define MSG_HOST_ID			0xC0
 
-/* SCSI STATUS BYTE */
-#define STATUS_GOOD			0x00
-#define CHECK_CONDITION_		0x02
-#define STATUS_BUSY			0x08
-#define STATUS_INTERMEDIATE		0x10
-#define RESERVE_CONFLICT		0x18
-
 /* cmd->result */
 #define STATUS_MASK_			0xFF
 #define MSG_MASK			0xFF00
-- 
2.16.4

