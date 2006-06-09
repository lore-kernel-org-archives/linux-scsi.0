From: akpm@osdl.org
Subject: [patch 09/31] remove drivers/scsi/constants.c:scsi_print_req_sense()
Date: Thu, 08 Jun 2006 22:23:35 -0700
Message-ID: <200606090523.k595NZ5M032252@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:15327 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965209AbWFIF0w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 01:26:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de


From: Adrian Bunk <bunk@stusta.de>

This function is no longer used anywhere.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/constants.c |   10 ----------
 include/scsi/scsi_dbg.h  |    1 -
 2 files changed, 11 deletions(-)

diff -puN drivers/scsi/constants.c~remove-drivers-scsi-constantscscsi_print_req_sense drivers/scsi/constants.c
--- devel/drivers/scsi/constants.c~remove-drivers-scsi-constantscscsi_print_req_sense	2006-06-01 20:41:50.000000000 -0700
+++ devel-akpm/drivers/scsi/constants.c	2006-06-01 20:41:50.000000000 -0700
@@ -1268,16 +1268,6 @@ void scsi_print_sense(const char *devcla
 }
 EXPORT_SYMBOL(scsi_print_sense);
 
-void scsi_print_req_sense(const char *devclass, struct scsi_request *sreq)
-{
-	const char *name = devclass;
-
-	if (sreq->sr_request->rq_disk)
-		name = sreq->sr_request->rq_disk->disk_name;
-	__scsi_print_sense(name, sreq->sr_sense_buffer, SCSI_SENSE_BUFFERSIZE);
-}
-EXPORT_SYMBOL(scsi_print_req_sense);
-
 void scsi_print_command(struct scsi_cmnd *cmd)
 {
 	/* Assume appended output (i.e. not at start of line) */
diff -puN include/scsi/scsi_dbg.h~remove-drivers-scsi-constantscscsi_print_req_sense include/scsi/scsi_dbg.h
--- devel/include/scsi/scsi_dbg.h~remove-drivers-scsi-constantscscsi_print_req_sense	2006-06-01 20:41:50.000000000 -0700
+++ devel-akpm/include/scsi/scsi_dbg.h	2006-06-01 20:41:50.000000000 -0700
@@ -9,7 +9,6 @@ extern void scsi_print_command(struct sc
 extern void scsi_print_sense_hdr(const char *, struct scsi_sense_hdr *);
 extern void __scsi_print_command(unsigned char *);
 extern void scsi_print_sense(const char *, struct scsi_cmnd *);
-extern void scsi_print_req_sense(const char *, struct scsi_request *);
 extern void __scsi_print_sense(const char *name,
 			       const unsigned char *sense_buffer,
 			       int sense_len);
_
