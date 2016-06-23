From: Colin King <colin.king@canonical.com>
Subject: [PATCH] tcm_qla2xxx: fix spelling mistake: "seperator" -> "separator"
Date: Thu, 23 Jun 2016 18:12:25 +0100
Message-ID: <1466701945-8510-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54192 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbcFWRMp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jun 2016 13:12:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in pr_err message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 6643f6f..46fe6f4 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1738,7 +1738,7 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
 
 	p = strchr(tmp, '@');
 	if (!p) {
-		pr_err("Unable to locate NPIV '@' seperator\n");
+		pr_err("Unable to locate NPIV '@' separator\n");
 		return ERR_PTR(-EINVAL);
 	}
 	*p++ = '\0';
-- 
2.8.1

