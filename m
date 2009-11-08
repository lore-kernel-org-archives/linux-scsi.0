From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH 12/20] scsi/gdth_proc: No longer use Scsi_Cmd typedef
Date: Sun, 08 Nov 2009 17:17:19 -0300
Message-ID: <1257711439.4759.118.camel@dbueso-pc>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755199AbZKHUZi@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 drivers/scsi/gdth_proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 1258da3..74e44ed 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -726,7 +726,7 @@ static void gdth_wait_completion(gdth_ha_str *ha, int busnum, int id)
 {
     ulong flags;
     int i;
-    Scsi_Cmnd *scp;
+    struct scsi_cmnd *scp;
     struct gdth_cmndinfo *cmndinfo;
     unchar b, t;
 
