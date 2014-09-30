From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/23] Remove scsi_cmd_print_sense_hdr()
Date: Tue, 30 Sep 2014 13:50:30 +0200
Message-ID: <1412077852-40893-2-git-send-email-hare@suse.de>
References: <1412077852-40893-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbaI3LvC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2014 07:51:02 -0400
In-Reply-To: <1412077852-40893-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Unused.

Reviewed-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 14 --------------
 include/scsi/scsi_dbg.h  |  2 --
 2 files changed, 16 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index d35a5d6..2f44707 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1428,20 +1428,6 @@ scsi_print_sense_hdr(const char *name, struct scsi_sense_hdr *sshdr)
 }
 EXPORT_SYMBOL(scsi_print_sense_hdr);
 
-/*
- * Print normalized SCSI sense header with device information and a prefix.
- */
-void
-scsi_cmd_print_sense_hdr(struct scsi_cmnd *scmd, const char *desc,
-			  struct scsi_sense_hdr *sshdr)
-{
-	scmd_printk(KERN_INFO, scmd, "%s: ", desc);
-	scsi_show_sense_hdr(sshdr);
-	scmd_printk(KERN_INFO, scmd, "%s: ", desc);
-	scsi_show_extd_sense(sshdr->asc, sshdr->ascq);
-}
-EXPORT_SYMBOL(scsi_cmd_print_sense_hdr);
-
 static void
 scsi_decode_sense_buffer(const unsigned char *sense_buffer, int sense_len,
 		       struct scsi_sense_hdr *sshdr)
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index e89844c..5a43a4c 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -9,8 +9,6 @@ extern void __scsi_print_command(unsigned char *);
 extern void scsi_show_extd_sense(unsigned char, unsigned char);
 extern void scsi_show_sense_hdr(struct scsi_sense_hdr *);
 extern void scsi_print_sense_hdr(const char *, struct scsi_sense_hdr *);
-extern void scsi_cmd_print_sense_hdr(struct scsi_cmnd *, const char *,
-				     struct scsi_sense_hdr *);
 extern void scsi_print_sense(char *, struct scsi_cmnd *);
 extern void __scsi_print_sense(const char *name,
 			       const unsigned char *sense_buffer,
-- 
1.8.5.2

