From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] scsi_debug: clear_luns_changed_on_target return type should be "void"
Date: Fri,  2 Jan 2015 12:53:43 -0500
Message-ID: <1420221223-7247-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbbABRxq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jan 2015 12:53:46 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t02HrjWA003691
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 2 Jan 2015 12:53:46 -0500
Received: from emilne.csb ([10.18.25.104])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t02Hrj0s009754
	for <linux-scsi@vger.kernel.org>; Fri, 2 Jan 2015 12:53:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Reported by Fengguang Wu (kbuild test robot).

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5ac04d6..edc60fa 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -792,7 +792,7 @@ static int scsi_debug_ioctl(struct scsi_device *dev, int cmd, void __user *arg)
 	/* return -ENOTTY; // correct return but upsets fdisk */
 }
 
-static int clear_luns_changed_on_target(struct sdebug_dev_info *devip)
+static void clear_luns_changed_on_target(struct sdebug_dev_info *devip)
 {
 	struct sdebug_host_info *sdhp;
 	struct sdebug_dev_info *dp;
-- 
1.7.11.7

