From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 06/35] qla2xxx: Enable fast flash access for ISP83xx.
Date: Thu, 25 Sep 2014 05:16:37 -0400
Message-ID: <1411636626-7566-7-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:46418 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbaIYJvP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:15 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index bca173e..04b3701 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2580,7 +2580,8 @@ qla25xx_read_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
 	uint32_t faddr, left, burst;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (IS_QLA25XX(ha) || IS_QLA81XX(ha) || IS_QLA27XX(ha))
+	if (IS_QLA25XX(ha) || IS_QLA81XX(ha) || IS_QLA83XX(ha) ||
+	    IS_QLA27XX(ha))
 		goto try_fast;
 	if (offset & 0xfff)
 		goto slow_read;
-- 
1.7.7

