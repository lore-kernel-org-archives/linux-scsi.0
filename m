From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 2/8] be2iscsi: Fix port speed typo in driver.
Date: Wed, 29 Jan 2014 02:16:40 -0500
Message-ID: <1390979807-16718-2-git-send-email-Jayamohan.Kallickal@emulex.com>
References: <1390979807-16718-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:55986 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaA2HQ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jan 2014 02:16:59 -0500
Received: by mail-pb0-f43.google.com with SMTP id md12so1419117pbc.16
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2014 23:16:59 -0800 (PST)
In-Reply-To: <1390979807-16718-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 The 100Mbps port speed macro used was not proper.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index bdd0f05..a7a210e 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -793,7 +793,7 @@ static int beiscsi_get_port_speed(struct Scsi_Host *shost)
 		ihost->port_speed = ISCSI_PORT_SPEED_10MBPS;
 		break;
 	case BE2ISCSI_LINK_SPEED_100MBPS:
-		ihost->port_speed = BE2ISCSI_LINK_SPEED_100MBPS;
+		ihost->port_speed = ISCSI_PORT_SPEED_100MBPS;
 		break;
 	case BE2ISCSI_LINK_SPEED_1GBPS:
 		ihost->port_speed = ISCSI_PORT_SPEED_1GBPS;
-- 
1.8.5.3

