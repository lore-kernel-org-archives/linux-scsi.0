From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 07/15] qla2xxx: Correct typo in read_nvram() callback.
Date: Mon,  6 Apr 2009 22:33:43 -0700
Message-ID: <1239082431-19496-8-git-send-email-andrew.vasquez@qlogic.com>
References: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29400 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZDGFd6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 01:33:58 -0400
In-Reply-To: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index f3536e5..fc30f8e 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -97,7 +97,7 @@ qla2x00_sysfs_read_nvram(struct kobject *kobj,
 		return 0;
 
 	if (IS_NOCACHE_VPD_TYPE(ha))
-		ha->isp_ops->read_optrom(vha, ha->vpd, ha->flt_region_nvram << 2,
+		ha->isp_ops->read_optrom(vha, ha->nvram, ha->flt_region_nvram << 2,
 		    ha->nvram_size);
 	return memory_read_from_buffer(buf, count, &off, ha->nvram,
 					ha->nvram_size);
-- 
1.6.2.2.404.ge96f3

