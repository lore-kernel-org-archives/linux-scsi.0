From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/9] qla2xxx: Use proper prep_ms_iocb() function during GFPN_ID.
Date: Wed, 13 Dec 2006 19:20:27 -0800
Message-ID: <11660664333651-git-send-email-andrew.vasquez@qlogic.com>
References: <20061214031935.GB538@andrew-vasquezs-powerbook-g4-15.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:39867 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbWLNDdq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Dec 2006 22:33:46 -0500
In-Reply-To: <20061214031935.GB538@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index f8bd33e..220ec41 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1683,7 +1683,7 @@ qla2x00_gfpn_id(scsi_qla_host_t *ha, sw_info_t *list)
 		memset(list[i].fabric_port_name, 0, WWN_SIZE);
 
 		/* Prepare common MS IOCB */
-		ms_pkt = qla2x00_prep_ms_iocb(ha, GFPN_ID_REQ_SIZE,
+		ms_pkt = ha->isp_ops.prep_ms_iocb(ha, GFPN_ID_REQ_SIZE,
 		    GFPN_ID_RSP_SIZE);
 
 		/* Prepare CT request */
-- 
1.4.4.2.g4cfec

