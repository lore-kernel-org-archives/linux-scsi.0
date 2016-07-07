From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH trivial] fcoe: use defines from ethtool for 20Gbit and 40Gbit speeds
Date: Thu,  7 Jul 2016 15:41:58 +0200
Message-ID: <1467898918-90352-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbcGGNmJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2016 09:42:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Jiri Kosina <trivial@kernel.org>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, fcoe-devel@open-fcoe.org, Johannes Thumshirn <jthumshirn@suse.de>

Use defines from ethtool for 20Gbit and 40Gbit speeds instead of magic
numbers.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/fcoe/fcoe_transport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index 641c60e..7028dd3 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -133,10 +133,10 @@ int fcoe_link_speed_update(struct fc_lport *lport)
 		case SPEED_10000:
 			lport->link_speed = FC_PORTSPEED_10GBIT;
 			break;
-		case 20000:
+		case SPEED_20000:
 			lport->link_speed = FC_PORTSPEED_20GBIT;
 			break;
-		case 40000:
+		case SPEED_40000:
 			lport->link_speed = FC_PORTSPEED_40GBIT;
 			break;
 		default:
-- 
1.8.5.6

