From: Joe Perches <joe@perches.com>
Subject: [PATCH 25/44] drivers/scsi/pm8001: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:44 -0800
Message-ID: <20b352f91642ca45ad730d8eeec0bbd323d26626.1289789605.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>
Cc: jack_wang@usish.com, lindar_liu@usish.com, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/pm8001/pm8001_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index f8c86b2..be210dd 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -160,7 +160,7 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
 static void pm8001_tasklet(unsigned long opaque)
 {
 	struct pm8001_hba_info *pm8001_ha;
-	pm8001_ha = (struct pm8001_hba_info *)opaque;;
+	pm8001_ha = (struct pm8001_hba_info *)opaque;
 	if (unlikely(!pm8001_ha))
 		BUG_ON(1);
 	PM8001_CHIP_DISP->isr(pm8001_ha);
-- 
1.7.3.1.g432b3.dirty
