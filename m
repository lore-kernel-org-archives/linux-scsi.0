From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] scsi: fix scsi_device_lookup_by_target() documentation
Date: Mon, 27 Apr 2009 20:54:16 +0200
Message-ID: <200904272054.16632.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:41820 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120AbZD0SuU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2009 14:50:20 -0400
Received: by bwz7 with SMTP id 7so91662bwz.37
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2009 11:50:18 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/scsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/scsi/scsi.c
===================================================================
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1225,8 +1225,8 @@ EXPORT_SYMBOL(__scsi_device_lookup_by_ta
  * @starget:	SCSI target pointer
  * @lun:	SCSI Logical Unit Number
  *
- * Description: Looks up the scsi_device with the specified @channel, @id, @lun
- * for a given host.  The returned scsi_device has an additional reference that
+ * Description: Looks up the scsi_device with the specified @lun for a given
+ * @starget.  The returned scsi_device has an additional reference that
  * needs to be released with scsi_device_put once you're done with it.
  **/
 struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
