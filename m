From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH] Missing raid1e string in raid levels is added
Date: Wed, 17 Feb 2010 16:13:04 +0530
Message-ID: <20100217104252.GC24075@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:50582 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000Ab0BQLMo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Feb 2010 06:12:44 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Missing raid class string "raid1e" is included in this patch.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/raid_class.c b/drivers/scsi/raid_class.c
index 8e5c169..bd88349 100644
--- a/drivers/scsi/raid_class.c
+++ b/drivers/scsi/raid_class.c
@@ -149,6 +149,7 @@ static struct {
 	{ RAID_LEVEL_0, "raid0" },
 	{ RAID_LEVEL_1, "raid1" },
 	{ RAID_LEVEL_10, "raid10" },
+	{ RAID_LEVEL_1E, "raid1e" },
 	{ RAID_LEVEL_3, "raid3" },
 	{ RAID_LEVEL_4, "raid4" },
 	{ RAID_LEVEL_5, "raid5" },
