From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/18] scsi: remove scsi_show_sense_hdr()
Date: Tue,  1 Dec 2015 10:16:50 +0100
Message-ID: <1448961418-29013-11-git-send-email-hare@suse.de>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051AbbLAJRK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 04:17:10 -0500
In-Reply-To: <1448961418-29013-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Last caller is gone, so remove it.

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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
1.8.5.6

