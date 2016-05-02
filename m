From: tom.ty89@gmail.com
Subject: [PATCH 2/3] libata-scsi: Fix SCSI INQUIRY version descriptor
Date: Tue,  3 May 2016 04:13:20 +0800
Message-ID: <5727b4ec.c923620a.641f4.17aa@mx.google.com>
References: <1462220001-2566-1-git-send-email-me>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36108 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbcEBUNd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2016 16:13:33 -0400
In-Reply-To: <1462220001-2566-1-git-send-email-me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

https://bugzilla.kernel.org/show_bug.cgi?id=106931
Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index cd30f11..0295c38 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1985,8 +1985,8 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
 		0x03,
 		0x20,	/* SBC-2 (no version claimed) */
 
-		0x02,
-		0x60	/* SPC-3 (no version claimed) */
+		0x03,
+		0x00	/* SPC-3 (no version claimed) */
 	};
 	const u8 versions_zbc[] = {
 		0x00,
-- 
2.8.2

