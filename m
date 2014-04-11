From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 23/42] qla2xxx: Remove unnecessary printk_ratelimited from qla_nx2.c
Date: Fri, 11 Apr 2014 16:54:28 -0400
Message-ID: <1397249687-32666-24-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:55579 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754688AbaDKVcA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:00 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx2.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 73ca8ed..75e947a 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -2397,8 +2397,6 @@ qla8044_minidump_process_rdmem(struct scsi_qla_host *vha,
 		}
 
 		if (j >= MAX_CTL_CHECK) {
-			printk_ratelimited(KERN_ERR
-			    "%s: failed to read through agent\n", __func__);
 			write_unlock_irqrestore(&ha->hw_lock, flags);
 			return QLA_SUCCESS;
 		}
-- 
1.7.7

