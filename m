From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 37/42] qla2xxx: Remove mapped vp index iterator macro dead code.
Date: Fri, 11 Apr 2014 16:54:42 -0400
Message-ID: <1397249687-32666-38-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:2065 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755043AbaDKVcF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:05 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Himanshu Madhani <himanshu.madhani@qlogic.com>

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_fw.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 2cdedd9..eb8f572 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1137,13 +1137,6 @@ struct device_reg_24xx {
 #define MIN_MULTI_ID_FABRIC	64	/* Must be power-of-2. */
 #define MAX_MULTI_ID_FABRIC	256	/* ... */
 
-#define for_each_mapped_vp_idx(_ha, _idx)		\
-	for (_idx = find_next_bit((_ha)->vp_idx_map,	\
-		(_ha)->max_npiv_vports + 1, 1);		\
-	    _idx <= (_ha)->max_npiv_vports;		\
-	    _idx = find_next_bit((_ha)->vp_idx_map,	\
-		(_ha)->max_npiv_vports + 1, _idx + 1))	\
-
 struct mid_conf_entry_24xx {
 	uint16_t reserved_1;
 
-- 
1.7.7

