From: akpm@linux-foundation.org
Subject: [patch 17/17] scsi: removed one unneeded shost->active_mode assignment
Date: Fri, 28 Mar 2008 14:48:45 -0700
Message-ID: <200803282148.m2SLmjW4012264@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755661AbYC1V6E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 17:58:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, crquan@gmail.com

From: Denis Cheng <crquan@gmail.com>

In the following if/else statement, shost->active_mode will always be set, so
this assignment is unneeded.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hosts.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/scsi/hosts.c~scsi-removed-one-unneeded-shost-active_mode-assignment drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c~scsi-removed-one-unneeded-shost-active_mode-assignment
+++ a/drivers/scsi/hosts.c
@@ -341,7 +341,6 @@ struct Scsi_Host *scsi_host_alloc(struct
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
-	shost->active_mode = sht->supported_mode;
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
_
