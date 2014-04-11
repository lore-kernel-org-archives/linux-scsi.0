From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 36/42] qla2xxx: Add MBC option for fast SFP data access.
Date: Fri, 11 Apr 2014 16:54:41 -0400
Message-ID: <1397249687-32666-37-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51553 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754689AbaDKVcF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:05 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 900411a..16fe519 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -664,7 +664,7 @@ do_read:
 		}
 
 		rval = qla2x00_read_sfp(vha, ha->sfp_data_dma, ha->sfp_data,
-		    addr, offset, SFP_BLOCK_SIZE, 0);
+		    addr, offset, SFP_BLOCK_SIZE, BIT_1);
 		if (rval != QLA_SUCCESS) {
 			ql_log(ql_log_warn, vha, 0x706d,
 			    "Unable to read SFP data (%x/%x/%x).\n", rval,
-- 
1.7.7

