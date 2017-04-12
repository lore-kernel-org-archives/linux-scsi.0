From: Colin King <colin.king@canonical.com>
Subject: [PATCH] snic: fix spelling mistake: "Cann't" -> "Cannot"
Date: Wed, 12 Apr 2017 15:12:35 +0100
Message-ID: <20170412141235.18094-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Karan Tilak Kumar <kartilak@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in SNIC_ERR error message text,
one cannot have "Cann't".

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/snic/snic_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/snic/snic_debugfs.c b/drivers/scsi/snic/snic_debugfs.c
index d30280326bde..269ddf791a73 100644
--- a/drivers/scsi/snic/snic_debugfs.c
+++ b/drivers/scsi/snic/snic_debugfs.c
@@ -548,7 +548,7 @@ snic_trc_debugfs_init(void)
 				 &snic_trc_fops);
 
 	if (!de) {
-		SNIC_ERR("Cann't create trace file.\n");
+		SNIC_ERR("Cannot create trace file.\n");
 
 		return ret;
 	}
-- 
2.11.0

