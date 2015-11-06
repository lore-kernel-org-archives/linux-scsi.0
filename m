From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH RESEND] hpsa: move lockup_detected attribute to host attr
Date: Fri,  6 Nov 2015 16:24:09 +0100
Message-ID: <1446823449-3986-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbbKFPYM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Nov 2015 10:24:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: don.brace@pmcs.com

This patch fixes a 'general protection fault' issue by
moving the attribute to where it was likely meant.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 57166e68fc..6d4412359d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -867,7 +867,6 @@ static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_unique_id,
 	&dev_attr_hp_ssd_smart_path_enabled,
 	&dev_attr_path_info,
-	&dev_attr_lockup_detected,
 	NULL,
 };
 
@@ -879,6 +878,7 @@ static struct device_attribute *hpsa_shost_attrs[] = {
 	&dev_attr_resettable,
 	&dev_attr_hp_ssd_smart_path_status,
 	&dev_attr_raid_offload_debug,
+	&dev_attr_lockup_detected,
 	NULL,
 };
 
-- 
2.4.3

