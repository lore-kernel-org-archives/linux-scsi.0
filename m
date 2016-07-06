From: tom.ty89@gmail.com
Subject: [PATCH resend 2/2] libata-scsi: correct cbd to CDB in comment
Date: Thu,  7 Jul 2016 01:13:09 +0800
Message-ID: <577d3c39.949b620a.2f8b5.ffffb1c5@mx.google.com>
References: <20160706171309.1772-1-me>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34277 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbcGFRNa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 13:13:30 -0400
In-Reply-To: <20160706171309.1772-1-me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com, sergei.shtylyov@cogentembedded.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

It's Command Descriptor Block. Also capitalized it.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index f1125fd..c9cd216 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -304,7 +304,7 @@ static void ata_scsi_set_invalid_field(struct ata_device *dev,
 				       struct scsi_cmnd *cmd, u16 field, u8 bit)
 {
 	ata_scsi_set_sense(dev, cmd, ILLEGAL_REQUEST, 0x24, 0x0);
-	/* "Invalid field in cbd" */
+	/* "Invalid field in CDB" */
 	scsi_set_sense_field_pointer(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
 				     field, bit, 1);
 }
-- 
2.9.0

