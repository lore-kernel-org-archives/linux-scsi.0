From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: bnx2i: fix indentation issue, remove a tab
Date: Fri,  4 Jan 2019 17:02:24 +0000
Message-ID: <20190104170224.8147-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The return statement is indented incorrectly, fix this by removing a
single tab.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 69c75426c5eb..c5fa5f3b00e9 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -577,7 +577,7 @@ static void bnx2i_free_mp_bdt(struct bnx2i_hba *hba)
 				  hba->dummy_buffer, hba->dummy_buf_dma);
 		hba->dummy_buffer = NULL;
 	}
-		return;
+	return;
 }
 
 /**
-- 
2.19.1
