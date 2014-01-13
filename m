From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 2/7] be2iscsi: Fix port speed typo in driver.
Date: Sun, 12 Jan 2014 16:42:15 -0800
Message-ID: <1389573741-3523-2-git-send-email-jayamohan.kallickal@emulex.com>
References: <1389573741-3523-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50262 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaAMCiN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2014 21:38:13 -0500
Received: by mail-pd0-f176.google.com with SMTP id r10so2834831pdi.35
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jan 2014 18:38:13 -0800 (PST)
In-Reply-To: <1389573741-3523-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 The 100Mbps port speed macro used was not proper.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 867f3d3..2843a67 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -795,7 +795,7 @@ static int beiscsi_get_port_speed(struct Scsi_Host *shost)
 		ihost->port_speed = ISCSI_PORT_SPEED_10MBPS;
 		break;
 	case BE2ISCSI_LINK_SPEED_100MBPS:
-		ihost->port_speed = BE2ISCSI_LINK_SPEED_100MBPS;
+		ihost->port_speed = ISCSI_PORT_SPEED_100MBPS;
 		break;
 	case BE2ISCSI_LINK_SPEED_1GBPS:
 		ihost->port_speed = ISCSI_PORT_SPEED_1GBPS;
-- 
1.7.10.4

