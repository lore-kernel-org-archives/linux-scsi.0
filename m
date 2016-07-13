From: tom.ty89@gmail.com
Subject: [RFC 1/3] ata: bump ATA_MAX_SECTORS_LBA48 to 65536
Date: Wed, 13 Jul 2016 12:47:06 +0800
Message-ID: <1c10437e3cd9be8556e77462b40ad53be542dfba.1468384890.git.tom.ty89@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33172 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbcGMEr5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2016 00:47:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

ATA_MAX_SECTORS_LBA48 is only used for setting the queue limit
"max_hw_sectors", which only serves as the cap for "max_sectors",
which is in turn the actual limit being used. Therefore, it should
be alright for us to bump ATA_MAX_SECTORS_LBA48 to 65536. Also,
lba_48_ok() has been accepting the number of blocks to be 65536.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/include/linux/ata.h b/include/linux/ata.h
index 99346be..24f886c 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -46,7 +46,7 @@ enum {
 	ATA_MAX_SECTORS_128	= 128,
 	ATA_MAX_SECTORS		= 256,
 	ATA_MAX_SECTORS_1024    = 1024,
-	ATA_MAX_SECTORS_LBA48	= 65535,/* TODO: 65536? */
+	ATA_MAX_SECTORS_LBA48	= 65536,
 	ATA_MAX_SECTORS_TAPE	= 65535,
 
 	ATA_ID_WORDS		= 256,
-- 
2.9.0

