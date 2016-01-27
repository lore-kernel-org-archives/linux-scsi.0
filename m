From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH v2 02/11] qla2xxx: Seed init-cb login timeout from nvram exclusively.
Date: Wed, 27 Jan 2016 12:03:29 -0500
Message-ID: <1453914218-380-3-git-send-email-himanshu.madhani@qlogic.com>
References: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:41997 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933711AbcA0RqA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2016 12:46:00 -0500
In-Reply-To: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 52a8765..a663ff6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2844,7 +2844,6 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	if (nv->login_timeout < 4)
 		nv->login_timeout = 4;
 	ha->login_timeout = nv->login_timeout;
-	icb->login_timeout = nv->login_timeout;
 
 	/* Set minimum RATOV to 100 tenths of a second. */
 	ha->r_a_tov = 100;
@@ -5274,7 +5273,6 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 	if (le16_to_cpu(nv->login_timeout) < 4)
 		nv->login_timeout = cpu_to_le16(4);
 	ha->login_timeout = le16_to_cpu(nv->login_timeout);
-	icb->login_timeout = nv->login_timeout;
 
 	/* Set minimum RATOV to 100 tenths of a second. */
 	ha->r_a_tov = 100;
@@ -6231,7 +6229,6 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 	if (le16_to_cpu(nv->login_timeout) < 4)
 		nv->login_timeout = cpu_to_le16(4);
 	ha->login_timeout = le16_to_cpu(nv->login_timeout);
-	icb->login_timeout = nv->login_timeout;
 
 	/* Set minimum RATOV to 100 tenths of a second. */
 	ha->r_a_tov = 100;
-- 
1.7.7

