From: giridhar.malavali@qlogic.com
Subject: [PATCH 4/9] qla2xxx: Set the size of the host buffer used to fetch DCBX and XGMAC parameters to 4K.
Date: Tue, 13 Oct 2009 15:16:48 -0700
Message-ID: <1255472213-472-5-git-send-email-giridhar.malavali@qlogic.com>
References: <1255472213-472-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:49691 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755252AbZJMWYP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2009 18:24:15 -0400
In-Reply-To: <1255472213-472-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index d8ce310..6b9bf23 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2440,11 +2440,11 @@ struct qla_hw_data {
 	dma_addr_t	edc_data_dma;
 	uint16_t	edc_data_len;
 
-#define XGMAC_DATA_SIZE	PAGE_SIZE
+#define XGMAC_DATA_SIZE	4096
 	void		*xgmac_data;
 	dma_addr_t	xgmac_data_dma;
 
-#define DCBX_TLV_DATA_SIZE PAGE_SIZE
+#define DCBX_TLV_DATA_SIZE 4096
 	void		*dcbx_tlv;
 	dma_addr_t	dcbx_tlv_dma;
 
-- 
1.6.2.rc1.30.gd43c

