From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 02/15] scsi: NCR5380: Return false instead of NULL
Date: Thu, 22 Nov 2018 14:56:08 -0500
Message-ID: <20181122195621.13776-2-sashal@kernel.org>
References: <20181122195621.13776-1-sashal@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181122195621.13776-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Finn Thain <fthain@telegraphics.com.au>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 96edebd6bb995f2acb7694bed6e01bf6f5a7b634 ]

I overlooked this statement when I recently converted the function result
type from struct scsi_cmnd * to bool. No change to object code.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 790babc5ef66..d8ee22733a18 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1284,7 +1284,7 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 
 out:
 	if (!hostdata->selecting)
-		return NULL;
+		return false;
 	hostdata->selecting = NULL;
 	return cmd;
 }
-- 
2.17.1
