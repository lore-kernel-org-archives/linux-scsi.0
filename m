From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] scsi/atari_scsi: Remove obsolete variable oldto
Date: Mon,  6 Jun 2011 22:00:51 +0200
Message-ID: <1307390451-29536-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

commit 8ce7955aa52c37db1425ea4bd4edcfa67e253454 ("[SCSI] atari_NCR5380:
update_timeout removal") removed all users, but not the avtual variable.

Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/atari_NCR5380.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index ea439f9..24652f1 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -914,7 +914,6 @@ static int NCR5380_queue_command_lck(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
 {
 	SETUP_HOSTDATA(cmd->device->host);
 	Scsi_Cmnd *tmp;
-	int oldto;
 	unsigned long flags;
 
 #if (NDEBUG & NDEBUG_NO_WRITE)
-- 
1.7.0.4
