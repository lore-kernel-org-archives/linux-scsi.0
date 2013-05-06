From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/5] scsi: Remove 'last_reset' for struct Scsi_Host
Date: Mon,  6 May 2013 09:20:41 +0200
Message-ID: <1367824841-47767-6-git-send-email-hare@suse.de>
References: <1367824841-47767-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab3EFHUp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 May 2013 03:20:45 -0400
In-Reply-To: <1367824841-47767-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Field is now unused, so remove it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 include/scsi/scsi_host.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index af7ad0e..dcf17dc 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -596,9 +596,8 @@ struct Scsi_Host {
 	unsigned int host_busy;		   /* commands actually active on low-level */
 	unsigned int host_failed;	   /* commands that failed. */
 	unsigned int host_eh_scheduled;    /* EH scheduled without command */
-    
+
 	unsigned int host_no;  /* Used for IOCTL_GET_IDLUN, /proc/scsi et al. */
-	unsigned long last_reset;
 
 	/*
 	 * These three parameters can be used to allow for wide scsi,
-- 
1.7.12.4

