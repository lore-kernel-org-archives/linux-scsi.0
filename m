From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] scsi: hpsa: make access_method const
Date: Wed, 30 Aug 2017 19:23:12 +0530
Message-ID: <1504101192-17837-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: julia.lawall@lip6.fr, don.brace@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Make these const as they are not modified anywhere.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
To compile-test hpsa.h, I test-compiled scsi/hpsa.c which
includes this file.

 drivers/scsi/hpsa.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 018f980..4688b8f 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -628,28 +628,28 @@ static unsigned long SA5_ioaccel_mode1_completed(struct ctlr_info *h, u8 q)
 	.command_completed =	SA5_completed,
 };
 
-static struct access_method SA5_ioaccel_mode1_access = {
+static const struct access_method SA5_ioaccel_mode1_access = {
 	.submit_command =	SA5_submit_command,
 	.set_intr_mask =	SA5_performant_intr_mask,
 	.intr_pending =		SA5_ioaccel_mode1_intr_pending,
 	.command_completed =	SA5_ioaccel_mode1_completed,
 };
 
-static struct access_method SA5_ioaccel_mode2_access = {
+static const struct access_method SA5_ioaccel_mode2_access = {
 	.submit_command =	SA5_submit_command_ioaccel2,
 	.set_intr_mask =	SA5_performant_intr_mask,
 	.intr_pending =		SA5_performant_intr_pending,
 	.command_completed =	SA5_performant_completed,
 };
 
-static struct access_method SA5_performant_access = {
+static const struct access_method SA5_performant_access = {
 	.submit_command =	SA5_submit_command,
 	.set_intr_mask =	SA5_performant_intr_mask,
 	.intr_pending =		SA5_performant_intr_pending,
 	.command_completed =	SA5_performant_completed,
 };
 
-static struct access_method SA5_performant_access_no_read = {
+static const struct access_method SA5_performant_access_no_read = {
 	.submit_command =	SA5_submit_command_no_read,
 	.set_intr_mask =	SA5_performant_intr_mask,
 	.intr_pending =		SA5_performant_intr_pending,
-- 
1.9.1
