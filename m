From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH 1/2] cciss: remove duplicate entries from board_type struct
Date: Tue, 17 Feb 2015 17:40:21 +0100
Message-ID: <1424191222-30570-1-git-send-email-thenzl@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: don.brace@pmcs.com, linux-kernel@vger.kernel.org, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

and devices not supported by this driver from unresettable list

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/block/cciss.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index ff20f192b0..48498220cd 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -139,8 +139,6 @@ static struct board_type products[] = {
 	{0x3214103C, "Smart Array E200i", &SA5_access},
 	{0x3215103C, "Smart Array E200i", &SA5_access},
 	{0x3237103C, "Smart Array E500", &SA5_access},
-	{0x3223103C, "Smart Array P800", &SA5_access},
-	{0x3234103C, "Smart Array P400", &SA5_access},
 	{0x323D103C, "Smart Array P700m", &SA5_access},
 };
 
@@ -574,8 +572,6 @@ static void cciss_procinit(ctlr_info_t *h)
 
 /* List of controllers which cannot be hard reset on kexec with reset_devices */
 static u32 unresettable_controller[] = {
-	0x324a103C, /* Smart Array P712m */
-	0x324b103C, /* SmartArray P711m */
 	0x3223103C, /* Smart Array P800 */
 	0x3234103C, /* Smart Array P400 */
 	0x3235103C, /* Smart Array P400i */
-- 
1.9.3
