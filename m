From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 25/35] qla2xxx: Free sysfs attributes for ISP27xx.
Date: Wed, 24 Sep 2014 03:08:28 -0400
Message-ID: <1411542518-2477-26-git-send-email-saurav.kashyap@qlogic.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:62417 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753118AbaIXHmp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 03:42:45 -0400
In-Reply-To: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Nigel Kirkland <nigel.kirkland@qlogic.com>

Signed-off-by: Nigel Kirkland <nigel.kirkland@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 677239f..9391e4b 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -987,6 +987,8 @@ qla2x00_free_sysfs_attr(scsi_qla_host_t *vha, bool stop_beacon)
 			continue;
 		if (iter->is4GBp_only == 3 && !(IS_CNA_CAPABLE(vha->hw)))
 			continue;
+		if (iter->is4GBp_only == 0x27 && !IS_QLA27XX(vha->hw))
+			continue;
 
 		sysfs_remove_bin_file(&host->shost_gendev.kobj,
 		    iter->attr);
-- 
1.7.7

