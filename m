From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/20] scsi: remove scsi_show_sense_hdr()
Date: Wed,  8 Jul 2015 11:06:03 +0200
Message-ID: <1436346378-96518-6-git-send-email-hare@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934251AbbGHJGa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 05:06:30 -0400
In-Reply-To: <1436346378-96518-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

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

