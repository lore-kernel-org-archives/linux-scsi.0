From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] hpsa: move lockup_detected attribute to host attr
Date: Mon,  7 Sep 2015 18:14:49 +0200
Message-ID: <1441642489-5036-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbbIGQOw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Sep 2015 12:14:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: don.brace@pmcs.com, Justin.Lindley@pmcs.com, elliott@hp.com, Kevin.Barnett@pmcs.com, scott.teel@pmcs.com, hch@infradead.org

This patch fixes a 'general protection fault' issue by
moving the attribute to where it was likely meant.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 40669f8dd0..0f96bf1082 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -848,7 +848,6 @@ static struct device_attribute *hpsa_sdev_attrs[] = {
 	&dev_attr_unique_id,
 	&dev_attr_hp_ssd_smart_path_enabled,
 	&dev_attr_path_info,
-	&dev_attr_lockup_detected,
 	NULL,
 };
 
@@ -860,6 +859,7 @@ static struct device_attribute *hpsa_shost_attrs[] = {
 	&dev_attr_resettable,
 	&dev_attr_hp_ssd_smart_path_status,
 	&dev_attr_raid_offload_debug,
+	&dev_attr_lockup_detected,
 	NULL,
 };
 
-- 
2.4.3

