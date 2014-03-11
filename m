From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH trivial 15/16] [SCSI] aic7xxx: Spelling s/termnation/termination/
Date: Tue, 11 Mar 2014 11:23:49 +0100
Message-ID: <1394533430-4746-15-git-send-email-geert@linux-m68k.org>
References: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@linux-m68k.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/aic7xxx/aic79xx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index 9b059422aacb..113874c1284b 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -911,7 +911,7 @@ struct vpd_config {
 	uint8_t  length;
 	uint8_t  revision;
 	uint8_t  device_flags;
-	uint8_t  termnation_menus[2];
+	uint8_t  termination_menus[2];
 	uint8_t  fifo_threshold;
 	uint8_t  end_tag;
 	uint8_t  vpd_checksum;
-- 
1.7.9.5
