From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 17/42] qla2xxx: Enable fw_dump_size for ISP8044.
Date: Fri, 11 Apr 2014 16:54:22 -0400
Message-ID: <1397249687-32666-18-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:50791 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754747AbaDKVb7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:31:59 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Hiral Patel <hiral.patel@qlogic.com>

Signed-off-by: Hiral Patel <hiral.patel@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 07befcf..bc0cee3 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1495,7 +1495,7 @@ qla2x00_fw_dump_size_show(struct device *dev, struct device_attribute *attr,
 
 	if (!ha->fw_dumped)
 		size = 0;
-	else if (IS_QLA82XX(ha))
+	else if (IS_P3P_TYPE(ha))
 		size = ha->md_template_size + ha->md_dump_size;
 	else
 		size = ha->fw_dump_len;
-- 
1.7.7

