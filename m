From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: remove scsi_show_sense_hdr()
Date: Mon,  6 Jul 2015 13:32:05 +0200
Message-ID: <1436182325-85246-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbbGFLcI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 07:32:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Last caller is gone, so remove it.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 include/scsi/scsi_dbg.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index f8170e9..56710e0 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -12,8 +12,6 @@ extern size_t __scsi_format_command(char *, size_t,
 				   const unsigned char *, size_t);
 extern void scsi_show_extd_sense(const struct scsi_device *, const char *,
 				 unsigned char, unsigned char);
-extern void scsi_show_sense_hdr(const struct scsi_device *, const char *,
-				const struct scsi_sense_hdr *);
 extern void scsi_print_sense_hdr(const struct scsi_device *, const char *,
 				 const struct scsi_sense_hdr *);
 extern void scsi_print_sense(const struct scsi_cmnd *);
-- 
1.8.5.2

