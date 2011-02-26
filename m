From: shyam.iyer.t@gmail.com
Subject: [PATCH 2/2] [SCSI] Update scsi constants
Date: Sat, 26 Feb 2011 01:59:45 -0500
Message-ID: <1298703585-15387-3-git-send-email-shyam_iyer@dell.com>
References: <1298703585-15387-1-git-send-email-shyam_iyer@dell.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62621 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1BZHAi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Feb 2011 02:00:38 -0500
Received: by mail-qy0-f181.google.com with SMTP id 14so2072783qyg.19
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2011 23:00:20 -0800 (PST)
In-Reply-To: <1298703585-15387-1-git-send-email-shyam_iyer@dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Shyam Iyer <shyam_iyer@dell.com>

From: Shyam Iyer <shyam_iyer@dell.com>

Update scsi/constants.c with the asc/ascqs for THIN PROVISIONING SOFT THRESHOLD REACHED Unit Attention

Signed-off-by: Shyam Iyer <shyam_iyer@dell.com>
---
 drivers/scsi/constants.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index d0c8234..60d2ef2 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -772,6 +772,7 @@ static const struct error_info additional[] =
 	{0x3802, "Esn - power management class event"},
 	{0x3804, "Esn - media class event"},
 	{0x3806, "Esn - device busy class event"},
+	{0x3807, "Thin Provisioning soft threshold reached"},
 
 	{0x3900, "Saving parameters not supported"},
 
-- 
1.7.2.3

