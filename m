From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] scsi_error: fix scsi_eh_restore_cmnd() documentation
Date: Mon, 27 Apr 2009 20:54:22 +0200
Message-ID: <200904272054.22929.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:38831 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247AbZD0SuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2009 14:50:21 -0400
Received: by fxm2 with SMTP id 2so92461fxm.37
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 11:50:19 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/scsi_error.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/scsi/scsi_error.c
===================================================================
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -641,9 +641,9 @@ EXPORT_SYMBOL(scsi_eh_prep_cmnd);
 /**
  * scsi_eh_restore_cmnd  - Restore a scsi command info as part of error recory
  * @scmd:       SCSI command structure to restore
- * @ses:        saved information from a coresponding call to scsi_prep_eh_cmnd
+ * @ses:        saved information from a coresponding call to scsi_eh_prep_cmnd
  *
- * Undo any damage done by above scsi_prep_eh_cmnd().
+ * Undo any damage done by above scsi_eh_prep_cmnd().
  */
 void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 {
