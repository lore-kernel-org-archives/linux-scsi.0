From: Colin King <colin.king@canonical.com>
Subject: [PATCH] qla2xxx: fix spelling mistake: "seperator" -> "separator"
Date: Thu, 23 Feb 2017 10:57:23 +0000
Message-ID: <20170223105723.12401-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51583 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbdBWK5v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Feb 2017 05:57:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake in pr_err message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index c2f8c35..8e8ab0f 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1792,7 +1792,7 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
 
 	p = strchr(tmp, '@');
 	if (!p) {
-		pr_err("Unable to locate NPIV '@' seperator\n");
+		pr_err("Unable to locate NPIV '@' separator\n");
 		return ERR_PTR(-EINVAL);
 	}
 	*p++ = '\0';
-- 
2.10.2
