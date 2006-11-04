From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] SCSI: Make the max_sectors type be the same as that in request_queue
Date: Sat, 4 Nov 2006 11:59:44 -0800 (PST)
Message-ID: <670619.10812.qm@web31809.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:38029 "HELO
	web31809.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S965354AbWKDT7p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Nov 2006 14:59:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 include/scsi/scsi_host.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

This patch is 8 months old.

    Luben

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 8279929..17ee065 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -338,7 +338,7 @@ struct scsi_host_template {
 	/*
 	 * If the host adapter has limitations beside segment count
 	 */
-	unsigned short max_sectors;
+	unsigned int max_sectors;
 
 	/*
 	 * dma scatter gather segment boundary limit. a segment crossing this
@@ -526,7 +526,7 @@ struct Scsi_Host {
 	int can_queue;
 	short cmd_per_lun;
 	short unsigned int sg_tablesize;
-	short unsigned int max_sectors;
+	unsigned int  max_sectors;
 	unsigned long dma_boundary;
 	/* 
 	 * Used to assign serial numbers to the cmds.
-- 
1.4.3.3.g8478


